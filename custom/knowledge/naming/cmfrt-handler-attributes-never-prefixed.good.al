// Test codeunit in CMFRT_AdresMgmnt_Test. The platform attributes are written verbatim;
// the CMFRT AM prefix sits on the procedure names, which is all cmfrt-naming-prefix asks for.
codeunit 80001 "CMFRT AM Designation Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        TestLibrary: Codeunit "CMFRT AM Test Library";

    [Test]
    [HandlerFunctions('CMFRTAMConfirmGapWarning')]
    procedure CMFRTAMDeleteMiddleDesignationOpensGapAllowed()
    var
        CMFRTAMAddress: Record "CMFRT AM Address";
        MiddleDesignation: Record "CMFRT AM Designation";
    begin
        // GIVEN an address with a designation in the middle of its coverage history
        TestLibrary.CMFRTAMCreateAddress(CMFRTAMAddress);
        TestLibrary.CMFRTAMCreateDesignation(MiddleDesignation, CMFRTAMAddress."CMFRT AM No.", DMY2Date(1, 2, 2025), DMY2Date(28, 2, 2025));

        // WHEN deleting it and accepting the gap-warning confirmation
        LibraryVariableStorage.Enqueue('gap in the coverage');
        LibraryVariableStorage.Enqueue(true);
        MiddleDesignation.Delete(true);
        LibraryVariableStorage.AssertEmpty();

        // THEN the delete is allowed
        Assert.IsFalse(MiddleDesignation.Get(CMFRTAMAddress."CMFRT AM No.", DMY2Date(1, 2, 2025)), 'Middle designation should have been deleted.');
    end;

    // The attribute is the platform token. The procedure name is prefixed, self-describing,
    // and global — every documented handler signature requires global scope.
    [ConfirmHandler]
    procedure CMFRTAMConfirmGapWarning(Question: Text; var Reply: Boolean)
    var
        ExpectedFragment: Text;
    begin
        ExpectedFragment := LibraryVariableStorage.DequeueText();
        Assert.ExpectedConfirm(ExpectedFragment, Question);
        Reply := LibraryVariableStorage.DequeueBoolean();
    end;

    [MessageHandler]
    procedure CMFRTAMHandleInfoMessage(Message: Text[1024])
    begin
        Assert.ExpectedMessage(LibraryVariableStorage.DequeueText(), Message);
    end;
}
