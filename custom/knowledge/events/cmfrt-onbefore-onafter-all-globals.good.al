codeunit 2045700 "CMFRT BA Item Price Impl"
{
    procedure CMFRTBAUpdateItemPrice(ItemNo: Code[20]; UnitPrice: Decimal)
    var
        Item: Record Item;
        Handled: Boolean;
    begin
        OnBeforeCMFRTBAUpdateItemPrice(ItemNo, UnitPrice, Handled);
        if Handled then
            exit;

        Item.SetLoadFields("Unit Price");
        if Item.Get(ItemNo) then begin
            Item.Validate("Unit Price", UnitPrice);
            Item.Modify();
        end;

        OnAfterCMFRTBAUpdateItemPrice(ItemNo, UnitPrice);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTBAUpdateItemPrice(ItemNo: Code[20]; UnitPrice: Decimal; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTBAUpdateItemPrice(ItemNo: Code[20]; UnitPrice: Decimal)
    begin
    end;
}
