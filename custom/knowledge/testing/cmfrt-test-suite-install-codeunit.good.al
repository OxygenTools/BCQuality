// The test app CMFRT_GD_Test declares idRanges 2045700..2045799 in its app.json.
// This install codeunit is the only object in the app that is not a test codeunit.
codeunit 2045799 "CMFRT GD Test Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        DoCMFRTGDRegisterTestSuite();
    end;

    local procedure DoCMFRTGDRegisterTestSuite()
    var
        ALTestSuite: Record "AL Test Suite";
        TestSuiteMgt: Codeunit "Test Suite Mgt.";
        SuiteCode: Code[10];
        SuiteCodeTok: Label 'CMFRTGD', Locked = true;
        // The app's full declared idRanges, not the IDs that happen to exist today.
        TestRangeTok: Label '2045700..2045799', Locked = true;
    begin
        SuiteCode := CopyStr(SuiteCodeTok, 1, MaxStrLen(ALTestSuite.Name));

        // Delete first so reinstall and upgrade both land on a suite that
        // reflects exactly the codeunits this version ships.
        if ALTestSuite.Get(SuiteCode) then
            ALTestSuite.Delete(true);

        TestSuiteMgt.CreateTestSuite(SuiteCode);

        // Required: CreateTestSuite writes the header that SelectTestMethodsByRange
        // reads back on the next line.
        Commit();

        ALTestSuite.Get(SuiteCode);
        TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, TestRangeTok);
    end;
}

codeunit 2045701 "CMFRT GD POI Post Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure CMFRTGDPostCreatesLedgerEntry()
    begin
        // Picked up by the range above with no edit to the install codeunit.
    end;
}
