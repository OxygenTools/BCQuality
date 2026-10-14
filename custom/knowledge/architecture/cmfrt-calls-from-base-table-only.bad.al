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

// The table-extension procedure holds the logic itself (PR 14713): it marks the
// service orders, counts them and opens a page. Only the call belongs here.
tableextension 2045730 "CMFRT ST Purchase Header" extends "Purchase Header"
{
    procedure CMFRTSTShowServiceOrders()
    var
        ServiceHeader: Record "Service Header";
        CMFRTSTServiceOrderMarker: Codeunit "CMFRT ST ServiceOrderMarker";
    begin
        CMFRTSTServiceOrderMarker.CMFRTSTMarkServiceOrders(Rec, ServiceHeader);
        ServiceHeader.MarkedOnly(true);
        case ServiceHeader.Count() of
            0:
                exit;
            1:
                begin
                    ServiceHeader.FindFirst();
                    Page.Run(Page::"Service Order", ServiceHeader);
                end;
            else
                Page.Run(Page::"Service Orders", ServiceHeader);
        end;
    end;
}
