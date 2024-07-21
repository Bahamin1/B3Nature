import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Map "mo:map/Map";

import Review "Review";
import User "User";
actor {

  stable var userMap : User.UserMap = Map.new<Principal, User.User>();

  stable var nextReviewId : Nat = 0;

  public shared ({ caller }) func registerAndUpdateMember(name : Text, email : Text, image : ?Blob) : async (Text) {
    return User.new(userMap, caller, name, email, image);
  };

  public shared query ({ caller }) func getMember() : async ?User.User {
    return User.get(userMap, caller);
  };

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

};
