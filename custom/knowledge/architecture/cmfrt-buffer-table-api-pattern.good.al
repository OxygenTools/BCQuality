page 55035 "CMFRT AQ FS JJL API"
{
    PageType = API;
    SourceTable = "CMFRT AQ FS JJL Buffer"; // buffer table, not Job Journal Line

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // Side effects only; framework performs the default insert.
        Rec.CMFRTAQFSLogIncomingRequest();
    end;
}

codeunit 55038 "CMFRT AQ FS JJL Proc"
{
    procedure CMFRTAQProcessPendingEntries()
    var
        JJLBuffer: Record "CMFRT AQ FS JJL Buffer";
        JJLCreator: Codeunit "CMFRT AQ FS JJL Creator";
    begin
        JJLBuffer.SetRange("CMFRT AQ Status", "CMFRT AQ Buffer Status"::"CMFRT AQ Pending");
        if JJLBuffer.FindSet(true) then
            repeat
                // Proc owns the error boundary: one bad row does not abort the batch.
                if Codeunit.Run(Codeunit::"CMFRT AQ FS JJL Creator", JJLBuffer) then
                    JJLBuffer."CMFRT AQ Status" := "CMFRT AQ Buffer Status"::"CMFRT AQ Processed"
                else begin
                    JJLBuffer."CMFRT AQ Status" := "CMFRT AQ Buffer Status"::"CMFRT AQ Error";
                    JJLBuffer."CMFRT AQ Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(JJLBuffer."CMFRT AQ Error Message"));
                end;
                JJLBuffer.Modify(true);
            until JJLBuffer.Next() = 0;
    end;
}
