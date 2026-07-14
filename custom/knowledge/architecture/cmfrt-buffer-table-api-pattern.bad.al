page 55035 "CMFRT AQ FS JJL API"
{
    PageType = API;
    SourceTable = "Job Journal Line"; // real table exposed directly to the API

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // Manual insert/exit boilerplate duplicates the framework insert
        // and couples the HTTP request to the real-table insert: no retry,
        // no error queue, one validation error fails the whole request.
        Rec.Insert(true);
        Rec.CMFRTAQFSLogIncomingRequest();
        exit(false);
    end;
}
