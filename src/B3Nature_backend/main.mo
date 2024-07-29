import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import ProposalEngine "mo:dao-proposal-engine/ProposalEngine";
import Types "mo:dao-proposal-engine/Types";
import Map "mo:map/Map";

import Evidence "Evidence";
import IndexIcp "IndexICP";
import Report "Report";
import Review "Review";
import Token "Token";
import User "User";
actor class B3Nature() {

  stable var userMap : User.UserMap = Map.new<Principal, User.User>();
  stable var tokenMap : Token.TokenMap = Map.new<Principal, Nat>();
  stable var reportMap : Report.ReportMap = Map.new<Nat, Report.Report>();

  private stable var ReportThroshold : Nat = 10;
  private stable var TokenTotalSupply : Nat = 0;
  private stable var RewardToken : Nat = 20;

  stable var nextReportId : Nat = 0;

  //register and Update members

  public shared ({ caller }) func registerAndUpdateMember(name : Text, email : Text, image : ?Blob) : async Result.Result<(Text), Text> {
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

  public shared ({ caller }) func addOrUpdateReviwe(userPrincipal : Principal, star : Review.Star, comment : ?Text) : async Result.Result<(Text), Text> {
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

  //get Review by principal

  public shared query func getReview(p : Principal) : async [Review.Review] {

    var reviews : [Review.Review] = [];

    let user = User.get(userMap, p);

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

  // user Evidence

  stable var evidencesMap : Evidence.EvidenceMap = Map.new<Nat, Evidence.Evidence>();
  stable var nextEvidenceId : Nat = 0;

  public shared ({ caller }) func submitEvidence(image : [Blob], video : [Blob], description : Text, location : Evidence.Coordinates) : async Text {
    let newEvidence : Evidence.Evidence = {
      id = nextEvidenceId;
      user = caller;
      description = description;
      validated = false;
      location = location;
      image = image;
      video = video;
      reports = [];
    };
    Evidence.put(evidencesMap, newEvidence.id, newEvidence);
    nextEvidenceId += 1;
    return "Successfull";

  };

  public query func getEvidence() : async [Evidence.Evidence] {
    return Iter.toArray<Evidence.Evidence>(Map.vals(evidencesMap));
  };

  public query func getUnvalidatedEvidences() : async [Evidence.Evidence] {
    var filteredEvidences : [Evidence.Evidence] = [];
    for (element in Map.vals(evidencesMap)) {
      if (element.validated == false) {
        filteredEvidences := Array.append<Evidence.Evidence>(filteredEvidences, [element]);
      };
    };

    return filteredEvidences;
  };

  // Report

  public shared ({ caller }) func submitReport(userId : Principal, evidenceId : Nat, category : Report.ReportCategory, details : Text) : async Result.Result<Text, Text> {
    if (User.isMember(userMap, caller) != true) {
      return #err("only members can report");
    };

    let newReport : Report.Report = {
      catagory = category;
      reportId = nextReportId;
      reporterId = caller;
      evidenceId = evidenceId;
      userId = userId;
      timestamp = Time.now();
      details = details;
    };
    nextReportId += 1;
    Report.put(reportMap, newReport.reportId, newReport);

    let report : Report.Reports = {
      id = newReport.reportId;
      category = category;
    };

    if (User.submitReport(userMap, userId, report) != true) {
      return #err("member not found !");
    };

    if (Evidence.submitReport(evidencesMap, evidenceId, report) != true) {
      return #err("evidence Not Found !");
    };

    return #ok("Done");
  };

  public shared query func getUserReports(principal : Principal) : async [Report.Report] {

    var reports : [Report.Report] = [];
    for (report in Map.vals(reportMap)) {
      if (report.userId == principal) {
        reports := Array.append<Report.Report>(reports, [report]);
      };
    };
    return reports;
  };

  public shared query func getEvidenceReports(id : Nat) : async [Report.Report] {

    var reports : [Report.Report] = [];
    for (report in Map.vals(reportMap)) {
      if (report.evidenceId == id) {
        reports := Array.append<Report.Report>(reports, [report]);
      };
    };
    return reports;
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
