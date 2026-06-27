// Subscriber calls the implementation codeunit DIRECTLY — bypasses the base
// table's entry point and all OnBefore/OnAfter integration events.
codeunit 2045720 "CMFRT BA Sales Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CMFRTBAOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        SyncImpl: Codeunit "CMFRT BA SyncPostedDoc Impl";
    begin
        // Direct call to implementation codeunit — OnBefore/OnAfter events on the
        // base table never fire, dependent extensions cannot intercept this operation.
        SyncImpl.CMFRTBASyncPostedSalesDoc(SalesHeader."No.");
    end;
}
