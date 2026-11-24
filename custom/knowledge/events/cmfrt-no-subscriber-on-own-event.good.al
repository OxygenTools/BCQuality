codeunit 55062 "CMFRT GDW Line Sync Meth"
{
    procedure CMFRTGDWSyncLines(DocumentNo: Code[20])
    begin
        // The caller knows the context and passes it as a parameter.
        DoCMFRTGDWSyncLines(DocumentNo, true);
    end;

    local procedure DoCMFRTGDWSyncLines(DocumentNo: Code[20]; IsLineSync: Boolean)
    begin
        if IsLineSync then
            exit;
    end;
}
