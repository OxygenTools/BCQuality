// Monolithic entry-point: the implementation is embedded, there is no interface,
// and there is no OnBefore event. Dependent extensions cannot override the
// calculation without an AL override hack.
table 2045090 "CMFRT MS Measure State"
{
    procedure CalcTotals()
    begin
        // All calculation logic is hard-coded here.
        Rec."Total Amount" := Rec."Line Amount" + Rec."Tax Amount";
        Rec.Modify();
    end;
}
