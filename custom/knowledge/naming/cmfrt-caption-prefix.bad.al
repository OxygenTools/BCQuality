table 55008 "CMFRT AQ Setup"
{
    fields
    {
        field(55011; "CMFRT AQ FS Jnl. Template Name"; Code[10])
        {
            Caption = 'FS Journal Template Name'; // missing CMFRT AQ prefix
            DataClassification = CustomerContent;
        }
    }
}

page 55020 "CMFRT AQ Setup"
{
    layout
    {
        area(Content)
        {
            field("CMFRT AQ FS Jnl. Template Name"; Rec."CMFRT AQ FS Jnl. Template Name")
            {
                ApplicationArea = All;
                // Page-level overrides duplicate the table definition and drift apart.
                Caption = 'FS Journal Template Name';
                ToolTip = 'Specifies the Job Journal Template used for material lines created by the Field Service API.';
            }
        }
    }
}

enum 55040 "CMFRT AQ Buffer Status"
{
    value(55000; "CMFRT AQ Pending") { Caption = 'Pending'; } // missing prefix
}
