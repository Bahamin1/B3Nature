import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Map "mo:map/Map";

import Evidence "Evidence";
import Review "Review";
import User "User";
actor {

  stable var userMap : User.UserMap = Map.new<Principal, User.User>();

  stable var nextReviewId : Nat = 0;

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

  public query func getMember(p : Principal) : async ?User.User {
    return User.get(userMap, p);
  };

  // Review to user by memebrs

  public shared ({ caller }) func addOrUpdateReviwe(userPrincipal : Principal, star : Review.Star, comment : ?Text) : async Result.Result<(Text), Text> {
    if (User.isMember(userMap, caller)) {
      return #err("caller is not a Registered member");
    };

    if (User.hasPoint(userMap, caller, userPrincipal)) {
      let updateReview : Review.Review = {
        reviewBy = caller;
        comment = comment;
        point = star;
        cratedAt = Time.now();
      };

      switch (User.replaceUserPoint(userMap, caller, userPrincipal, updateReview)) {
        case (#err(errmsg)) {
          return #err(errmsg);
        };
        case (#ok()) {
          return #ok("successfull");
        };
      };

    };
    switch (User.get(userMap, userPrincipal)) {
      case (null) {
        return #err("The user with principal " #Principal.toText(userPrincipal) # " does not exist!");
      };
      case (?user) {
        let userReview = Buffer.fromArray<Review.Review>(user.review);
        userReview.add({
          reviewId = nextReviewId;
          reviewBy = caller;
          comment = comment;
          point = star;
          cratedAt = Time.now();
        });

        let updateUserReview : User.User = {
          user with review = Buffer.toArray(userReview)
        };

        User.put(userMap, userPrincipal, updateUserReview);

        return #ok("Review added to user " #Principal.toText(userPrincipal) # " successfully!");
      };
    };
  };

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
  stable var evidenceCounter : Nat = 0;

  public shared ({ caller }) func submitEvidence(image : [Blob], video : [Blob], description : Text, location : Evidence.Coordinates) : async Text {
    let newEvidence : Evidence.Evidence = {
      id = evidenceCounter;
      user = caller;
      description = description;
      validated = false;
      location = location;
      image = image;
      video = video;
    };
    Evidence.put(evidencesMap, newEvidence.id, newEvidence);
    evidenceCounter += 1;
    return "Successfull";

  };

};
