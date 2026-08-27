// Anti-pattern: the whole of test app CMFRT_GD_Test. Two test codeunits and no
// codeunit with Subtype = Install anywhere in the app. Publishing leaves the
// AL Test Suite table empty, so the suite exists only for as long as whoever last
// opened the AL Test Tool kept their container. A pipeline that runs suite
// 'CMFRTGD' finds zero test methods and reports success.
codeunit 2045701 "CMFRT GD POI Post Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure CMFRTGDPostCreatesLedgerEntry()
    begin
    end;
}

codeunit 2045702 "CMFRT GD POI Delete Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure CMFRTGDDeleteCascadesToLines()
    begin
    end;
}

// Anti-pattern: the near-miss variants. Each of these ships an install codeunit
// and still leaves the suite wrong.
codeunit 2045798 "CMFRT GD Test Install Bad"
{
    // Anti-pattern: Upgrade instead of Install. Never runs on a first install, so
    // the fresh CI container — the only environment that matters here — gets nothing.
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        ALTestSuite: Record "AL Test Suite";
        TestSuiteMgt: Codeunit "Test Suite Mgt.";
    begin
        // Anti-pattern: no Delete(true) first, so a suite left over from a previous
        // version keeps lines for test codeunits that were renamed or removed.
        if not ALTestSuite.Get('CMFRTGD') then
            TestSuiteMgt.CreateTestSuite('CMFRTGD');

        // Anti-pattern: no Commit(), so SelectTestMethods* reads a header the
        // transaction has not written yet.
        ALTestSuite.Get('CMFRTGD');

        // Anti-pattern: codeunit-by-codeunit registration. Codeunit 2045702 above
        // was added later and nobody edited this list, so its tests never run.
        TestSuiteMgt.SelectTestMethodsByCodeunit(ALTestSuite, 2045701);
    end;
}
