codeunit 2045761 "CMFRT GD Registration Applier"
{
    procedure CMFRTGDApplyValidationResult(var CMFRTGDRegistration: Record "CMFRT GD Registration")
    var
        CMFRTGDValidator: Codeunit "CMFRT GD Validation Worker";
    begin
        // Codeunit.Run is the error boundary: the validator failing must leave the stored row intact with
        // only its status changed. A [TryFunction] would catch the error but unwind nothing, so a
        // half-written row would survive the catch — it is not a boundary.
        // The row was written just above, so the platform requires the transaction to be closed first:
        // "If you're already in a transaction you must commit first before calling Codeunit.Run"
        // (Codeunit.Run Method, Transaction semantics).
        Commit();

        Clear(CMFRTGDValidator);
        if not CMFRTGDValidator.Run(CMFRTGDRegistration) then begin
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Error";
            CMFRTGDRegistration."CMFRT GD Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(CMFRTGDRegistration."CMFRT GD Error Message"));
            ClearLastError(); // so the next row cannot inherit this message
            CMFRTGDRegistration.Modify(true);
        end else begin
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD New";
            CMFRTGDRegistration."CMFRT GD Error Message" := '';
            CMFRTGDRegistration.Modify(true);
        end;
    end;
}
