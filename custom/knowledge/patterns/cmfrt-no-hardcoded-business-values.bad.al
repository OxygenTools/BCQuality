// The VAT clause code range and the template token are literals. A customer with another
// numbering, or another token, needs a code change and a release.
codeunit 2045690 "CMFRT JO Materialize VAT Cl."
{
    procedure CMFRTJOCreateClause(Description: Text[250]): Code[20]
    var
        VATClause: Record "VAT Clause";
        LastNo: Integer;
        NewCode: Code[20];
    begin
        VATClause.LockTable();
        VATClause.SetRange(Code, 'PVC0000000', 'PVC9999999');
        if VATClause.FindLast() then
            if not Evaluate(LastNo, CopyStr(VATClause.Code, 4)) then
                LastNo := 0;
        NewCode := 'PVC' + PadStr('', 7 - StrLen(Format(LastNo + 1)), '0') + Format(LastNo + 1);
        VATClause.Init();
        VATClause.Validate(Code, NewCode);
        VATClause.Validate(Description, Description);
        VATClause.Insert(true);
        exit(NewCode);
    end;

    procedure CMFRTJOTemplateHasVariable(Description: Text): Boolean
    begin
        exit(StrPos(Description, CMFRTJOToken()) > 0);
    end;

    local procedure CMFRTJOToken(): Text
    begin
        exit('%99');
    end;
}
