// Product extension — IDs are within the product range 2045081..2046580.
table 2045081 "CMFRT GD POI"
{
    Caption = 'POI';
    DataClassification = CustomerContent;

    fields
    {
        field(2045081; "Code"; Code[20]) { DataClassification = CustomerContent; }
        field(2045082; "Description"; Text[100]) { DataClassification = CustomerContent; }
    }
}

// Customer extension — IDs are within the customer range 55000..55999.
table 55000 "CMFRT JO Customer Site"
{
    Caption = 'Customer Site';
    DataClassification = CustomerContent;

    fields
    {
        field(55000; "Code"; Code[20]) { DataClassification = CustomerContent; }
        field(55001; "Transfer Leg"; Enum "CMFRT AQ Transfer Leg")
        {
            DataClassification = CustomerContent;
            InitValue = "CMFRT AQ None";
        }
    }
}

// Enum values come from the same range; the blank member is the first range ID,
// and the field above defaults to it through InitValue.
enum 55008 "CMFRT AQ Transfer Leg"
{
    Extensible = true;

    value(55000; "CMFRT AQ None") { Caption = ' '; }
    value(55001; "CMFRT AQ Outbound") { Caption = 'Outbound'; }
    value(55002; "CMFRT AQ Inbound") { Caption = 'Inbound'; }
}
