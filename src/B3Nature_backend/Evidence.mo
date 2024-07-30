import Array "mo:base/Array";
import Result "mo:base/Result";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

import Report "Report";
import Review "Review";

module {

    public type Evidence = {
        id : Nat;
        user : Principal;
        description : Text;
        validated : Bool;
        location : Coordinates;
        image : [Blob];
        video : [Blob];
        reports : [Report.Reports];
        review : [Review.Review];
        reviewPoint : Nat;
        totalReviewNumbers : Nat;
        reportCount : Nat;

    };

    public type Coordinates = {
        latitude : Float;
        longitude : Float;
    };

    public type EvidenceMap = Map.Map<Nat, Evidence>;

    // Map get
    public func get(evidenceMap : EvidenceMap, id : Nat) : ?Evidence {
        return Map.get(evidenceMap, nhash, id);
    };

    // Map put
    public func put(evidenceMap : EvidenceMap, id : Nat, evidence : Evidence) : () {
        return Map.set(evidenceMap, nhash, id, evidence);
    };

    public func submitReport(evidenceMap : EvidenceMap, evidenceId : Nat, report : Report.Reports) : Bool {
        switch (get(evidenceMap, evidenceId)) {
            case (?evidence) {
                let newReportCount = evidence.reportCount +1;
                let updatedReports = Array.append<Report.Reports>(evidence.reports, [report]);
                let updateEvidence : Evidence = {
                    evidence with reports = updatedReports;
                    reportCount = newReportCount;
                };
                put(evidenceMap, evidenceId, updateEvidence);
                return true;
            };
            case (null) { false };
        };
    };

    public func hasPoint(evidence : Evidence, by : Principal) : Bool {

        switch (evidence) {

            case (evidence) {
                for (review in evidence.review.vals()) {
                    if (review.reviewBy == by) {
                        return true;
                    };
                };
            };

        };
        return false;
    };

    public func replaceEvidencePoint(evidenceMap : EvidenceMap, evidence : Evidence, caller : Principal, newPoint : Review.Review) : Result.Result<(), Text> {

        switch (evidence) {
            case (evidence) {
                // Filter out the specific MenuPoint
                let updatedPoints = Array.filter<Review.Review>(
                    evidence.review,
                    func(review) {
                        review.reviewBy != caller;
                    },
                );

                var oldStar : Nat = 0;
                for (element in evidence.review.vals()) {
                    if (element.reviewBy == caller) {

                        let convertStarToNat = Review.starToNumb(element.point);
                        oldStar := convertStarToNat;
                    };
                };

                // Add the new MenuPoint
                let newPoints = Array.append<Review.Review>(updatedPoints, [newPoint]);

                // Update the new points and minus old point from reviewPoint

                let updateEvidence = {
                    evidence with review = newPoints;
                    reviewPoint = evidence.reviewPoint - oldStar;
                };
                put(evidenceMap, evidence.id, updateEvidence);
                return #ok();
            };
        };
    };

};
