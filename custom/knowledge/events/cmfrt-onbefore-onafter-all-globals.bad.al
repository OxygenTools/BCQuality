// No integration events — dependent extensions cannot intercept or react
// to the operation without using an AL override, which is a breaking pattern.
codeunit 2045700 "CMFRT BA Item Price Impl"
{
    procedure CMFRTBAUpdateItemPrice(ItemNo: Code[20]; UnitPrice: Decimal)
    var
        Item: Record Item;
    begin
        Item.SetLoadFields("Unit Price");
        if Item.Get(ItemNo) then begin
            Item.Validate("Unit Price", UnitPrice);
            Item.Modify();
        end;
    end;
}
