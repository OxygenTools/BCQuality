// ID 50000 is outside both defined CMFRT ranges and will conflict with
// other extensions that follow the standard AppSource free range.
table 50000 "CMFRT GD POI"
{
    Caption = 'POI';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { DataClassification = CustomerContent; }
    }
}

// ID 2045081 was previously assigned to a removed object.
// Reusing it causes silent conflicts with historical telemetry and upgrade codeunits.
table 2045081 "CMFRT GD New Feature"
{
    Caption = 'New Feature';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { DataClassification = CustomerContent; }
    }
}

// Customer extension (range 55000..55999): a new enum numbered from 0,
// copied from an older released enum in the same repo. Every value is
// outside the licensed range.
enum 55008 "CMFRT AQ Transfer Leg"
{
    Extensible = true;

    value(0; "CMFRT AQ None") { Caption = ' '; }
    value(1; "CMFRT AQ Outbound") { Caption = 'Outbound'; }
    value(2; "CMFRT AQ Inbound") { Caption = 'Inbound'; }
}
