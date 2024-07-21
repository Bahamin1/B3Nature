import Array "mo:base/Array";
import Result "mo:base/Result";
import Map "mo:map/Map";
import { phash } "mo:map/Map";

import Review "Review";

module {
    public type User = {
        id : Nat;
        name : Text;
        identity : Principal;
        email : Text;
        role : Role;
        reviewPoint : Nat;
        votingPower : Nat;
        review : [Review.Review];
        image : ?Blob;
    };

    public type Role = {
        #Guest;
        #Staker;
        #ActiveParticipant;
        #Council;
        #Ambassador;
        #Guardian;
    };

    public type UserMap = Map.Map<Principal, User>;

    // Map get
    public func get(userMap : UserMap, principal : Principal) : ?User {
        return Map.get(userMap, phash, principal);
    };

    // Map put
    public func put(userMap : UserMap, p : Principal, user : User) : () {
        return Map.set(userMap, phash, p, user);
    };

    // add New user specefic with oprations
    public func new(userMap : UserMap, principal : Principal, name : Text, email : Text, image : ?Blob) : (Text) {
        let id = Map.size(userMap) +1;
        switch (get(userMap, principal)) {
            case (null) {

                let user : User = {
                    id = id;
                    name = name;
                    identity = principal;
                    email = email;
                    role = #Guest;
                    reviewPoint = 0;
                    votingPower = 0;
                    review = [];
                    image = image;
                };

                put(userMap, principal, user);

                return "member successfully updated ";

            };
            case (?user) {

                let updateUser : User = {
                    id = user.id;
                    name = name;
                    identity = principal;
                    email = email;
                    role = user.role;
                    reviewPoint = user.reviewPoint;
                    votingPower = user.votingPower;
                    review = user.review;
                    image = image;
                };

                put(userMap, principal, updateUser);
                return "Wellcome register Completed";
            };
        };

    };

    public func hasPoint(userMap : UserMap, on : Principal, by : Principal) : Bool {
        let user = get(userMap, on);

        switch (user) {
            case (null) {
                return false;
            };
            case (?user) {
                for (review in user.review.vals()) {
                    if (review.reviewBy == by) {
                        return true;
                    };
                };
            };

        };
        return false;
    };

    public func replaceUserPoint(userMap : UserMap, caller : Principal, userId : Principal, newPoint : Review.Review) : Result.Result<(), Text> {

        switch (get(userMap, userId)) {
            case (?user) {
                // Filter out the specific MenuPoint
                let updatedPoints = Array.filter<Review.Review>(
                    user.review,
                    func(review) {
                        review.reviewBy != caller;
                    },
                );

                // Add the new MenuPoint
                let newPoints = Array.append<Review.Review>(updatedPoints, [newPoint]);

                // Update the new points array

                let updateUser = { user with review = newPoints };
                put(userMap, userId, updateUser);
                return #ok();
            };
            case null { return #err("User Not Found") };
        };
    };

    public func isMember(userMap : UserMap, p : Principal) : Bool {
        switch (get(userMap, p)) {
            case (null) {
                return false;
            };

            case (?user) {
                return true;
            };
        };
        return false;
    };

};
