import Map "mo:map/Map";
import { nhash } "mo:map/Map";

module {

    public type Evidence = {
        id : Nat;
        user : Principal;
        description : Text;
        validated : Bool;
        location : Coordinates;
        image : [Blob];
        video : [Blob];

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

};
