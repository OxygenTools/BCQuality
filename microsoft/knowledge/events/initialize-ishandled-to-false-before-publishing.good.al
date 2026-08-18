// Demonstration-only AL. Not compiled by CI; illustrates the article.
codeunit 50240 "IsHandled Init Good Sample"
{
    procedure ApplyDiscounts(var SalesHeader: Record "Sales Header")
    var
        DiscountPct: Decimal;
        IsHandled: Boolean;
    begin
        // A freshly declared local Boolean is false.
        OnBeforeApplyHeaderDiscount(SalesHeader, DiscountPct, IsHandled);
        if IsHandled then
            exit;
        DiscountPct := 5;

        // Reaching this point proves that IsHandled is still false.
        OnBeforeApplyPaymentDiscount(SalesHeader, DiscountPct, IsHandled);
        if IsHandled then
            exit;
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
