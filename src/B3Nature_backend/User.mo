import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Map "mo:map/Map";
import { phash } "mo:map/Map";

import Report "Report";
import Review "Review";

module {
    public type User = {
        id : Nat;
        name : Text;
        identity : Principal;
        email : Text;
        role : Role;
        totalReviewNumbers : Nat;
        reviewPoint : Nat;
        votingPower : Nat;
        review : [Review.Review];
        image : ?Blob;
        balance : Nat;
        totalTokenEarned : Float;
        reports : [Report.Reports];
        reportCount : Nat;
        notifications : [Notify];
    };

    public type Notify = {
        id : Nat;
        message : NotifyMessages;
        time : Time.Time;
    };

    public type NotifyMessages = {
        #CreateEvidence : Text;
        #ProposalRejected : Text;
        #ProposalCreated : Text;
        #ProposalAccepted : Text;
        #EvidenceAccepted : Text;
        #Banned : Text;
        #ReceivedToken : Text;
    };

    public type Role = {
        #Newbee;
        #ActiveParticipant;
        #Golden;
        #Staker;
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
    public func new(userMap : UserMap, principal : Principal, name : Text, email : Text, image : ?Blob) : Result.Result<(Text), Text> {
        let id = Map.size(userMap) +1;
        if (name.size() > 32) {
            return #err("name Is too long");
        };

        switch (get(userMap, principal)) {
            case (null) {

                let user : User = {
                    id = id;
                    name = name;
                    identity = principal;
                    email = email;
                    totalReviewNumbers = 0;
                    //Test// must changed to Newbee
                    role = #Guardian;
                    reviewPoint = 0;
                    votingPower = 0;
                    review = [];
                    image = image;
                    balance = 0;
                    totalTokenEarned = 0;
                    reports = [];
                    reportCount = 0;
                    notifications = [];

                };

                put(userMap, principal, user);

                return #ok("Wellcome register Completed");

            };
            case (?user) {

                let updateUser : User = {
                    id = user.id;
                    name = name;
                    identity = principal;
                    totalReviewNumbers = user.totalReviewNumbers;
                    email = user.email;
                    role = user.role;
                    reviewPoint = user.reviewPoint;
                    votingPower = user.votingPower;
                    review = user.review;
                    image = image;
                    balance = user.balance;
                    totalTokenEarned = user.totalTokenEarned;
                    reports = user.reports;
                    reportCount = user.reportCount;
                    notifications = user.notifications;

                };

                put(userMap, principal, updateUser);
                return #ok("member successfully updated");
            };
        };

    };

    public func hasPoint(user : User, by : Principal) : Bool {

        switch (user) {

            case (user) {
                for (review in user.review.vals()) {
                    if (review.reviewBy == by) {
                        return true;
                    };
                };
            };

        };
        return false;
    };

    public func replaceUserPoint(userMap : UserMap, user : User, caller : Principal, newPoint : Review.Review) : Result.Result<(), Text> {

        switch (user) {
            case (user) {
                // Filter out the specific MenuPoint
                let updatedPoints = Array.filter<Review.Review>(
                    user.review,
                    func(review) {
                        review.reviewBy != caller;
                    },
                );

                var oldStar : Nat = 0;
                for (element in user.review.vals()) {
                    if (element.reviewBy == caller) {

                        let convertStarToNat = Review.starToNumb(element.point);
                        oldStar := convertStarToNat;
                    };
                };

                // Add the new MenuPoint
                let newPoints = Array.append<Review.Review>(updatedPoints, [newPoint]);

                // Update the new points and minus old point from reviewPoint

                let updateUser = {
                    user with review = newPoints;
                    reviewPoint = user.reviewPoint - oldStar;
                };
                put(userMap, user.identity, updateUser);
                return #ok();
            };
        };
    };

    public func isMember(userMap : UserMap, p : Principal) : Bool {
        let ?user = get(userMap, p) else return false;
        switch (?user) {
            case (user) {
                return true;
            };
        };
    };

    public func submitReport(userMap : UserMap, userId : Principal, report : Report.Reports) : Nat {
        switch (get(userMap, userId)) {
            case (?user) {
                let newReportCount = user.reportCount +1;
                let updatedReports = Array.append<Report.Reports>(user.reports, [report]);
                let updateUser : User = {
                    user with reports = updatedReports;
                    reportCount = newReportCount;
                };

                put(userMap, userId, updateUser);
                return newReportCount;
            };
            case (null) {
                return 0;
            };
        };
    };
    //simple enum // must changed to complex with much more options

    public func userCanPerform(userMap : UserMap, p : Principal) : Bool {
        let user = get(userMap, p);

        switch (user) {
            case (null) {
                return false;
            };
            case (?user) {
                switch (user.role) {
                    case (#Newbee) return false;
                    case (#ActiveParticipant) return false;
                    case (#Silver) return false;
                    case (#Golden) return true;
                    case (#Staker) return true;
                    case (#Guardian) return true;

                };
            };

        };
    };

    public func userVotiongPower(userMap : UserMap, user : Principal) : Nat {
        let ?member = get(userMap, user) else return 0;
        switch (member.role) {
            case (#Newbee) { 0 };
            case (#ActiveParticipant) { 0 };
            case (#Golden) { member.balance * 1 };
            case (#Staker) { member.balance * 5 };
            case (#Guardian) { member.balance * 5 };
        };
    };

};
