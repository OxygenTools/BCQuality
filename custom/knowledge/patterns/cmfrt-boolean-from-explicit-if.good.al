codeunit 2045677 "CMFRT AQ Item Skip Check"
{
    procedure CMFRTAQCheckItem(Item: Record Item; var IsSkipped: Boolean; var IsBlocked: Boolean)
    begin
        // A var parameter can carry an old value, so it gets its default first.
        IsSkipped := false;
        if Item.Type = Item.Type::"Non-Inventory" then
            IsSkipped := true;

        IsBlocked := false;
        if Item.Blocked or Item."Sales Blocked" then
            IsBlocked := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeTestNoSeries, '', false, false)]
    local procedure CMFRTAQOnBeforeTestNoSeries(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        // An event flag is only set to true, never reset to false.
        if SalesHeader."No." = '' then
            IsHandled := true;
    end;
}
