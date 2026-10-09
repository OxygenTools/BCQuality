// Test app CMFRT_Woodstoxx_Test. Numbers 01919 and 01920 were assigned by the shared
// AL Object ID Ninja counter through the testnbr skill, for ticket P25034-115.
codeunit 2045701 "CMFRT WDS Test Mand Flds SH"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure CMFRTWDSQuoteAllFieldsFilledNoError()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [TESTNBR] 01919
        // [ISSUENBR] P25034-115
        // [SCENARIO] Happy path - a Sales Quote with all four mandatory fields filled raises no error
        // [GIVEN] Flag ON; a Sales Quote with Your Reference, Shipment Method Code, Payment Method
        // Code, Requested Delivery Date all filled
        CMFRTWDSSetEnforceFlag(true);
        CMFRTWDSCreateCompliantSalesHeader(SalesHeader, SalesHeader."Document Type"::Quote);
        // [WHEN] CMFRTWDSCheckMandatoryFields()
        SalesHeader.CMFRTWDSCheckMandatoryFields();
        // [THEN] no error
    end;

    [Test]
    procedure CMFRTWDSQuoteMissingRefRaisesError()
    var
        SalesHeader: Record "Sales Header";
        Assert: Codeunit Assert;
    begin
        // [TESTNBR] 01920
        // [ISSUENBR] P25034-115
        // [SCENARIO] A Sales Quote without Your Reference is rejected while the flag is on
        // [GIVEN] Flag ON; a compliant Sales Quote with Your Reference cleared
        CMFRTWDSSetEnforceFlag(true);
        CMFRTWDSCreateCompliantSalesHeader(SalesHeader, SalesHeader."Document Type"::Quote);
        SalesHeader."Your Reference" := '';
        // [WHEN] CMFRTWDSCheckMandatoryFields()
        asserterror SalesHeader.CMFRTWDSCheckMandatoryFields();
        // [THEN] the error names the missing field
        Assert.ExpectedError(SalesHeader.FieldCaption("Your Reference"));
    end;
}
