import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Float "mo:base/Float";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import Itertools "mo:itertools/Iter";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

import Evidence "../Evidence";

module Proposal {

    public type Proposal<ProposalContent> = {
        id : Nat;
        proposerId : Principal;
        timeStart : Int;
        timeEnd : Int;
        endTimerId : ?Nat;
        content : ProposalContent;
        votes : [(Principal, Vote)];
        statusLog : [Status];
    };

    public type MutableProposal<ProposalContent> = {
        id : Nat;
        proposerId : Principal;
        timeStart : Int;
        timeEnd : Int;
        var endTimerId : ?Nat;
        content : ProposalContent;
        votes : HashMap.HashMap<Principal, Vote>;
        statusLog : Buffer.Buffer<Status>;
        votingSummary : VotingSummary;
    };

    public type Status = {

        #Executing : {
            time : Time.Time;
        };
        #Rejected : {
            time : Time.Time;
        };
        #Executed : {
            time : Time.Time;
        };
        #FailedToExecute : {
            time : Time.Time;
            error : Text;
        };
    };

    public type ProposalCreateError = {
        #NotAuthorized;
        #Invalid : [Text];
        #ProposalAlreadyExists;
    };

    public type VoteError = {
        #NotAuthorized;
        #AlreadyVoted;
        #VotingClosed;
        #ProposalNotFound;
    };

    public type VotingThreshold = {
        #Percent : { percent : Percent; quorum : ?Percent };
    };
    public type Percent = Nat; // 0-100

    public type Duration = {
        #Days : Nat;
        #Nanoseconds : Nat;
    };

    public type Vote = {
        yesOrNo : ?Bool;
        votingPower : Nat;
        member : Principal; // member who voted
    };

    type VotingSummary = {
        var yes : Nat;
        var no : Nat;
        var notVoted : Nat;
    };

    public type Content = {
        #AddManifesto : Text;
        #ChangeTreePlantingReward : Nat;
        #ChangeReportThreshold : Nat;
        #ChangeEcoCleanupReward : Nat;
        #ChangeAnimalProtectionReward : Nat;
        #MemberBan : BanDetail;
        #MemberUnban : BanDetail;
        #EvidenceConfermation : Evidence.Evidence;

    };

    public type PagedResult<T> = {
        data : [T];
        offset : Nat;
        count : Nat;
        total : Nat;
    };

    public type BanDetail = {
        detail : Text;
        member : Principal;
    };

    public type ProposalsMap = Map.Map<Nat, MutableProposal<Content>>;

    // Map get
    public func get(proposalsMap : ProposalsMap, id : Nat) : ?MutableProposal<Content> {
        return Map.get(proposalsMap, nhash, id);
    };

    // Map put
    public func put(proposalsMap : ProposalsMap, id : Nat, proposal : MutableProposal<Content>) : () {
        return Map.set(proposalsMap, nhash, id, proposal);
    };

    public type InitData<ProposalContent> = {
        proposals : [Proposal<ProposalContent>];
        proposalDuration : Duration;
        votingThreshold : VotingThreshold;
    };

    public class ProposalActor<system, ProposalContent>(
        data : InitData<ProposalContent>,
        onProposalExecute : Proposal<ProposalContent> -> async* Result.Result<(), Text>,
        onProposalReject : Proposal<ProposalContent> -> async* (),
        onProposalValidate : ProposalContent -> async* Result.Result<(), [Text]>,
    ) {

        let nextProposalId = data.proposals.size() + 1;
        var proposalDuration = data.proposalDuration;
        var votingThreshold = data.votingThreshold;

        func hashNat(n : Nat) : Nat32 = Nat32.fromNat(n); // TODO

        let proposalsIter = data.proposals.vals()
        |> Iter.map<Proposal<ProposalContent>, (Nat, MutableProposal<ProposalContent>)>(
            _,
            func(proposal : Proposal<ProposalContent>) : (Nat, MutableProposal<ProposalContent>) {
                let mutableProposal = toMutableProposal(proposal);
                (proposal.id, mutableProposal);
            },
        );

        var proposals = HashMap.fromIter<Nat, MutableProposal<ProposalContent>>(proposalsIter, 0, Nat.equal, hashNat);

        private func resetEndTimers<system>() {
            for (proposal in proposals.vals()) {
                switch (proposal.endTimerId) {
                    case (null) ();
                    case (?id) Timer.cancelTimer(id);
                };
                proposal.endTimerId := null;
                let currentStatus = getProposalStatus(proposal.statusLog);
                if (currentStatus == #open) {
                    let proposalDurationNanoseconds = durationToNanoseconds(proposalDuration);
                    let endTimerId = createEndTimer<system>(proposal.id, proposalDurationNanoseconds);
                    proposal.endTimerId := ?endTimerId;
                };
            };
        };

        public func getProposal(id : Nat) : ?Proposal<ProposalContent> {
            let ?proposal = proposals.get(id) else return null;
            ?{
                proposal with
                endTimerId = proposal.endTimerId;
                votes = Iter.toArray(proposal.votes.entries());
                statusLog = Buffer.toArray(proposal.statusLog);
                votingSummary = {
                    yes = proposal.votingSummary.yes;
                    no = proposal.votingSummary.no;
                    notVoted = proposal.votingSummary.notVoted;
                };
            };
        };

        public func getProposals(count : Nat, offset : Nat) : PagedResult<Proposal<ProposalContent>> {
            let vals = proposals.vals()
            |> Iter.map(
                _,
                func(proposal : MutableProposal<ProposalContent>) : Proposal<ProposalContent> = fromMutableProposal(proposal),
            )
            |> Itertools.sort(
                _,
                func(proposalA : Proposal<ProposalContent>, proposalB : Proposal<ProposalContent>) : Order.Order {
                    Int.compare(proposalA.timeStart, proposalB.timeStart);
                },
            )
            |> Itertools.skip(_, offset)
            |> Itertools.take(_, count)
            |> Iter.toArray(_);
            {
                data = vals;
                offset = offset;
                count = count;
                total = proposals.size();
            };
        };

        public func vote(proposalId : Nat, voterId : Principal, vote : Bool) : async* Result.Result<(), VoteError> {
            let ?proposal = proposals.get(proposalId) else return #err(#ProposalNotFound);
            let now = Time.now();
            let currentStatus = getProposalStatus(proposal.statusLog);
            if (proposal.timeStart > now or proposal.timeEnd < now or currentStatus != #open) {
                return #err(#VotingClosed);
            };
            let ?existingVote = proposal.votes.get(voterId); // Only allow members to vote who existed when the proposal was created
            if (existingVote.yesOrNo != null) {
                return #err(#AlreadyVoted);
            };
            await* voteInternal(proposal, voterId, vote, existingVote.votingPower);
            #ok;
        };

        private func voteInternal(proposal : MutableProposal<ProposalContent>, voterId : Principal, vote : Bool, votingPower : Nat) : async* () {
            proposal.votes.put(
                voterId,
                {
                    yesOrNo = ?vote;
                    votingPower = votingPower;
                    member = voterId;
                },
            );
            proposal.votingSummary.notVoted -= votingPower;
            if (vote) {
                proposal.votingSummary.yes += votingPower;
            } else {
                proposal.votingSummary.no += votingPower;
            };
            switch (calculateVoteStatus(proposal)) {
                case (#passed) {
                    await* executeOrRejectProposal(proposal, true);
                };
                case (#rejected) {
                    await* executeOrRejectProposal(proposal, false);
                };
                case (#undetermined) ();
            };
        };

        public func createProposal<system>(proposerId : Principal, content : ProposalContent) : async* Result.Result<Nat, ProposalCreateError> {
            let proposalId = nextProposalId;

            switch (await* onProposalValidate(content)) {
                case (#ok) ();
                case (#err(errors)) {
                    return #err(#Invalid(errors));
                };
            };

            let proposalDurationNanoseconds = durationToNanoseconds(proposalDuration);
            let endTimerId = createEndTimer<system>(proposalId, proposalDurationNanoseconds);
            let votes = HashMap.HashMap<Principal, Vote>(0, Principal.equal, Principal.hash);

            let proposal : MutableProposal<ProposalContent> = {
                id = proposalId;
                proposerId = proposerId;
                content = content;
                timeStart = Time.now();
                timeEnd = Time.now() + proposalDurationNanoseconds;
                var endTimerId = ?endTimerId;
                votes = votes;
                statusLog = Buffer.Buffer<Status>(0);
                votingSummary = buildVotingSummary(votes);
            };

            proposals.put(nextProposalId, proposal);
            #ok(proposalId);

        };

        private func durationToNanoseconds(duration : Duration) : Nat {
            switch (duration) {
                case (#Days(d)) d * 24 * 60 * 60 * 1_000_000_000;
                case (#Nanoseconds(n)) n;
            };
        };

        private func createEndTimer<system>(
            proposalId : Nat,
            proposalDurationNanoseconds : Nat,
        ) : Nat {
            Timer.setTimer<system>(
                #nanoseconds(proposalDurationNanoseconds),
                func() : async () {
                    switch (await* onProposalEnd(proposalId)) {
                        case (#ok) ();
                        case (#alreadyEnded) {
                            Debug.print("EndTimer: Proposal already ended: " # Nat.toText(proposalId));
                        };
                    };
                },
            );
        };

        private func onProposalEnd(proposalId : Nat) : async* {
            #ok;
            #alreadyEnded;
        } {
            let ?mutableProposal = proposals.get(proposalId) else Debug.trap("Proposal not found for onProposalEnd: " # Nat.toText(proposalId));
            switch (getProposalStatus(mutableProposal.statusLog)) {
                case (#open) {
                    let passed = switch (calculateVoteStatus(mutableProposal)) {
                        case (#passed) true;
                        case (#rejected or #undetermined) false;
                    };
                    await* executeOrRejectProposal(mutableProposal, passed);
                    #ok;
                };
                case (_) #alreadyEnded;
            };
        };

        private func executeOrRejectProposal(mutableProposal : MutableProposal<ProposalContent>, execute : Bool) : async* () {
            // TODO executing
            switch (mutableProposal.endTimerId) {
                case (null) ();
                case (?id) Timer.cancelTimer(id);
            };
            mutableProposal.endTimerId := null;
            let proposal = fromMutableProposal(mutableProposal);
            if (execute) {
                mutableProposal.statusLog.add(#Executing({ time = Time.now() }));

                let newStatus : Status = try {
                    switch (await* onProposalExecute(proposal)) {
                        case (#ok) #Executed({
                            time = Time.now();
                        });
                        case (#err(e)) #FailedToExecute({
                            time = Time.now();
                            error = e;
                        });
                    };
                } catch (e) {
                    #FailedToExecute({
                        time = Time.now();
                        error = Error.message(e);
                    });
                };
                mutableProposal.statusLog.add(newStatus);
            } else {
                mutableProposal.statusLog.add(#Rejected({ time = Time.now() }));
                await* onProposalReject(proposal);
            };
        };

        private func calculateVoteStatus(proposal : MutableProposal<ProposalContent>) : {
            #undetermined;
            #passed;
            #rejected;
        } {
            let votedVotingPower = proposal.votingSummary.yes + proposal.votingSummary.no;
            let totalVotingPower = votedVotingPower + proposal.votingSummary.notVoted;
            switch (votingThreshold) {
                case (#Percent({ percent; quorum })) {
                    let quorumThreshold = switch (quorum) {
                        case (null) 0;
                        case (?q) calculateFromPercent(q, totalVotingPower, false);
                    };
                    // The proposal must reach the quorum threshold in any case
                    if (votedVotingPower >= quorumThreshold) {
                        let hasEnded = proposal.timeEnd <= Time.now();
                        let voteThreshold = if (hasEnded) {
                            // If the proposal has reached the end time, it passes if the votes are above the threshold of the VOTED voting power
                            let votedPercent = votedVotingPower / totalVotingPower;
                            calculateFromPercent(percent, votedVotingPower, true);
                        } else {
                            // If the proposal has not reached the end time, it passes if votes are above the threshold (+1) of the TOTAL voting power
                            let votingThreshold = calculateFromPercent(percent, totalVotingPower, true);
                            if (votingThreshold >= totalVotingPower) {
                                // Safety with low total voting power to make sure the proposal can pass
                                totalVotingPower;
                            } else {
                                votingThreshold;
                            };
                        };
                        if (proposal.votingSummary.yes > proposal.votingSummary.no and proposal.votingSummary.yes >= voteThreshold) {
                            return #passed;
                        } else if (proposal.votingSummary.no > proposal.votingSummary.yes and proposal.votingSummary.no >= voteThreshold) {
                            return #rejected;
                        } else if (proposal.votingSummary.yes + proposal.votingSummary.no >= totalVotingPower) {
                            // If the proposal has reached the end time and the votes are equal, it is rejected
                            return #rejected;
                        };
                    };
                };
            };
            return #undetermined;
        };
        resetEndTimers<system>();

    };

    private func calculateFromPercent(percent : Nat, total : Nat, greaterThan : Bool) : Nat {
        let threshold = Float.fromInt(percent) / 100.0 * Float.fromInt(total);
        // If the threshold is an integer, add 1 to make sure the proposal passes
        let ceilThreshold = Float.toInt(Float.ceil(threshold));
        let fixedThreshold : Int = if (greaterThan and ceilThreshold == Float.toInt(Float.floor(threshold))) {
            // If the threshold is an integer, add 1 to make sure the proposal passes
            ceilThreshold + 1;
        } else {
            ceilThreshold;
        };
        Int.abs(fixedThreshold);
    };

    private func fromMutableProposal<ProposalContent>(proposal : MutableProposal<ProposalContent>) : Proposal<ProposalContent> = {
        proposal with
        endTimerId = proposal.endTimerId;
        votes = Iter.toArray(proposal.votes.entries());
        statusLog = Buffer.toArray(proposal.statusLog);
        votingSummary = {
            yes = proposal.votingSummary.yes;
            no = proposal.votingSummary.no;
            notVoted = proposal.votingSummary.notVoted;
        };
    };

    private func getProposalStatus(status : Buffer.Buffer<Status>) : Status or {
        #open;
    } {
        if (status.size() < 1) {
            return #open;
        };
        status.get(status.size() - 1);
    };

    private func buildVotingSummary(votes : HashMap.HashMap<Principal, Vote>) : VotingSummary {
        let votingSummary = {
            var yes = 0;
            var no = 0;
            var notVoted = 0;
        };

        for (vote in votes.vals()) {
            switch (vote.yesOrNo) {
                case (null) {
                    votingSummary.notVoted += vote.votingPower;
                };
                case (?true) {
                    votingSummary.yes += vote.votingPower;
                };
                case (?false) {
                    votingSummary.no += vote.votingPower;
                };
            };
        };
        votingSummary;
    };

    private func toMutableProposal<ProposalContent>(proposal : Proposal<ProposalContent>) : MutableProposal<ProposalContent> {
        let votes = HashMap.fromIter<Principal, Vote>(
            proposal.votes.vals(),
            proposal.votes.size(),
            Principal.equal,
            Principal.hash,
        );
        {
            proposal with
            var endTimerId = proposal.endTimerId;
            votes = votes;
            statusLog = Buffer.fromArray<Status>(proposal.statusLog);
            votingSummary = buildVotingSummary(votes);
        };
    };

};
