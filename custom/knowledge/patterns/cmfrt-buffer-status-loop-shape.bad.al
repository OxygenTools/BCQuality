codeunit 2045762 "CMFRT GD Registration Sweep"
{
    procedure CMFRTGDProcessPendingRows(var CMFRTGDRegistration: Record "CMFRT GD Registration")
    begin
        // Sorted on the grouping key that contains Status, which this loop writes: rows move within the
        // index as they are updated and SQL can skip them.
        // FindSet(true) opens the write transaction before the first iteration, so the Codeunit.Run below
        // is refused on the very first row.
        // The whole set is read and unwanted rows are skipped with an if inside the loop instead of being
        // filtered out before it.
        CMFRTGDRegistration.SetCurrentKey("CMFRT GD Status", "CMFRT GD External Order ID");
        if CMFRTGDRegistration.FindSet(true) then
            repeat
                if CMFRTGDRegistration."CMFRT GD Status" <> CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Processed" then
                    CMFRTGDApplyResult(CMFRTGDRegistration);
            until CMFRTGDRegistration.Next() = 0;
    end;

    local procedure CMFRTGDApplyResult(var CMFRTGDRegistration: Record "CMFRT GD Registration")
    var
        CMFRTGDWorker: Codeunit "CMFRT GD Registration Worker";
        CMFRTGDNotifier: Codeunit "CMFRT GD Error Notifier";
        CMFRTGDFailed: Boolean;
    begin
        // Result captured in a boolean and tested twice, so the reader has to hold the flag in mind to see
        // which branch the notifier belongs to.
        Clear(CMFRTGDWorker);
        CMFRTGDFailed := not CMFRTGDWorker.Run(CMFRTGDRegistration);

        if CMFRTGDFailed then begin
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Error";
            CMFRTGDRegistration."CMFRT GD Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(CMFRTGDRegistration."CMFRT GD Error Message"));
        end else
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Processed";
        CMFRTGDRegistration.Modify(true);

        Commit();

        // After the Commit: the User Task insert re-opens the write transaction, and the next row's
        // Codeunit.Run is refused.
        if CMFRTGDFailed then
            CMFRTGDNotifier.CMFRTGDCreateErrorUserTask();
    end;
}
