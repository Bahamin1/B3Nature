module {
    public type ProposalContent = {
        title : Text;
        description : Text;
        createdBy : CreatedBy;
    };

    public type CreatedBy = {
        #ProposalByUser;
        #ProposalBySystem;
    };

    public type ProposalDescriptionBySystem = {
        #EvidenceReport;
        #UserReport;
        #Agreement;
    };

};
