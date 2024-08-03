import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import TrieMap "mo:base/TrieMap";
import ProposalEngine "mo:dao-proposal-engine/ProposalEngine";
import Types "mo:dao-proposal-engine/Types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

import ICRC "./ICRC";
import Evidence "Evidence";
import Log "Log";
import Proposal "ProposalActor/Proposal";
import Report "Report";
import Review "Review";
import User "User";

actor class B3Nature() = this {

  stable var userMap : User.UserMap = Map.new<Principal, User.User>();
  stable var reportMap : Report.ReportMap = Map.new<Nat, Report.Report>();
  stable var evidenceMap : Evidence.EvidenceMap = Map.new<Nat, Evidence.Evidence>();
  stable var proposalsMap : Proposal.ProposalsMap = Map.new<Nat, Types.Proposal<Proposal.Content>>();
  stable var logMap : Log.LogMap = Map.new<Nat, Log.Log>();

  private stable var userReportThroshold : Nat = 10;
  private stable var evidenceReportThroshold : Nat = 5;
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

  private stable var UserBlackList : [Principal] = [];
  private stable var EvidenceBlackList : [Principal] = [];

  private func isBannedUser(principal : Principal) : Bool {
    for (p in UserBlackList.vals()) {
      if (p == principal) {
        return true;
      };
    };
    false;
  };

  private func isBannedEvidence(id : Nat) : Bool {
    for (e in EvidenceBlackList.vals()) {
      if (e == id) {
        return true;
      };
    };
    false;
  };

  //register and Update members

  public shared ({ caller }) func registerAndUpdateMember(name : Text, email : Text, image : ?Blob) : async Result.Result<(Text), Text> {
    if (isBannedUser(caller)) {
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
    if (isBannedUser(caller)) {
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
    if (isBannedUser(caller)) {
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
    if (isBannedUser(caller)) {
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
    if (isBannedUser(caller)) {
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
        let submitUserReport = User.submitReport(userMap, p, report) else Debug.trap("User not found");
        if (submitUserReport >= userReportThroshold) {
          switch (await* engine.createProposal(p, #MemberBan({ member = p; detail = "User with Id : " # Principal.toText(p) # "Reported too many times" }))) {
            case (#ok(proposalId)) {
              Log.add(logMap, #ReportedUser, "" #Principal.toText(p) # " Created Proposal for Report with id " #Nat.toText(proposalId) # "!");
              return #ok("proposal with id " # (Nat.toText(proposalId)) # " has been Created");
            };

            case (#err(err)) {
              if (err == #notAuthorized) {
                return #err("caller is not a Registered member");
              };
              return #err("proposal creation failed");
            };
          };
        };
      };
      case (#Evidence(id)) {

        let submitEvidenceReport = Evidence.submitReport(evidenceMap, id, report) else Debug.trap("Evidence not found");

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
        userReportThroshold := newThreshold;
      };
      case (#ChangeEcoCleanupReward(newReward)) {
        ecoCleanupReward := newReward;
      };
      case (#ChangeAnimalProtectionReward(newReward)) {
        animalProtectionReward := newReward;
      };
      case (#MemberBan(banDetail)) {
        UserBlackList := Array.append<Principal>(UserBlackList, [banDetail.member]);
      };
      case (#MemberUnban(unbanDetail)) {
        UserBlackList := Array.filter<Principal>(UserBlackList, func(p) { p != unbanDetail.member });
      };
    };
    #ok;
  };

  let onReject = func(proposal : Types.Proposal<Proposal.Content>) : async* () {
    Debug.print("Proposal was rejected");
  };

  let onValidate = func(_ : Proposal.Content) : async* Result.Result<(), [Text]> {
    #ok;
  };

  let engine = ProposalEngine.ProposalEngine<system, Proposal.Content>(stableData, onExecute, onReject, onValidate);

  public shared ({ caller }) func createProposal(content : Proposal.Content) : async Result.Result<Nat, Types.CreateProposalError> {
    // if (isBannedUser(caller)) {
    //   throw Error.reject("Access denied. You are banned.");
    // };
    if (User.userCanPerform(userMap, caller) != true) {
      return #err(#notAuthorized);
    };

    switch (await* engine.createProposal(caller, content)) {
      case (#ok(proposalId)) {
        Log.add(logMap, #Proposal, "user with id" #Principal.toText(caller) # " Created Proposal with id   " #Nat.toText(proposalId) # "!");
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
    if (isBannedUser(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };
    switch (await* engine.vote(proposalId, caller, vote)) {
      case (#ok) { return #ok() };
      case (#err(error)) { return #err(error) };
    };
  };

  //test //// must be delete
  public query func getReportThreshold() : async Nat {
    return userReportThroshold;
  };

  public type DonateArgs = {
    spender_subaccount : ?Blob;
    token : Principal;
    from : ICRC.Account;
    amount : Nat;
    fee : ?Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

  public type DonateError = {
    #TransferFromError : ICRC.TransferFromError;
  };

  private var balances = TrieMap.TrieMap<Principal, TrieMap.TrieMap<Principal, Nat>>(Principal.equal, Principal.hash);

  // Accept donates of tokens
  public shared ({ caller }) func donate(args : DonateArgs) : async Result.Result<Nat, DonateError> {
    if (isBannedUser(caller)) {
      throw Error.reject("Access denied. You are banned.");
    };

    if (caller != args.from.owner) {
      return #err(#TransferFromError(#GenericError({ error_code = 0; message = "caller is not the owner of the 'from' account" })));
    };

    let token : ICRC.Actor = actor (Principal.toText(args.token));

    let fee = switch (args.fee) {
      case (?f) { f };
      case (null) { await token.icrc1_fee() };
    };

    // Perform the transfer, to capture the tokens.
    let transfer_result = await token.icrc2_transfer_from({
      spender_subaccount = args.spender_subaccount;
      from = args.from;
      to = { owner = Principal.fromActor(this); subaccount = null };
      amount = args.amount;
      fee = ?fee;
      memo = args.memo;
      created_at_time = args.created_at_time;
    });

    // Check that the transfer was successful.
    let block_height = switch (transfer_result) {
      case (#Ok(block_height)) { block_height };
      case (#Err(err)) {
        // Transfer failed. There's no cleanup for us to do since no state has
        // changed, so we can just wrap and return the error to the frontend.
        return #err(#TransferFromError(err));
      };
    };

    let current_map = switch (balances.get(args.from.owner)) {
      case (?m) { m };
      case (null) {
        TrieMap.TrieMap<Principal, Nat>(Principal.equal, Principal.hash);
      };
    };

    // Credit the sender's account
    let sender_balance = switch (current_map.get(args.token)) {
      case (?b) { b };
      case (null) { 0 };
    };

    current_map.put(args.token, sender_balance + args.amount);
    balances.put(args.from.owner, current_map);

    // Return the "block height" of the transfer
    Log.add(logMap, #Donate, "Member with id " #Principal.toText(caller) # " just donated !");
    #ok(block_height);

  };

  public shared query func getLogs(logs : Log.Catagory) : async Result.Result<[Log.Log], Text> {
    return #ok(Log.getLogsByCategory(logMap, logs));
  };

};
