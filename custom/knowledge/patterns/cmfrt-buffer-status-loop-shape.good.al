codeunit 2045762 "CMFRT GD Registration Sweep"
{
    procedure CMFRTGDProcessPendingRows(var CMFRTGDRegistration: Record "CMFRT GD Registration")
    begin
        // Sorted on the primary key: Status also sits in key CMFRTGDGrouping and this loop writes it, so
        // sorting on Entry No. keeps the cursor position independent of the field being written. That is
        // also what makes it safe to filter on Status: the loop only ever writes New or Error, so a row it
        // just wrote stays inside the filter and is never skipped on Next().
        // Stated positively rather than as <>Processed because the status enum is Extensible — an excluding
        // filter would silently pick up a value added later.
        // Read without FindSet(true) on purpose: a locking read would open the write transaction before the
        // first iteration, and the Codeunit.Run below cannot nest inside one.
        CMFRTGDRegistration.SetCurrentKey("CMFRT GD Entry No.");
        CMFRTGDRegistration.SetFilter(
            "CMFRT GD Status", '%1|%2',
            CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD New",
            CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Error");
        if CMFRTGDRegistration.FindSet() then
            repeat
                CMFRTGDApplyResult(CMFRTGDRegistration);
            until CMFRTGDRegistration.Next() = 0;
    end;

    local procedure CMFRTGDApplyResult(var CMFRTGDRegistration: Record "CMFRT GD Registration")
    var
        CMFRTGDWorker: Codeunit "CMFRT GD Registration Worker";
        CMFRTGDNotifier: Codeunit "CMFRT GD Error Notifier";
    begin
        // The notifier sits inside the failure branch, after the Modify and before the Commit: its User Task
        // insert would re-open the very transaction the Commit exists to close for the next row's Run.
        Clear(CMFRTGDWorker);
        if not CMFRTGDWorker.Run(CMFRTGDRegistration) then begin
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Error";
            CMFRTGDRegistration."CMFRT GD Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(CMFRTGDRegistration."CMFRT GD Error Message"));
            ClearLastError();
            CMFRTGDRegistration.Modify(true);
            CMFRTGDNotifier.CMFRTGDCreateErrorUserTask();
        end else begin
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Processed";
            CMFRTGDRegistration."CMFRT GD Error Message" := '';
            CMFRTGDRegistration.Modify(true);
        end;

        Commit();
    end;
}
