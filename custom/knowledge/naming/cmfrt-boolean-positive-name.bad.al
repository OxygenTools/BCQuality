// The Boolean setup field has the name of the inactive state (PR 14444). To post, the user
// clears "Disabled", and the code reads if not NSSetup."CMFRT NS ABR Posting Disabled" then.
table 2045740 "CMFRT NS Setup"
{
    Caption = 'CMFRT NS Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'CMFRT NS Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "CMFRT NS ABR Posting Disabled"; Boolean)
        {
            Caption = 'CMFRT NS ABR Posting Disabled';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies if ABR posting is disabled.';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
