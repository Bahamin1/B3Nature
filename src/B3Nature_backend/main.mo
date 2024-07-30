import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import ProposalEngine "mo:dao-proposal-engine/ProposalEngine";
import Types "mo:dao-proposal-engine/Types";
import Map "mo:map/Map";

import Evidence "Evidence";
import Proposal "ProposalActor/Proposal";
import Report "Report";
import Review "Review";
import User "User";

actor class B3Nature() {

  stable var userMap : User.UserMap = Map.new<Principal, User.User>();
  stable var reportMap : Report.ReportMap = Map.new<Nat, Report.Report>();
  stable var evidenceMap : Evidence.EvidenceMap = Map.new<Nat, Evidence.Evidence>();
  stable var proposalsMap : Proposal.ProposalsMap = Map.new<Nat, Types.Proposal<Proposal.Content>>();

  private stable var reportThroshold : Nat = 10;
  private stable var treePlantingReward : Nat = 80;
  private stable var ecoCleanupReward : Nat = 50;
  private stable var animalProtectionReward : Nat = 40;

  private stable var manifesto : [Text] = [
    "1. We are committed to protecting the environment and promoting sustainable practices.",
    "2. We believe in the power of community and collaboration to drive positive change.",
    "3. We strive for transparency and accountability in all our actions.",
    "4. We value diversity and inclusivity in our organization and in the wider world.",
    "5. We are dedicated to continuous learning and improvement.",
    "6. We prioritize the well-being and safety of our members and the communities we serve.",
    "7. We are committed to ethical and responsible use of resources.",
    "8. We believe in the power of technology to create a better future for all.",
    "9. We are dedicated to promoting and protecting human rights and social justice.",
    "10. We are committed to upholding the principles of democracy and good governance.",
  ];

  private stable var nextReportId : Nat = 0;

  private stable var BlackList : [Principal] = [];

  private func isBanned(principal : Principal) : Bool {
    for (p in BlackList.vals()) {
      if (p == principal) {
        return true;
      };
    };
    false;
  };

  //register and Update members

  public shared ({ caller }) func registerAndUpdateMember(name : Text, email : Text, image : ?Blob) : async Result.Result<(Text), Text> {
    if (isBanned(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };
    switch (User.new(userMap, caller, name, email, image)) {
      case (#err(errmsg)) {
        return #err errmsg;
      };
      case (#ok(msg)) {
        return #ok msg;
      };
    };
  };

  //Get member by principal

  public query func getMember(p : Principal) : async ?User.User {
    return User.get(userMap, p);
  };

  // Add Review to user

  public shared ({ caller }) func addOrUpdateReviweForUser(userPrincipal : Principal, star : Review.Star, comment : ?Text) : async Result.Result<(Text), Text> {
    if (isBanned(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };
    if (User.isMember(userMap, caller)) {
      return #err("caller is not a Registered member");
    };

    switch (User.get(userMap, userPrincipal)) {
      case (null) {
        return #err("The user with principal " #Principal.toText(userPrincipal) # " does not exist!");
      };
      case (?user) {

        if (User.hasPoint(user, userPrincipal)) {
          let updateReview : Review.Review = {
            reviewBy = caller;
            comment = comment;
            point = star;
            cratedAt = Time.now();
          };

          switch (User.replaceUserPoint(userMap, user, caller, updateReview)) {
            case (#err(errmsg)) {
              return #err(errmsg);
            };
            case (#ok()) {
              return #ok("review successfully created");
            };
          };

        };
        let userReview = Buffer.fromArray<Review.Review>(user.review);
        userReview.add({
          reviewBy = caller;
          comment = comment;
          point = star;
          cratedAt = Time.now();
        });

        let starToNumb = Review.starToNumb(star);

        let updateUserReview : User.User = {
          user with review = Buffer.toArray<Review.Review>(userReview);
          reviewPoint = user.reviewPoint + starToNumb / user.totalReviewNumbers +1;
          totalReviewNumbers = user.totalReviewNumbers + 1;
        };

        User.put(userMap, userPrincipal, updateUserReview);

        return #ok("Review Update to user " #Principal.toText(userPrincipal) # " successfully!");
      };
    };
  };

  public shared ({ caller }) func addOrUpdateReviweForEvidence(evidenceId : Nat, star : Review.Star, comment : ?Text) : async Result.Result<(Text), Text> {
    if (isBanned(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };
    if (User.isMember(userMap, caller)) {
      return #err("caller is not a Registered member");
    };

    switch (Evidence.get(evidenceMap, evidenceId)) {
      case (null) {
        return #err("The Evidence with Id " #Nat.toText(evidenceId) # " does not exist!");
      };
      case (?evidence) {

        if (Evidence.hasPoint(evidence, caller)) {
          let updateReview : Review.Review = {
            reviewBy = caller;
            comment = comment;
            point = star;
            cratedAt = Time.now();
          };

          switch (Evidence.replaceEvidencePoint(evidenceMap, evidence, caller, updateReview)) {
            case (#err(errmsg)) {
              return #err(errmsg);
            };
            case (#ok()) {
              return #ok("review successfully created");
            };
          };

        };
        let evidenceReview = Buffer.fromArray<Review.Review>(evidence.review);
        evidenceReview.add({
          reviewBy = caller;
          comment = comment;
          point = star;
          cratedAt = Time.now();
        });

        let starToNumb = Review.starToNumb(star);

        let updateevidenceReview : Evidence.Evidence = {
          evidence with review = Buffer.toArray<Review.Review>(evidenceReview);
          reviewPoint = evidence.reviewPoint + starToNumb / evidence.totalReviewNumbers +1;
          totalReviewNumbers = evidence.totalReviewNumbers + 1;
        };

        Evidence.put(evidenceMap, evidenceId, updateevidenceReview);

        return #ok("Review Update to Evidence " #Nat.toText(evidenceId) # " successfully!");
      };
    };
  };

  //get Review by principal

  public shared query func getUserReviews(principal : Principal) : async [Review.Review] {

    var reviews : [Review.Review] = [];

    let user = User.get(userMap, principal);

    switch (user) {
      case (?user) {

        for (element in user.review.vals()) {
          reviews := Array.append<Review.Review>(reviews, [element]);
        };
      };
      case (null) { return [] };
    };
    return reviews;

  };

  public shared query func getEvidenceReviews(id : Nat) : async [Review.Review] {

    var reviews : [Review.Review] = [];

    let evidence = Evidence.get(evidenceMap, id);

    switch (evidence) {
      case (?evidence) {

        for (element in evidence.review.vals()) {
          reviews := Array.append<Review.Review>(reviews, [element]);
        };
      };
      case (null) { return [] };
    };
    return reviews;

  };

  // user Evidence

  stable var nextEvidenceId : Nat = 0;

  public shared ({ caller }) func submitEvidence(image : [Blob], video : [Blob], description : Text, location : Evidence.Coordinates) : async Text {
    if (isBanned(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };

    let newEvidence : Evidence.Evidence = {
      id = nextEvidenceId;
      user = caller;
      description = description;
      validated = false;
      location = location;
      image = image;
      video = video;
      reports = [];
      review = [];
      reviewPoint = 0;
      totalReviewNumbers = 0;
      reportCount = 0;

    };
    Evidence.put(evidenceMap, newEvidence.id, newEvidence);
    nextEvidenceId += 1;
    return "Successfull";

  };

  public query func getEvidence() : async [Evidence.Evidence] {
    return Iter.toArray<Evidence.Evidence>(Map.vals(evidenceMap));
  };

  public query func getUnvalidatedEvidences() : async [Evidence.Evidence] {
    var filteredEvidences : [Evidence.Evidence] = [];
    for (element in Map.vals(evidenceMap)) {
      if (element.validated == false) {
        filteredEvidences := Array.append<Evidence.Evidence>(filteredEvidences, [element]);
      };
    };

    return filteredEvidences;
  };

  // Report

  public shared ({ caller }) func submitReport(shot : Report.ReportShot, category : Report.ReportCategory, details : Text) : async Result.Result<Text, Text> {
    if (isBanned(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };
    if (User.isMember(userMap, caller) != true) {
      return #err("only members can report");
    };
    let newReport : Report.Report = {
      catagory = category;
      reportId = nextReportId;
      reporterId = caller;
      shot = shot;
      timestamp = Time.now();
      details = details;
    };
    let report : Report.Reports = {
      id = newReport.reportId;
      category = category;
    };
    switch (shot) {
      case (#Member(p)) {
        if (User.submitReport(userMap, p, report) != true) {
          return #err("member not found !");
        };

      };
      case (#Evidence(id)) {

        if (Evidence.submitReport(evidenceMap, id, report) != true) {
          return #err("evidence Not Found !");
        };
      };
    };

    nextReportId += 1;
    Report.put(reportMap, newReport.reportId, newReport);

    return #ok("Done");
  };

  public shared query func getReports(shot : Report.ReportShot) : async [Report.Report] {

    var reports : [Report.Report] = [];
    for (report in Map.vals(reportMap)) {
      if (report.shot == shot) {
        reports := Array.append<Report.Report>(reports, [report]);
      };
    };
    return reports;
  };

  ///Proposal

  let stableData : Types.StableData<Proposal.Content> = {
    proposals = [];
    proposalDuration = #days(7);
    votingThreshold = #percent({ percent = 50; quorum = ?20 });
  };

  let onExecute = func(proposal : Types.Proposal<Proposal.Content>) : async* Result.Result<(), Text> {
    switch (proposal.content) {
      case (#AddManifesto(newManifesto)) {
        manifesto := Array.append<Text>(manifesto, [newManifesto]);
      };
      case (#ChangeTreePlantingReward(newReward)) {
        treePlantingReward := newReward;
      };
      case (#ChangeReportThreshold(newThreshold)) {
        reportThroshold := newThreshold;
      };
      case (#ChangeEcoCleanupReward(newReward)) {
        ecoCleanupReward := newReward;
      };
      case (#ChangeAnimalProtectionReward(newReward)) {
        animalProtectionReward := newReward;
      };
      case (#MemberBan(banDetail)) {
        BlackList := Array.append<Principal>(BlackList, [banDetail.member]);
      };
      case (#MemberUnban(unbanDetail)) {
        BlackList := Array.filter<Principal>(BlackList, func(p) { p != unbanDetail.member });
      };
    };
    #ok;
  };

  let onReject = func(_ : Types.Proposal<Proposal.Content>) : async* () {
    Debug.print("Proposal was rejected");
  };

  let onValidate = func(_ : Proposal.Content) : async* Result.Result<(), [Text]> {
    #ok;
  };

  let engine = ProposalEngine.ProposalEngine<system, Proposal.Content>(stableData, onExecute, onReject, onValidate);

  public shared ({ caller }) func createProposal(content : Proposal.Content) : async Result.Result<Nat, Types.CreateProposalError> {
    if (User.userCanPerform(userMap, caller) != true) {
      return #err(#notAuthorized);
    };

    switch (await* engine.createProposal(caller, content)) {
      case (#ok(proposalId)) {
        return #ok(proposalId);
      };
      case (#err(error)) {
        return #err(error);
      };
    };
  };

  public func getProposals(count : Nat, offset : Nat) : async Types.PagedResult<Types.Proposal<Proposal.Content>> {

    let pagedResult : Types.PagedResult<Types.Proposal<Proposal.Content>> = engine.getProposals(count, offset);
    return pagedResult;
  };

  public func getProposal(id : Nat) : async ?Types.Proposal<Proposal.Content> {
    let ?proposal : ?Types.Proposal<Proposal.Content> = engine.getProposal(id) else Debug.trap("Proposal not found");
    return ?proposal;
  };

  public shared ({ caller }) func vote(proposalId : Nat, vote : Bool) : async Result.Result<(), Types.VoteError> {
    switch (await* engine.vote(proposalId, caller, vote)) {
      case (#ok) { return #ok() };
      case (#err(error)) { return #err(error) };
    };
  };

  public query func getReportThreshold() : async Nat {
    return reportThroshold;
  };

  // let index = actor ("qhbym-qaaaa-aaaaa-aaafq-cai") : actor {
  //   rget_account_identifier_balance : shared query Text -> async Nat64;
  //   get_account_identifier_transactions : shared query IndexIcp.GetAccountIdentifierTransactionsArgs -> async IndexIcp.GetAccountIdentifierTransactionsResult;
  //   get_account_transactions : shared query IndexIcp.GetAccountTransactionsArgs -> async IndexIcp.GetAccountIdentifierTransactionsResult;
  //   get_blocks : shared query IndexIcp.GetBlocksRequest -> async IndexIcp.GetBlocksResponse;
  //   http_request : shared query IndexIcp.HttpRequest -> async IndexIcp.HttpResponse;
  //   icrc1_balance_of : shared query IndexIcp.Account -> async Nat64;
  //   ledger_id : shared query () -> async Principal;
  //   status : shared query () -> async IndexIcp.Status;
  // };

  // public shared func getBlock(request : IndexIcp.GetBlocksRequest) : async IndexIcp.GetBlocksResponse {
  //   return await index.get_blocks(request);
  // };

};
