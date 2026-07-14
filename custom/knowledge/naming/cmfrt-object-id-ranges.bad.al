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
