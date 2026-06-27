codeunit 2045700 "CMFRT TST Calculator"
{
    // Original signature modified in place — every caller must update simultaneously.
    // Dependent extensions that were not recompiled fail at runtime.
    procedure CMFRTTSTCalculateSum(NumberOne: Decimal; NumberTwo: Decimal; Decimals: Integer): Decimal
    begin
        exit(Round(NumberOne + NumberTwo, Power(10, -Decimals)));
    end;
}
