import Array "mo:base/Array";
import Time "mo:base/Time";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

module {

    public type Log = {
        id : Nat;
        message : Text;
        createdAt : Time.Time;
        catagory : Catagory;
    };

    public type Catagory = {
        #Proposal;
        #Manifesto;
        #Donate;
        #ReportedEvidence;
        #ReportedUser;

    };

    public type LogMap = Map.Map<Nat, Log>;

    public func put(logMap : LogMap, key : Nat, value : Log) : () {
        return Map.set(logMap, nhash, key, value);
    };

    public func add(logMap : LogMap, catagory : Catagory, message : Text) : () {
        let id = Map.size(logMap) +1;

        let newLog : Log = {
            id = id;
            message = message;
            createdAt = Time.now();
            catagory = catagory;
        };

        put(logMap, id, newLog);

        return;
    };

    public func getLogsByCategory(logMap : LogMap, per : Catagory) : [Log] {

        var filteredLogs : [Log] = [];

        for (cata in Map.vals(logMap)) {
            switch (cata.catagory) {
                case (is) {

                    if (is == per) {
                        filteredLogs := Array.append<Log>(filteredLogs, [cata]);
                    };
                };
            };
        };
        return filteredLogs;

    };

    public func catagoryToText(cat : Catagory) : Text {
        switch (cat) {
            case (#Proposal) { "Proposal" };
            case (#Manifesto) { "Manifesto" };
            case (#ReportedUser) { "Reported User" };
            case (#ReportedEvidence) { "Reported Evidence" };
            case (#Donate) { "Donate" };

        };
    };

};
