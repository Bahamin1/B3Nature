import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import ProposalEngine "mo:dao-proposal-engine/ProposalEngine";
import Types "mo:dao-proposal-engine/Types";
import Map "mo:map/Map";

module Proposal {

    public type Content = {
        title : Text;
        description : Text;

    };

    public type ProposalsMap = Map.Map<Nat, Types.StableData<Content>>;

    let data : Types.StableData<Content> = {
        proposals = [];
        proposalDuration = #days(7);
        votingThreshold = #percent({ percent = 50; quorum = ?20 });
    };

    let onProposalExecute = func(proposal : Types.Proposal<Content>) : async* Result.Result<(), Text> {
        Debug.print("Executing proposal: " # proposal.content.title);
        #ok;
    };

    let onProposalReject = func(proposal : Types.Proposal<Content>) : async* () {
        Debug.print("Rejecting proposal: " # proposal.content.title);
    };

    let onProposalValidate = func(content : Content) : async* Result.Result<(), [Text]> {
        if (content.title == "" or content.description == "") {
            return #err(["Title and description cannot be empty"]);
        };
        #ok;
    };

    public func create(proposalsMap : ProposalsMap, content : Content, proposerId : Nat) : async Result.Result<Nat, Types.CreateProposalError> {

    };

};

// actor ProposalActorB3Nature = {

//     public type ProposalContent = {
//         title : Title;
//         description : Text;
//     };

//     public type Title = {
//         #ChangeStatus;
//         #ReportedEvidence;
//         #ReportedUser;
//     };

//     func titleToText(title : Title) : Text {
//         switch (title) {
//             case (#ChangeStatus) { "Changing Status" };
//             case (#ReportedEvidence) { "Reported Evidence" };
//             case (#ReportedUser) { "Reported User" };
//         };
//     };

//     public type CreatedBy = {
//         #ProposalByUser;
//         #ProposalBySystem;
//     };

//     public type ProposalDescriptionBySystem = {
//         #EvidenceReport;
//         #UserReport;
//         #Agreement;
//     };

//     stable var agreementProposalsMap = Map.new<Nat, Types.Proposal<ProposalContent>>();
//     stable var reportProposalMap = Map.new<Nat, Types.Proposal<ProposalContent>>();
//     stable var nextProposalId : Nat = 0;

//     // Initialize with max proposal duration of 7 days, 50% voting threshold for auto execution and 20% quorum for execution after duration
//     let agreementProposalData : Types.StableData<ProposalContent> = {
//         proposals = Iter.toArray<Types.Proposal<ProposalContent>>(Map.vals(agreementProposalsMap));
//         proposalDuration = #days(7);
//         votingThreshold = #percent({ percent = 50; quorum = ?20 });
//     };

//     let reportProposalData : Types.StableData<ProposalContent> = {
//         proposals = Iter.toArray<Types.Proposal<ProposalContent>>(Map.vals(reportProposalMap));
//         proposalDuration = #days(5);
//         votingThreshold = #percent({ percent = 60; quorum = ?20 });
//     };

//     let onProposalExecute = func(proposal : Types.Proposal<ProposalContent>) : async* Result.Result<(), Text> {
//         Debug.print("Executing proposal: " # titleToText(proposal.content.title));
//         #ok;
//     };

//     let onProposalReject = func(proposal : Types.Proposal<ProposalContent>) : async* () {
//         Debug.print("Rejecting proposal: " # titleToText(proposal.content.title));
//     };

//     let onProposalValidate = func(content : ProposalContent) : async* Result.Result<(), [Text]> {

//         #ok;
//     };

//     let agreementProposalEngine = ProposalEngine.ProposalEngine<system, ProposalContent>(agreementProposalData, onProposalExecute, onProposalReject, onProposalValidate);
//     let reportProposalEngine = ProposalEngine.ProposalEngine<system, ProposalContent>(reportProposalData, onProposalExecute, onProposalReject, onProposalValidate);

//     //  function to create a proposal
//     public shared func create(proposerId : Principal, content : ProposalContent) : async Result.Result<Nat, Types.CreateProposalError> {
//         await* agreementProposalEngine.createProposal(proposerId, content);
//     };

//     //  function to vote on a proposal
//     public shared func vote(proposalId : Nat, voterId : Principal, vote : Bool) : async Result.Result<(), Types.VoteError> {
//         await* agreementProposalEngine.vote(proposalId, voterId, vote);
//     };

//     let stableData : Types.StableData<ProposalContent> = agreementProposalEngine.toStableData();

//     // public shared func createProposal(caller : Principal, content : ProposalContent, members : [Member]) : async Result.Result<Nat, Types.CreateProposalError> {

//     //     proposalEngine.createProposal(caller, content);
//     // };

// };
