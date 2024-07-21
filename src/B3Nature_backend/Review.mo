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
};
