codeunit 2045810 "CMFRT DM SP Site Creation"
{
    procedure CMFRTDMMarkSiteCreationFailed(var Job: Record Job; ErrorText: Text)
    begin
        Job.Validate("CMFRT DM Site Status", Job."CMFRT DM Site Status"::Error);
        Job.Validate("CMFRT DM Site Error", CopyStr(ErrorText, 1, MaxStrLen(Job."CMFRT DM Site Error")));
        Job.Modify(true);
        // The error status must stay after the Error() below, so the job list shows the failed site.
        Commit();
        Error(ErrorText);
    end;
}
