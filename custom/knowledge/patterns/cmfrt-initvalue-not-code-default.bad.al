// Defect 1 — the default lives in code. The field carries no InitValue, and the getter
// substitutes a constant whenever the stored value is zero. Two copies of one default: the
// next person to tune it edits the field on the setup page, sees no change on any tenant
// that never set it, and the page shows a blank field that behaves as fifteen minutes.
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
            ToolTip = 'Specifies how long a file service buffer entry may stay in Processing before Process Pending treats it as stuck and returns it to Pending.';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure CMFRTAQGetStuckThreshold(): Duration
    var
        StuckThreshold: Duration;
    begin
        Rec.SetLoadFields("CMFRT AQ FS Stuck Threshold");
        if Rec.Get() then
            StuckThreshold := Rec."CMFRT AQ FS Stuck Threshold";
        // The anti pattern. An unconfigured setting and a deliberate zero are now
        // indistinguishable, and the setup page lies about what the system will do.
        if StuckThreshold = 0 then
            StuckThreshold := 15 * 60 * 1000; // fallback
        exit(StuckThreshold);
    end;
}

// Defect 2 — the half-migrated variant, and the one that survives review. InitValue is on
// the field and the fallback is gone, so the diff reads as the correct fix. But the setup
// singleton already exists in every live environment, InitValue never touches an existing
// row, and no upgrade codeunit ships. New tenants run on 15 minutes; every existing tenant
// runs on 0 indefinitely, and 0 makes the stuck test true for every Processing row.
// InitValue present with no recorded decision about existing rows is an incomplete change.
tableextension 55108 "CMFRT AQ SetupExtHalfDone" extends "CMFRT AQ Setup"
{
    fields
    {
        field(55016; "CMFRT AQ FS Retry Threshold"; Duration)
        {
            Caption = 'CMFRT AQ FS Retry Threshold';
            DataClassification = CustomerContent;
            InitValue = 900000;
            ToolTip = 'Specifies how long to wait before retrying a failed file service buffer entry.';
        }
    }
}

// Defect 3 — the fallback relocated. Moving the constant out of the getter into a helper,
// a Label or a case arm changes nothing: the default still appears somewhere other than the
// field declaration, so the two copies can still drift apart.
codeunit 55032 "CMFRT AQ FS Defaults"
{
    procedure GetStuckThresholdOrDefault(StoredThreshold: Duration): Duration
    begin
        if StoredThreshold <> 0 then
            exit(StoredThreshold);
        exit(900000);
    end;
}
