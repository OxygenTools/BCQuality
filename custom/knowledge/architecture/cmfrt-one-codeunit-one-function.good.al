// One codeunit — one global entry point — one interface.
interface "CMFRT BA CreateSalesPriceInt"
{
    procedure CMFRTBACreateSalesPrice(ItemNo: Code[20]; UnitPrice: Decimal);
}

codeunit 2045710 "CMFRT BA CreateSalesPriceImpl" implements "CMFRT BA CreateSalesPriceInt"
{
    procedure CMFRTBACreateSalesPrice(ItemNo: Code[20]; UnitPrice: Decimal)
    begin
        CMFRTBAValidateItem(ItemNo);
        CMFRTBAWriteSalesPrice(ItemNo, UnitPrice);
    end;

    local procedure CMFRTBAValidateItem(ItemNo: Code[20])
    begin
    end;

    local procedure CMFRTBAWriteSalesPrice(ItemNo: Code[20]; UnitPrice: Decimal)
    begin
    end;
}
