codeunit 2045677 "CMFRT AQ Item Skip Check"
{
    procedure CMFRTAQCheckItem(Item: Record Item; var IsSkipped: Boolean; var IsBlocked: Boolean)
    begin
        // The comparison result goes straight into the Boolean: two = signs with different meanings.
        IsSkipped := Item.Type = Item.Type::"Non-Inventory";
        IsBlocked := Item."Sales Blocked" <> false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeTestNoSeries, '', false, false)]
    local procedure CMFRTAQOnBeforeTestNoSeries(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        // Also sets IsHandled to false when another subscriber already set it to true.
        IsHandled := SalesHeader."No." = '';
    end;
}
