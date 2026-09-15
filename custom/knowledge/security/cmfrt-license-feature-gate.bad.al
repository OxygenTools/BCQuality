// App: "CMFRT Continia DC", publisher Astena — a product app, so all of this is wrong.

// Defect 1: no enumextension and no wrapper codeunit at all, and app.json never declares the
// "CMFRT License" dependency. The app ships fully editable to tenants that never bought it,
// and nothing in the build catches it.
page 58760 "CMFRT CNTD PstdApprEntries"
{
    PageType = List;
    SourceTable = "Approval Entry";
    UsageCategory = Lists;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Status, Rec.Status::Open);
    end;
}

// Defect 2: the base app is called straight from the page. The 'callerFeature'/'callerObject'
// context never reaches the licence side, and the two override events do not exist, so no other
// Astena module can intervene without patching this page.
page 58762 "CMFRT CNTD ApprovalSetup"
{
    PageType = Card;
    SourceTable = "CMFRT CNTD Setup";

    trigger OnOpenPage()
    var
        LicenseController: Codeunit "CMFRT LIF License Controller";
    begin
        CurrPage.Editable := LicenseController.CheckIfInLicense("CMFRT LIF Feature"::"CMFRT Continia DC");
    end;
}

// Defect 3: missing licence turns into a hard stop. The shared contract is read-only, not
// blocked — the base app owns whatever the user is told, and this page overrides it.
page 58763 "CMFRT CNTD ApprCommentLines"
{
    PageType = ListPart;
    SourceTable = "Approval Comment Line";

    trigger OnOpenPage()
    var
        LicenseCheck: Codeunit "CMFRT CNTD License Check";
        NotLicensedErr: Label 'Your licence does not include CMFRT Continia DC.';
    begin
        if not LicenseCheck.CMFRTCNTDIsInLicense("CMFRT LIF Feature"::"CMFRT Continia DC", CurrPage.ObjectId()) then
            Error(NotLicensedErr);
    end;
}

// Defect 4: two feature values where the app owns one feature, and neither ordinal matches the
// enumextension's object ID. The licence service answers on the ordinal, so a value that drifts
// from the object ID is unregisterable in practice and collides with another CMFRT app's key.
enumextension 58751 "CMFRT CNTD Feature Extension" extends "CMFRT LIF Feature"
{
    value(59000; "CMFRT Continia DC") { }
    value(59001; "CMFRT Continia DC Advanced") { }
}

// Defect 5: [NonDebuggable] dropped from the wrapper and from the controller variable, so the
// licence chain is readable in the AL debugger; Do carries entitlement logic of its own, which
// is exactly what the base app is for; and the check codeunit is left out of the Objects
// permission set, so the guard errors out for non-SUPER users.
codeunit 58752 "CMFRT CNTD License Check"
{
    procedure CMFRTCNTDIsInLicense(Feature: Enum "CMFRT LIF Feature"; ObjectId: Text): Boolean
    var
        LicenseController: Codeunit "CMFRT LIF License Controller";
    begin
        if UserId() = 'ADMIN' then
            exit(true);
        exit(LicenseController.CheckIfInLicense(Feature));
    end;
}

permissionset 58755 "CMFRT CNTD Objects"
{
    Assignable = true;
    Caption = 'CMFRT CNTD Objects';
    Permissions = page "CMFRT CNTD PstdApprEntries" = X,
        page "CMFRT CNTD ApprovalSetup" = X;
}

// Defect 6: a pageextension on a base-application page seizing Editable. The extension does not
// own that page — gating it hides base functionality the tenant did buy. Gate the app's own page
// that the tile drills down into instead.
pageextension 58761 "CMFRT CNTD ApprActivities" extends "Approvals Activities"
{
    trigger OnOpenPage()
    var
        LicenseCheck: Codeunit "CMFRT CNTD License Check";
    begin
        CurrPage.Editable := LicenseCheck.CMFRTCNTDIsInLicense("CMFRT LIF Feature"::"CMFRT Continia DC", CurrPage.ObjectId());
    end;
}
