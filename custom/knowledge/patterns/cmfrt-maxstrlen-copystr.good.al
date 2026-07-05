codeunit 55028 "CMFRT AQ FS Item Attr Push"
{
    local procedure DoCMFRTAQInitAPILogEntry(var CMFRTAQAPILog: Record "CMFRT AQ API Log"; ErrorText: Text)
    begin
        CMFRTAQAPILog."CMFRT AQ User ID" := CopyStr(UserId(), 1, MaxStrLen(CMFRTAQAPILog."CMFRT AQ User ID"));
        CMFRTAQAPILog."CMFRT AQ Error Message" := CopyStr(ErrorText, 1, MaxStrLen(CMFRTAQAPILog."CMFRT AQ Error Message"));
    end;
}
