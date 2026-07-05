codeunit 55043 "CMFRT AQ FS ProForma Meth"
{
    procedure CMFRTAQFSResolveItemToGLAcc(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        GeneralPostingSetup: Record "General Posting Setup";
        IsHandled: Boolean;
    begin
        OnBeforeCMFRTAQFSResolveItemToGLAcc(SalesLine, IsHandled);
        if IsHandled then
            exit;

        // Business logic inline in the shell: this early exit
        // silently skips the OnAfter event below.
        if SalesLine."CMFRT AQ FS Item No." = '' then
            exit;

        if not Item.Get(SalesLine."CMFRT AQ FS Item No.") then
            exit;
        // ... more inline logic ...

        OnAfterCMFRTAQFSResolveItemToGLAcc(SalesLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTAQFSResolveItemToGLAcc(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTAQFSResolveItemToGLAcc(var SalesLine: Record "Sales Line")
    begin
    end;
}
