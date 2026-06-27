// Step 1: Interface with a single procedure.
interface "CMFRT MS ICalcTotals"
{
    procedure CMFRTMSCalcTotals(var MeasureState: Record "CMFRT MS Measure State");
}

// Step 2 & 3: Base-table entry point and interface-accepting overload.
table 2045090 "CMFRT MS Measure State"
{
    procedure CalcTotals()
    var
        DefaultImpl: Codeunit "CMFRT MS CalcTotals Impl";
        Handled: Boolean;
    begin
        OnBeforeDefaultImplCalcTotals(Rec, Handled);
        if Handled then
            exit;
        CalcTotals(DefaultImpl);
    end;

    procedure CalcTotals(CalcImpl: Interface "CMFRT MS ICalcTotals")
    begin
        CalcImpl.CMFRTMSCalcTotals(Rec);
    end;

    // Step 4: OnBefore event with Handled pattern.
    [IntegrationEvent(false, false)]
    local procedure OnBeforeDefaultImplCalcTotals(var Ms: Record "CMFRT MS Measure State"; var Handled: Boolean)
    begin
    end;
}
