// Test codeunit in CMFRT_AdresMgmnt_Test. The platform attributes are written verbatim;
// the CMFRT AM prefix sits on the procedure names, which is all cmfrt-naming-prefix asks for.
codeunit 80001 "CMFRT AM Designation Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    // Only the handler channel is object-level: handler attributes have platform-fixed
    // signatures, and Library - Variable Storage is not SingleInstance, so the test method
    // and its handler can reach the same queue no other way. Assert and TestLibrary are
    // declared per procedure — see patterns/cmfrt-no-object-level-vars.
    var
        LibraryVariableStorage: Codeunit "Library - Variable Storage";

    [Test]
    [HandlerFunctions('CMFRTAMConfirmGapWarning')]
    procedure CMFRTAMDeleteMiddleDesignationOpensGapAllowed()
    var
        CMFRTAMAddress: Record "CMFRT AM Address";
        MiddleDesignation: Record "CMFRT AM Designation";
        Assert: Codeunit Assert;
        TestLibrary: Codeunit "CMFRT AM Test Library";
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
        Assert: Codeunit Assert;
        ExpectedFragment: Text;
    begin
        ExpectedFragment := LibraryVariableStorage.DequeueText();
        Assert.ExpectedConfirm(ExpectedFragment, Question);
        Reply := LibraryVariableStorage.DequeueBoolean();
    end;

    [MessageHandler]
    procedure CMFRTAMHandleInfoMessage(Message: Text[1024])
    var
        Assert: Codeunit Assert;
    begin
        Assert.ExpectedMessage(LibraryVariableStorage.DequeueText(), Message);
    end;
}
