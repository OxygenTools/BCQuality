codeunit 2045700 "CMFRT TST Calculator"
{
    // Original signature — kept unchanged and marked obsolete once callers migrate.
    [Obsolete('Use CMFRTTSTCalculateSumWithRounding instead.', 'Task-23859')]
    procedure CMFRTTSTCalculateSum(NumberOne: Decimal; NumberTwo: Decimal): Decimal
    begin
        exit(CMFRTTSTCalculateSumWithRounding(NumberOne, NumberTwo, 2));
    end;

    // New overload with extra parameter — callers can adopt at their own pace.
    procedure CMFRTTSTCalculateSumWithRounding(NumberOne: Decimal; NumberTwo: Decimal; Decimals: Integer): Decimal
    begin
        exit(Round(NumberOne + NumberTwo, Power(10, -Decimals)));
    end;
}
