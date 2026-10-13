// The Do procedure reads as four steps. Each step is a local procedure with a name that says
// what it does, and no body passes 40 lines.
codeunit 2045700 "CMFRT EK Release Order Meth"
{
    procedure CMFRTEKApplyReleaseOrderChecks(var CMFRTISInvoiceScheme: Record "CMFRT IS Invoice Scheme")
    begin
        DoCMFRTEKApplyReleaseOrderChecks(CMFRTISInvoiceScheme);
    end;

    local procedure DoCMFRTEKApplyReleaseOrderChecks(var CMFRTISInvoiceScheme: Record "CMFRT IS Invoice Scheme")
    var
        TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary;
    begin
        CMFRTEKLoadSelection(CMFRTISInvoiceScheme, TempFinalSet);
        CMFRTEKAddPreviousSlices(TempFinalSet);
        CMFRTEKCheckNoOpenSliceOutsideSet(TempFinalSet);
        CMFRTEKReleaseSet(TempFinalSet);
    end;

    local procedure CMFRTEKLoadSelection(var CMFRTISInvoiceScheme: Record "CMFRT IS Invoice Scheme"; var TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary)
    var
        Selection: Record "CMFRT IS Invoice Scheme";
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
    end;

    local procedure CMFRTEKAddPreviousSlices(var TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary)
    var
        Candidate: Record "CMFRT IS Invoice Scheme";
        ConfirmManagement: Codeunit "Confirm Management";
        AddPreviousQst: Label 'Earlier slices of %1 are still open. Release them together?', Comment = '%1 = Source No.';
    begin
        TempFinalSet.Reset();
        if TempFinalSet.FindSet() then
            repeat
                CMFRTEKFilterOpenSlices(Candidate, TempFinalSet);
                Candidate.SetFilter("CMFRT IS Due Date", '<%1', TempFinalSet."CMFRT IS Due Date");
                if not Candidate.IsEmpty() then
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(AddPreviousQst, TempFinalSet."CMFRT IS Source No."), true) then
                        CMFRTEKAddToSet(Candidate, TempFinalSet);
            until TempFinalSet.Next() = 0;
    end;

    local procedure CMFRTEKCheckNoOpenSliceOutsideSet(var TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary)
    var
        Candidate: Record "CMFRT IS Invoice Scheme";
        OpenOutsideErr: Label 'Source %1 has an open slice that is not in this release.', Comment = '%1 = Source No.';
    begin
        TempFinalSet.Reset();
        if TempFinalSet.FindSet() then
            repeat
                CMFRTEKFilterOpenSlices(Candidate, TempFinalSet);
                if Candidate.FindSet() then
                    repeat
                        if not TempFinalSet.Get(Candidate."CMFRT IS Entry No.") then
                            Error(OpenOutsideErr, Candidate."CMFRT IS Source No.");
                    until Candidate.Next() = 0;
            until TempFinalSet.Next() = 0;
    end;

    local procedure CMFRTEKReleaseSet(var TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary)
    var
        Slice: Record "CMFRT IS Invoice Scheme";
    begin
        TempFinalSet.Reset();
        if TempFinalSet.FindSet() then
            repeat
                Slice.Get(TempFinalSet."CMFRT IS Entry No.");
                Slice.Validate("CMFRT IS Released", true);
                Slice.Modify(true);
            until TempFinalSet.Next() = 0;
    end;

    local procedure CMFRTEKFilterOpenSlices(var Candidate: Record "CMFRT IS Invoice Scheme"; var TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary)
    begin
        Candidate.Reset();
        Candidate.SetRange("CMFRT IS Source Type", TempFinalSet."CMFRT IS Source Type");
        Candidate.SetRange("CMFRT IS Source No.", TempFinalSet."CMFRT IS Source No.");
        Candidate.SetRange("CMFRT IS Released", false);
    end;

    local procedure CMFRTEKAddToSet(var Candidate: Record "CMFRT IS Invoice Scheme"; var TempFinalSet: Record "CMFRT IS Invoice Scheme" temporary)
    begin
        if Candidate.FindSet() then
            repeat
                TempFinalSet := Candidate;
                if TempFinalSet.Insert() then;
            until Candidate.Next() = 0;
    end;
}
