// One Do procedure loads the selection, adds the previous slices, checks for open slices
// outside the set, asks the user and releases. The body is far over 40 lines.
codeunit 2045700 "CMFRT EK Release Order Meth"
{
    procedure CMFRTEKApplyReleaseOrderChecks(var CMFRTISInvoiceScheme: Record "CMFRT IS Invoice Scheme")
    begin
        DoCMFRTEKApplyReleaseOrderChecks(CMFRTISInvoiceScheme);
    end;

    local procedure DoCMFRTEKApplyReleaseOrderChecks(var CMFRTISInvoiceScheme: Record "CMFRT IS Invoice Scheme")
    var
        Selection: Record "CMFRT IS Invoice Scheme";
        Candidate: Record "CMFRT IS Invoice Scheme";
        TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary;
        ConfirmManagement: Codeunit "Confirm Management";
        AddPreviousQst: Label 'Earlier slices of %1 are still open. Release them together?', Comment = '%1 = Source No.';
        OpenOutsideErr: Label 'Source %1 has an open slice that is not in this release.', Comment = '%1 = Source No.';
        HasPrevious: Boolean;
    begin
        Selection.Copy(CMFRTISInvoiceScheme);
        Selection.SetRange("CMFRT IS Selected", true);
        if Selection.IsEmpty() then
            Selection.SetRange("CMFRT IS Selected");
        if Selection.FindSet() then
            repeat
                TempFinalSet := Selection;
                if TempFinalSet.Insert() then;
            until Selection.Next() = 0;

        TempFinalSet.Reset();
        if TempFinalSet.FindSet() then
            repeat
                Candidate.Reset();
                Candidate.SetRange("CMFRT IS Source Type", TempFinalSet."CMFRT IS Source Type");
                Candidate.SetRange("CMFRT IS Source No.", TempFinalSet."CMFRT IS Source No.");
                Candidate.SetFilter("CMFRT IS Due Date", '<%1', TempFinalSet."CMFRT IS Due Date");
                Candidate.SetRange("CMFRT IS Released", false);
                HasPrevious := not Candidate.IsEmpty();
                if HasPrevious then
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(AddPreviousQst, TempFinalSet."CMFRT IS Source No."), true) then
                        if Candidate.FindSet() then
                            repeat
                                TempFinalSet := Candidate;
                                if TempFinalSet.Insert() then;
                            until Candidate.Next() = 0;
            until TempFinalSet.Next() = 0;

        TempFinalSet.Reset();
        if TempFinalSet.FindSet() then
            repeat
                Candidate.Reset();
                Candidate.SetRange("CMFRT IS Source Type", TempFinalSet."CMFRT IS Source Type");
                Candidate.SetRange("CMFRT IS Source No.", TempFinalSet."CMFRT IS Source No.");
                Candidate.SetRange("CMFRT IS Released", false);
                if Candidate.FindSet() then
                    repeat
                        if not TempFinalSet.Get(Candidate."CMFRT IS Entry No.") then
                            Error(OpenOutsideErr, Candidate."CMFRT IS Source No.");
                    until Candidate.Next() = 0;
            until TempFinalSet.Next() = 0;

        TempFinalSet.Reset();
        if TempFinalSet.FindSet() then
            repeat
                Candidate.Get(TempFinalSet."CMFRT IS Entry No.");
                Candidate.Validate("CMFRT IS Released", true);
                Candidate.Modify(true);
            until TempFinalSet.Next() = 0;
    end;
}
