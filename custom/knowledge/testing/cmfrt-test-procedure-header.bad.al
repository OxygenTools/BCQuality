codeunit 85001 "CMFRT WDS Test Mand Flds SH"
{
    Subtype = Test;
    TestPermissions = Disabled;

    // Anti-pattern: no header at all. The test cannot be traced to a ticket and
    // holds no number in the shared ledger.
    [Test]
    procedure CMFRTWDSQuoteAllFieldsFilledNoError()
    var
        SalesHeader: Record "Sales Header";
    begin
        CMFRTWDSSetEnforceFlag(true);
        CMFRTWDSCreateCompliantSalesHeader(SalesHeader, SalesHeader."Document Type"::Quote);
        SalesHeader.CMFRTWDSCheckMandatoryFields();
    end;

    // Anti-pattern: number picked as "highest TESTNBR in this app + 1". Another
    // CMFRT test app already holds 01919, so the number is now on two tests.
    // The header also sits below the setup instead of directly after begin.
    [Test]
    procedure CMFRTWDSQuoteMissingRefRaisesError()
    var
        SalesHeader: Record "Sales Header";
    begin
        CMFRTWDSSetEnforceFlag(true);
        // [TESTNBR] 01919
        // [ISSUENBR] P25034-115
        // [SCENARIO] A Sales Quote without Your Reference is rejected
        CMFRTWDSCreateCompliantSalesHeader(SalesHeader, SalesHeader."Document Type"::Quote);
        SalesHeader."Your Reference" := '';
        asserterror SalesHeader.CMFRTWDSCheckMandatoryFields();
    end;

    // Anti-pattern: malformed numbers seen in the current test apps. 458 is not
    // padded, SP-031 is a per-app series and TBD is a placeholder that was never
    // replaced. The first one has no [ISSUENBR] line either.
    [Test]
    procedure CMFRTWDSOrderMissingRefRaisesError()
    begin
        // [TESTNBR] 458
        // [SCENARIO] A Sales Order without Your Reference is rejected
    end;

    [Test]
    procedure CMFRTWDSInvoiceMissingRefRaisesError()
    begin
        // [TESTNBR] SP-031
        // [ISSUENBR] TBD
        // [SCENARIO] A Sales Invoice without Your Reference is rejected
    end;
}
