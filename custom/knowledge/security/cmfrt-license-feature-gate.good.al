// App: "CMFRT Continia DC", publisher Astena, idRanges 58751..58800.
// app.json declares the provider as a dependency:
//   { "id": "9a6eb00d-c62e-443d-b405-a4c3128a6f16", "name": "CMFRT License", "publisher": "Astena" }

// Step 1 — src/License/CMFRTCNTDFeatureExtension.EnumExt.al
// Exactly one value; ordinal == this object's own ID; name == app.json "name".
enumextension 58751 "CMFRT CNTD Feature Extension" extends "CMFRT LIF Feature"
{
    value(58751; "CMFRT Continia DC") { }
}

// Step 2 — src/License/CMFRTCNTDLicenseCheck.Codeunit.al
// Thin wrapper: no entitlement logic of its own, OnBefore -> Do -> OnAfter,
// [NonDebuggable] on every link of the chain.
codeunit 58752 "CMFRT CNTD License Check"
{
    [NonDebuggable]
    procedure CMFRTCNTDIsInLicense(Feature: Enum "CMFRT LIF Feature"; ObjectId: Text): Boolean
    var
        Handled: Boolean;
        IsInLicense: Boolean;
    begin
        OnBeforeCMFRTCNTDIsInLicense(Feature, ObjectId, IsInLicense, Handled);
        DoCMFRTCNTDIsInLicense(Feature, ObjectId, IsInLicense, Handled);
        OnAfterCMFRTCNTDIsInLicense(Feature, ObjectId, IsInLicense);
        exit(IsInLicense);
    end;

    [NonDebuggable]
    local procedure DoCMFRTCNTDIsInLicense(Feature: Enum "CMFRT LIF Feature"; var ObjectId: Text; var IsInLicense: Boolean; var Handled: Boolean)
    var
        [NonDebuggable]
        LicenseController: Codeunit "CMFRT LIF License Controller";
    begin
        if Handled then
            exit;
        // Context for the licence-side telemetry: which feature asked, and from which object.
        LicenseController.AddAdditionalCustInfo('callerFeature', Feature.Names().Get(Feature.Ordinals.IndexOf(Feature.AsInteger())));
        LicenseController.AddAdditionalCustInfo('callerObject', ObjectId);
        IsInLicense := LicenseController.CheckIfInLicense(Feature);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTCNTDIsInLicense(Feature: Enum "CMFRT LIF Feature"; var ObjectId: Text; var IsInLicense: Boolean; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTCNTDIsInLicense(Feature: Enum "CMFRT LIF Feature"; var ObjectId: Text; var IsInLicense: Boolean)
    begin
    end;
}

// Step 3 — every page the app itself declares carries the guard, first thing in OnOpenPage.
// The helper instance is stateless, so it is local (patterns/cmfrt-no-object-level-vars).
page 58760 "CMFRT CNTD PstdApprEntries"
{
    Caption = 'CMFRT CNTD Posted Purchase Approval Entries';
    PageType = List;
    SourceTable = "Approval Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("CMFRT CNTD Document No."; Rec."Document No.")
                {
                    ApplicationArea = CMFRTBouwApplicationArea;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        [NonDebuggable]
        LicenseCheck: Codeunit "CMFRT CNTD License Check";
    begin
        // License section - Start
        CurrPage.Editable := LicenseCheck.CMFRTCNTDIsInLicense("CMFRT LIF Feature"::"CMFRT Continia DC", CurrPage.ObjectId());
        // License section - Stop

        Rec.SetRange(Status, Rec.Status::Open);
    end;
}

// Variant — the boolean goes to object scope only when a control actually binds it.
// That is exception 4 of patterns/cmfrt-no-object-level-vars, and nothing more.
page 58762 "CMFRT CNTD ApprovalSetup"
{
    PageType = Card;
    SourceTable = "CMFRT CNTD Setup";

    layout
    {
        area(content)
        {
            group(CMFRTCNTDGeneral)
            {
                Caption = 'CMFRT CNTD General';
                field("CMFRT CNTD Enabled"; Rec."CMFRT CNTD Enabled")
                {
                    ApplicationArea = CMFRTBouwApplicationArea;
                    Enabled = IsInLicense;
                    ToolTip = 'Specifies whether the Continia DC approval screens are active.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        [NonDebuggable]
        LicenseCheck: Codeunit "CMFRT CNTD License Check";
    begin
        // License section - Start
        IsInLicense := LicenseCheck.CMFRTCNTDIsInLicense("CMFRT LIF Feature"::"CMFRT Continia DC", CurrPage.ObjectId());
        CurrPage.Editable := IsInLicense;
        // License section - Stop
    end;

    var
        [NonDebuggable]
        IsInLicense: Boolean;  // bound by Enabled = IsInLicense above
}

// Step 4 — the Objects permission set grants the check codeunit, or the guard
// fails for the very users it is meant to admit.
permissionset 58755 "CMFRT CNTD Objects"
{
    Assignable = true;
    Caption = 'CMFRT CNTD Objects';
    Permissions = page "CMFRT CNTD PstdApprEntries" = X,
        page "CMFRT CNTD ApprovalSetup" = X,
        codeunit "CMFRT CNTD License Check" = X;
}

// Step 5 — out of band, and not code: feature value 58751 "CMFRT Continia DC" has to be
// registered on the Astena licence service. Until it is, CheckIfInLicense answers false and
// every page above opens read-only. State it in the design doc and the ticket close-out.
