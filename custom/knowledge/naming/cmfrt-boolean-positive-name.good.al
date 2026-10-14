// The Boolean setup field has the name of the state that it turns on. The code reads
// if NSSetup."CMFRT NS ABR Posting Enabled" then, with no double negative.
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
        field(10; "CMFRT NS ABR Posting Enabled"; Boolean)
        {
            Caption = 'CMFRT NS ABR Posting Enabled';
            DataClassification = CustomerContent;
            // ABR posting worked before this field existed. InitValue covers new companies,
            // and the upgrade codeunit sets the field on the existing setup record.
            InitValue = true;
            ToolTip = 'Specifies if ABR entries are posted. New companies start with this field selected. Clear the field to stop the posting.';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
