import Array "mo:base/Array";
import Result "mo:base/Result";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

import Report "Report";

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
                let updatedReports = Array.append<Report.Reports>(evidence.reports, [report]);
                let updateEvidence : Evidence = {
                    evidence with reports = updatedReports;
                };
                put(evidenceMap, evidenceId, updateEvidence);
                return true;
            };
            case (null) { false };
        };
    };

};
