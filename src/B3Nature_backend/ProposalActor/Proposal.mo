import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import ProposalEngine "mo:dao-proposal-engine/ProposalEngine";
import Types "mo:dao-proposal-engine/Types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

actor ProposalActorB3Nature {

    public type ProposalContent = {
        title : Title;
        description : Text;
    };

    public type Title = {
        #ChangeStatus;
        #ReportedEvidence;
        #ReportedUser;
    };

    func titleToText(title : Title) : Text {
        switch (title) {
            case (#ChangeStatus) { "Changing Status" };
            case (#ReportedEvidence) { "Reported Evidence" };
            case (#ReportedUser) { "Reported User" };
        };
    };

    public type CreatedBy = {
        #ProposalByUser;
        #ProposalBySystem;
    };

    public type ProposalDescriptionBySystem = {
        #EvidenceReport;
        #UserReport;
        #Agreement;
    };

    stable var proposalsMap = Map.new<Nat, Types.Proposal<ProposalContent>>();
    stable var nextProposalId : Nat = 0;

    // Initialize with max proposal duration of 7 days, 50% voting threshold for auto execution and 20% quorum for execution after duration
    var data : Types.StableData<ProposalContent> = {
        proposals = Iter.toArray<Types.Proposal<ProposalContent>>(Map.vals(proposalsMap));
        proposalDuration = #days(7);
        votingThreshold = #percent({ percent = 50; quorum = ?20 });
    };

    let onProposalExecute = func(proposal : Types.Proposal<ProposalContent>) : async* Result.Result<(), Text> {
        Debug.print("Executing proposal: " # titleToText(proposal.content.title));
        #ok;
    };

    let onProposalReject = func(proposal : Types.Proposal<ProposalContent>) : async* () {
        Debug.print("Rejecting proposal: " # titleToText(proposal.content.title));
    };

    let onProposalValidate = func(content : ProposalContent) : async* Result.Result<(), [Text]> {
        if (content.title == "" or content.description == "") {
            return #err(["Title and description cannot be empty"]);
        };
        #ok;
    };

    let proposalEngine = ProposalEngine.ProposalEngine<system, ProposalContent>(data, onProposalExecute, onProposalReject, onProposalValidate);

    // Map get
    func get(id : Nat) : ?Types.Proposal<ProposalContent> {
        return Map.get(proposalsMap, nhash, id);
    };

    // Map put
    func put(id : Nat, proposal : Types.Proposal<ProposalContent>) : () {
        return Map.set(proposalsMap, nhash, id, proposal);
    };

    //  function to create a proposal
    func create(proposerId : Principal, content : ProposalContent, members : [Types.Member]) : async Result.Result<Nat, Types.CreateProposalError> {
        await* proposalEngine.createProposal(proposerId, content, members);
    };

    //  function to vote on a proposal
    func vote(proposalId : Nat, voterId : Principal, vote : Bool) : async Result.Result<(), Types.VoteError> {
        await* proposalEngine.vote(proposalId, voterId, vote);
    };

    public shared func createProposal(content : ProposalContent) : async Result.Result<Nat, Types.CreateProposalError> {

    };

};
