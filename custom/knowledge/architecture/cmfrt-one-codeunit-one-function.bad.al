// Two global procedures in one codeunit — mixed concerns, impossible to
// apply interface injection independently to each operation.
codeunit 2045710 "CMFRT BA Price Utilities"
{
    procedure CMFRTBACreateSalesPrice(ItemNo: Code[20]; UnitPrice: Decimal)
    begin
    end;

    // Second global entry point belongs in its own codeunit with its own interface.
    procedure CMFRTBADeleteExpiredPrices(ItemNo: Code[20]; CutoffDate: Date)
    begin
    end;
}
