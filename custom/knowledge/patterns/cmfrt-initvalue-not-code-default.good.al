// Part 1 — the eligible-type path, and the resolution this ticket took. The setting started
// as a Duration in milliseconds, which cannot carry InitValue (AL0844). The field was new
// and unshipped, so retyping it to an Integer holding minutes was free: Integer is on the
// AL0844 list, InitValue = 15 is legal, and "15" reads better on the setup page than 900000.
table 55008 "CMFRT AQ Setup"
{
    Caption = 'CMFRT AQ Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(55015; "CMFRT AQ FS Stuck Threshold"; Integer)
        {
            Caption = 'CMFRT AQ FS Stuck Threshold (Min.)';
            DataClassification = CustomerContent;
            // Minutes. InitValue takes a literal, not an expression — 15 * 60 would not
            // compile even here, and on the original Duration no literal was legal at all.
            InitValue = 15;
            MinValue = 0;
            ToolTip = 'Specifies how many minutes a file service buffer entry may stay in Processing before Process Pending treats it as stuck and returns it to Pending.';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    // No fallback branch. Converting the stored unit is not a default — the number comes
    // from the field, and if it is zero the setup is unconfigured, which stays visible.
    procedure CMFRTAQGetStuckThreshold(): Duration
    begin
        Rec.SetLoadFields("CMFRT AQ FS Stuck Threshold");
        if not Rec.Get() then
            exit(0);
        exit(Rec."CMFRT AQ FS Stuck Threshold" * 60 * 1000);
    end;
}

// Part 2 — the ineligible-type path, for when retyping is not available (the field already
// shipped, or the type is genuinely required). Duration, Blob, Media, MediaSet, Guid,
// RecordId and TableFilter are all absent from the AL0844 list, so the default goes on the
// creation path instead. Two things matter here beyond "after Init()":
//   * The slot is between Init() and OnBefore...Insert. The event receives the record by
//     reference with the default already applied, so a subscriber can change it or set
//     IsHandled and suppress the insert. Assigning after the event overwrites that choice.
//   * In the OnBefore -> Do -> OnAfter triple, the assignment lives in the Do local, never
//     in the public wrapper. See events/cmfrt-onbefore-do-onafter.
// Caveat worth knowing: if this procedure is only reached from a setup page's OnOpenPage,
// the default first applies when someone opens that page. An install codeunit is the
// stronger home where the app has one.
codeunit 55030 "CMFRT AQ Setup Init"
{
    procedure CMFRTAQEnsureSetupExists(var IsHandled: Boolean)
    begin
        OnBeforeCMFRTAQEnsureSetupExists(IsHandled);
        DoCMFRTAQEnsureSetupExists(IsHandled);
        OnAfterCMFRTAQEnsureSetupExists(IsHandled);
    end;

    local procedure DoCMFRTAQEnsureSetupExists(IsHandled: Boolean)
    var
        AQSetup: Record "CMFRT AQ Setup";
    begin
        if IsHandled then
            exit;

        if AQSetup.Get() then
            exit;

        AQSetup.Init();
        // The one declaration of the default for a type InitValue cannot reach. It sits
        // before the OnBefore event, so a subscriber still gets the last word.
        AQSetup."CMFRT AQ FS Grace Period" := 5 * 60 * 1000; // 5 minutes

        OnBeforeCMFRTAQEnsureSetupExistsInsert(AQSetup, IsHandled);
        if not IsHandled then
            AQSetup.Insert();
        OnAfterCMFRTAQEnsureSetupExistsInsert(AQSetup);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTAQEnsureSetupExists(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTAQEnsureSetupExists(IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTAQEnsureSetupExistsInsert(var AQSetup: Record "CMFRT AQ Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTAQEnsureSetupExistsInsert(var AQSetup: Record "CMFRT AQ Setup")
    begin
    end;
}

// Part 3 — the type default still has to be decided for rows that already exist, whichever
// path the default took. Substituting 0 into the consumer's expression makes
// SystemModifiedAt < CurrentDateTime - 0 true for every Processing row, so without this the
// first Process Pending run after upgrade would reset live entries. This is resolution (a),
// the default answer when the type default is unsafe.
codeunit 55031 "CMFRT AQ Upgrade Stuck Thr."
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if UpgradeTag.HasUpgradeTag(GetStuckThresholdDefaultTag()) then
            exit;
        SetStuckThresholdOnExistingRows();
        UpgradeTag.SetUpgradeTag(GetStuckThresholdDefaultTag());
    end;

    local procedure SetStuckThresholdOnExistingRows()
    var
        CMFRTAQSetup: Record "CMFRT AQ Setup";
        StuckThresholdDataTransfer: DataTransfer;
    begin
        CMFRTAQSetup.SetRange("CMFRT AQ FS Stuck Threshold", 0);
        if CMFRTAQSetup.IsEmpty() then
            exit;

        StuckThresholdDataTransfer.SetTables(Database::"CMFRT AQ Setup", Database::"CMFRT AQ Setup");
        StuckThresholdDataTransfer.AddSourceFilter(CMFRTAQSetup.FieldNo("CMFRT AQ FS Stuck Threshold"), '=%1', 0);
        // Same literal as the field's InitValue.
        StuckThresholdDataTransfer.AddConstantValue(15, CMFRTAQSetup.FieldNo("CMFRT AQ FS Stuck Threshold"));
        StuckThresholdDataTransfer.CopyFields();
    end;

    local procedure GetStuckThresholdDefaultTag(): Code[250]
    begin
        exit('CMFRT-AQ-55015-StuckThresholdDefault-20260921');
    end;
}
