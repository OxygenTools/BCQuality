// Demonstration-only AL. Not compiled by CI; illustrates the article.
codeunit 50241 "IsHandled Init Bad Sample"
{
    procedure ApplyDiscounts(var SalesHeader: Record "Sales Header")
    var
        DiscountPct: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeApplyHeaderDiscount(SalesHeader, DiscountPct, IsHandled);
        if not IsHandled then
            DiscountPct := 5;

        // Bug: execution continues when the first event set IsHandled to true,
        // and that stale value is passed to a different publisher.
        OnBeforeApplyPaymentDiscount(SalesHeader, DiscountPct, IsHandled);
        if not IsHandled then
            DiscountPct += 2;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyHeaderDiscount(var SalesHeader: Record "Sales Header"; var DiscountPct: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyPaymentDiscount(var SalesHeader: Record "Sales Header"; var DiscountPct: Decimal; var IsHandled: Boolean)
    begin
    end;
}
