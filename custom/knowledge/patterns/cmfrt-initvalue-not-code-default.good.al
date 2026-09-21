// The default lives once, on the field, as a compile-time literal. The getter is a plain
// singleton read. Because the setup row already exists in every live environment, InitValue
// would not reach it, and 0 is unsafe here — so an upgrade codeunit back-fills it.
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
        field(55015; "CMFRT AQ FS Stuck Threshold"; Duration)
        {
            Caption = 'CMFRT AQ FS Stuck Threshold';
            DataClassification = CustomerContent;
            // Duration is a millisecond count and InitValue takes a literal, not an
            // expression: 15 * 60 * 1000 does not compile. 900000 ms = 15 minutes.
            InitValue = 900000;
            ToolTip = 'Specifies how long a file service buffer entry may stay in Processing before Process Pending treats it as stuck and returns it to Pending.';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    // No fallback branch. The field holds the value; if it is zero the setup is
    // unconfigured, and that is visible on the page rather than papered over here.
    procedure CMFRTAQGetStuckThreshold(): Duration
    begin
        Rec.SetLoadFields("CMFRT AQ FS Stuck Threshold");
        if not Rec.Get() then
            exit(0);
        exit(Rec."CMFRT AQ FS Stuck Threshold");
    end;
}

// Resolution (a) — the default answer when the type default is unsafe. Substituting 0 into
// the consumer's expression makes SystemModifiedAt < CurrentDateTime - 0 true for every
// Processing row, so without this the first Process Pending run after upgrade would reset
// live entries. DataTransfer sets the existing singleton in one server round trip.
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
        // Same literal as the field's InitValue: 900000 ms = 15 minutes.
        StuckThresholdDataTransfer.AddConstantValue(900000, CMFRTAQSetup.FieldNo("CMFRT AQ FS Stuck Threshold"));
        StuckThresholdDataTransfer.CopyFields();
    end;

    local procedure GetStuckThresholdDefaultTag(): Code[250]
    begin
        exit('CMFRT-AQ-55015-StuckThresholdDefault-20260921');
    end;
}
