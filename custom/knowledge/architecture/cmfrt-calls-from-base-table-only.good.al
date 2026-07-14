// Subscriber codeunit calls the BASE TABLE procedure — not the implementation codeunit.
codeunit 2045720 "CMFRT BA Sales Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CMFRTBAOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CMFRTBAItem: Record "CMFRT BA Item";
    begin
        // Route through the base table — integration events fire normally.
        CMFRTBAItem.CMFRTBASyncPostedSalesDoc(SalesHeader."No.");
    end;
}

// Base table owns all entry points to implementation codeunits.
table 2045095 "CMFRT BA Item"
{
    procedure CMFRTBASyncPostedSalesDoc(SalesDocNo: Code[20])
    var
        SyncImpl: Codeunit "CMFRT BA SyncPostedDoc Impl";
        Handled: Boolean;
    begin
        OnBeforeCMFRTBASyncPostedSalesDoc(SalesDocNo, Handled);
        if Handled then
            exit;
        CMFRTBASyncPostedSalesDoc(SyncImpl);
    end;

    procedure CMFRTBASyncPostedSalesDoc(SyncImpl: Interface "CMFRT BA ISyncPostedDoc")
    begin
        SyncImpl.CMFRTBASyncPostedSalesDoc(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTBASyncPostedSalesDoc(SalesDocNo: Code[20]; var Handled: Boolean)
    begin
    end;
}
