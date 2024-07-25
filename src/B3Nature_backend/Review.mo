import Time "mo:base/Time";

module {

    public type Review = {
        reviewBy : Principal;
        comment : ?Text;
        point : Star;
        cratedAt : Time.Time;
    };

    public type Star = {
        #One;
        #Two;
        #Three;
        #Four;
        #Five;
    };

    public func starToNumb(rating : Star) : Nat {
        switch (rating) {
            case (#One) { 1 };
            case (#Two) { 2 };
            case (#Three) { 3 };
            case (#Four) { 4 };
            case (#Five) { 5 };
        };
    };
};
