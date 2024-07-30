import Result "mo:base/Result";
import Time "mo:base/Time";
import ProposalEngine "mo:dao-proposal-engine/ProposalEngine";
import Types "mo:dao-proposal-engine/Types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

module Proposal {

    public type Content = {
        #AddManifesto : Text;
        #ChangeTreePlantingReward : Nat;
        #ChangeReportThreshold : Nat;
        #ChangeEcoCleanupReward : Nat;
        #ChangeAnimalProtectionReward : Nat;
        #MemberBan : BanDetail;
    };

    public type BanDetail = {
        detail : Text;
        member : Principal;
    };

    public type ProposalsMap = Map.Map<Nat, Types.Proposal<Content>>;

    // Map get
    public func get(proposalsMap : ProposalsMap, id : Nat) : ?Types.Proposal<Content> {
        return Map.get(proposalsMap, nhash, id);
    };

    // Map put
    public func put(proposalsMap : ProposalsMap, id : Nat, proposal : Types.Proposal<Content>) : () {
        return Map.set(proposalsMap, nhash, id, proposal);
    };

};
