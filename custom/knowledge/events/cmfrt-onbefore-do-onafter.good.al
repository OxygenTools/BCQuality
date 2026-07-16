codeunit 55043 "CMFRT AQ FS ProForma Meth"
{
    procedure CMFRTAQFSResolveItemToGLAcc(var SalesLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCMFRTAQFSResolveItemToGLAcc(SalesLine, IsHandled);
        DoCMFRTAQFSResolveItemToGLAcc(SalesLine, IsHandled);
        OnAfterCMFRTAQFSResolveItemToGLAcc(SalesLine);
    end;

    local procedure DoCMFRTAQFSResolveItemToGLAcc(var SalesLine: Record "Sales Line"; IsHandled: Boolean)
    var
        Item: Record Item;
        GeneralPostingSetup: Record "General Posting Setup";
        ItemNotFoundErr: Label 'Item %1 was not found.', Comment = '%1 = Item No.';
    begin
        if IsHandled then
            exit;
        Item.SetLoadFields("No.", "Gen. Prod. Posting Group", Description);
        if not Item.Get(SalesLine."CMFRT AQ FS Item No.") then
            Error(ItemNotFoundErr, SalesLine."CMFRT AQ FS Item No.");
        // ... business logic only; early exits here cannot skip OnAfter ...
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
