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

// The table-extension procedure is a thin shell: one call into the Meth codeunit.
tableextension 2045730 "CMFRT ST Purchase Header" extends "Purchase Header"
{
    procedure CMFRTSTShowServiceOrders()
    var
        CMFRTSTShowServOrdersMeth: Codeunit "CMFRT ST ShowServOrdersMeth";
    begin
        CMFRTSTShowServOrdersMeth.CMFRTSTShowServiceOrders(Rec);
    end;
}

// The Meth codeunit holds the logic inside its OnBefore/Do/OnAfter bracket.
codeunit 2045731 "CMFRT ST ShowServOrdersMeth"
{
    procedure CMFRTSTShowServiceOrders(var PurchaseHeader: Record "Purchase Header")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCMFRTSTShowServiceOrders(PurchaseHeader, IsHandled);
        DoCMFRTSTShowServiceOrders(PurchaseHeader, IsHandled);
        OnAfterCMFRTSTShowServiceOrders(PurchaseHeader);
    end;

    local procedure DoCMFRTSTShowServiceOrders(var PurchaseHeader: Record "Purchase Header"; IsHandled: Boolean)
    var
        ServiceHeader: Record "Service Header";
    begin
        if IsHandled then
            exit;
        CMFRTSTMarkServiceOrders(PurchaseHeader, ServiceHeader);
        ServiceHeader.MarkedOnly(true);
        case ServiceHeader.Count() of
            0:
                exit; // No purchase line refers to a service order, so there is nothing to show.
            1:
                begin
                    ServiceHeader.FindFirst();
                    Page.Run(Page::"Service Order", ServiceHeader);
                end;
            else
                Page.Run(Page::"Service Orders", ServiceHeader);
        end;
    end;

    local procedure CMFRTSTMarkServiceOrders(var PurchaseHeader: Record "Purchase Header"; var ServiceHeader: Record "Service Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetFilter("CMFRT JO Service Order No.", '<>%1', '');
        if PurchaseLine.FindSet() then
            repeat
                if ServiceHeader.Get(ServiceHeader."Document Type"::Order, PurchaseLine."CMFRT JO Service Order No.") then
                    ServiceHeader.Mark(true);
            until PurchaseLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTSTShowServiceOrders(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTSTShowServiceOrders(var PurchaseHeader: Record "Purchase Header")
    begin
    end;
}

// A second pair in a feature folder is allowed (PR 14793). The shell only calls the Impl codeunit.
codeunit 55050 "CMFRT WDS QuoteLay Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CMFRTWDSOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CMFRTWDSQuoteLaySubscribersImpl: Codeunit "CMFRT WDS QuoteLay SubscribersImpl";
    begin
        CMFRTWDSQuoteLaySubscribersImpl.CMFRTWDSOnAfterPostSalesDoc(SalesHeader);
    end;
}

// The Impl codeunit of the pair holds the OnBefore/Do/OnAfter bracket.
codeunit 55051 "CMFRT WDS QuoteLay SubscribersImpl"
{
    procedure CMFRTWDSOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCMFRTWDSOnAfterPostSalesDoc(SalesHeader, IsHandled);
        DoCMFRTWDSOnAfterPostSalesDoc(SalesHeader, IsHandled);
        OnAfterCMFRTWDSOnAfterPostSalesDoc(SalesHeader);
    end;

    local procedure DoCMFRTWDSOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; IsHandled: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if IsHandled then
            exit;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.ModifyAll("Qty. to Ship", 0);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTWDSOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTWDSOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    begin
    end;
}
