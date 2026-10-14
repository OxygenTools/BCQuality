// A Commit() with no comment. The reader cannot see which write must survive the Error().
codeunit 2045810 "CMFRT DM SP Site Creation"
{
    procedure CMFRTDMMarkSiteCreationFailed(var Job: Record Job; ErrorText: Text)
    begin
        Job.Validate("CMFRT DM Site Status", Job."CMFRT DM Site Status"::Error);
        Job.Validate("CMFRT DM Site Error", CopyStr(ErrorText, 1, MaxStrLen(Job."CMFRT DM Site Error")));
        Job.Modify(true);
        Commit();
        Error(ErrorText);
    end;
}
