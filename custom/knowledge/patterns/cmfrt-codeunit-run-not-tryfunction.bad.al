codeunit 2045761 "CMFRT GD Registration Applier"
{
    // Anti-pattern: a try method as the row-worker boundary. It catches the error but unwinds nothing,
    // so the row's partial writes survive the catch and the caller silently loses Codeunit.Run semantics.
    [TryFunction]
    local procedure CMFRTGDTryValidate(CMFRTGDRegistration: Record "CMFRT GD Registration")
    begin
        CMFRTGDValidateRegistration(CMFRTGDRegistration);
    end;

    procedure CMFRTGDApplyValidationResult(var CMFRTGDRegistration: Record "CMFRT GD Registration")
    var
        CMFRTGDValidator: Codeunit "CMFRT GD Validation Worker";
    begin
        // The Commit was removed because the Microsoft-layer article calls it an anti-pattern. It compiles,
        // and then fails at runtime on the first call: the row written above left the write transaction open.
        Clear(CMFRTGDValidator);
        if not CMFRTGDValidator.Run(CMFRTGDRegistration) then begin
            CMFRTGDRegistration."CMFRT GD Status" := CMFRTGDRegistration."CMFRT GD Status"::"CMFRT GD Error";
            // GetLastErrorText read with no ClearLastError after it: the next row can pick this message up.
            CMFRTGDRegistration."CMFRT GD Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(CMFRTGDRegistration."CMFRT GD Error Message"));
            CMFRTGDRegistration.Modify(true);
        end;
    end;
}
