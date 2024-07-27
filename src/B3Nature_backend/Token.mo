import Result "mo:base/Result";
import Map "mo:map/Map";
import { phash } "mo:map/Map";

module {

    public type TokenMap = Map.Map<Principal, Nat>;

    public func get(tokenMap : TokenMap, principal : Principal) : ?Nat {
        return Map.get(tokenMap, phash, principal);
    };

    // Map put
    public func put(tokenMap : TokenMap, p : Principal, amount : Nat) : () {
        return Map.set(tokenMap, phash, p, amount);
    };

    public func mintTokens(tokenMap : TokenMap, to : Principal, amount : Nat) : (Text) {
        let ?balance = get(tokenMap, to);
        if (balance > amount) {
            put(tokenMap, to, balance + amount);
            return "Ok";
        };
        return "Err";

    };

    public func transferTokens(tokenMap : TokenMap, from : Principal, to : Principal, amount : Nat) : Result.Result<Text, Text> {
        switch (get(tokenMap, from)) {
            case (?balance) {
                if (balance >= amount) {
                    put(tokenMap, from, balance - amount);
                    switch (get(tokenMap, to)) {
                        case (?recipientBalance) {

                            put(tokenMap, to, recipientBalance + amount);
                            return #ok "Transfer Completed";
                        };
                        case _ { return #err "recepient Not Found !" };
                    };

                } else { return #err "Not Enough Amount" };
            };
            case _ { return #err "Sender Not Found !" };
        };
    };

    public func stakeTokens(tokenMap : TokenMap, user : Principal, amount : Nat) : Bool {
        switch (get(tokenMap, user)) {
            case (?balance) {
                if (balance >= amount) {
                    put(tokenMap, user, balance - amount);
                    return true;
                };
            };
            case _ {};
        };
        return false;
    };

    public func balanceOf(tokenMap : TokenMap, user : Principal) : ?Nat {
        return get(tokenMap, user);
    };
};
