// Anti-pattern: the CMFRT AM prefix was applied to the handler attribute as well as to the
// procedure name. ALOps build 76465 failed with three errors from this one token.
codeunit 80001 "CMFRT AM Designation Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        TestLibrary: Codeunit "CMFRT AM Test Library";

    [Test]
    [HandlerFunctions('CMFRTAMConfirmHandler')]
    // AL0499: The handler function CMFRTAMConfirmHandler was not found. The test method is
    // blamed, but the defect is the attribute on the declaration below.
    procedure CMFRTAMDeleteMiddleDesignationOpensGapAllowed()
    var
        CMFRTAMAddress: Record "CMFRT AM Address";
        MiddleDesignation: Record "CMFRT AM Designation";
    begin
        TestLibrary.CMFRTAMCreateAddress(CMFRTAMAddress);
        TestLibrary.CMFRTAMCreateDesignation(MiddleDesignation, CMFRTAMAddress."CMFRT AM No.", DMY2Date(1, 2, 2025), DMY2Date(28, 2, 2025));

        LibraryVariableStorage.Enqueue('gap in the coverage');
        LibraryVariableStorage.Enqueue(true);
        MiddleDesignation.Delete(true);
        LibraryVariableStorage.AssertEmpty();

        Assert.IsFalse(MiddleDesignation.Get(CMFRTAMAddress."CMFRT AM No.", DMY2Date(1, 2, 2025)), 'Middle designation should have been deleted.');
    end;

    [Test]
    [HandlerFunctions('CMFRTAMConfirmHandler')]
    // AL0499 again: every reference to the unregistered handler fails, so one wrong token
    // reports once per call site plus once on the declaration.
    procedure CMFRTAMDeleteLastDesignationAllowed()
    begin
        // ...
    end;

    // AL0112: CMFRTAMConfirmHandler is not a valid attribute. Handler attributes are a closed
    // set of platform names; mandatoryPrefix does not reach them. AL0112 also suppresses the
    // remaining diagnostics on this declaration, so the signature and scope are unverified
    // until the attribute is corrected.
    [CMFRTAMConfirmHandler]
    procedure CMFRTAMConfirmHandler(Question: Text; var Reply: Boolean)
    var
        ExpectedFragment: Text;
    begin
        ExpectedFragment := LibraryVariableStorage.DequeueText();
        Assert.ExpectedConfirm(ExpectedFragment, Question);
        Reply := LibraryVariableStorage.DequeueBoolean();
    end;
}
