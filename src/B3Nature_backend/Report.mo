import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Time "mo:base/Time";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

module {

    public type Report = {
        catagory : ReportCategory;
        reportId : Nat;
        reporterId : Principal;
        evidenceId : Nat;
        userId : Principal;
        timestamp : Time.Time;
        details : Text;
    };

    public type Reports = {
        id : Nat;
        category : ReportCategory;
    };

    public type ReportCategory = {
        #InappropriateContent;
        #SpamOrScam;
        #DuplicateContent;
        #IrrelevantContent;
        #FalseInformation;
        #InappropriateMedia;

    };

    public type ReportMap = Map.Map<Nat, Report>;

    // Map get
    public func get(reportMap : ReportMap, id : Nat) : ?Report {
        return Map.get(reportMap, nhash, id);
    };

    // Map put
    public func put(reportMap : ReportMap, id : Nat, report : Report) : () {
        return Map.set(reportMap, nhash, id, report);
    };

    // Function to create a proposal description based on report category
    private func createProposalDescription(category : ReportCategory) : Text {
        switch (category) {
            case (#InappropriateContent) {
                return "Proposal to review inappropriate content reports.";
            };
            case (#FalseInformation) {
                return "Proposal to review reports of false information.";
            };
            case (#SpamOrScam) {
                return "Proposal to review reports of spam or scam.";
            };
            case (#DuplicateContent) {
                return "Proposal to review duplicate content reports.";
            };
            case (#InappropriateMedia) {
                return "Proposal to review inappropriate media reports.";
            };
            case (#IrrelevantContent) {
                return "Proposal to review irrelevant content reports.";
            };
        };
    };

};
