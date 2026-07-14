codeunit 55028 "CMFRT AQ FS Item Attr Push"
{
    local procedure DoCMFRTAQInitAPILogEntry(var CMFRTAQAPILog: Record "CMFRT AQ API Log"; ErrorText: Text)
    begin
        // Literal lengths diverge from the field definition on the first schema change.
        CMFRTAQAPILog."CMFRT AQ User ID" := CopyStr(UserId(), 1, 50);
        CMFRTAQAPILog."CMFRT AQ Error Message" := CopyStr(ErrorText, 1, 250);
    end;
}
