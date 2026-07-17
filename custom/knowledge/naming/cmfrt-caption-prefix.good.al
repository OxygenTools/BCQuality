table 55008 "CMFRT AQ Setup"
{
    fields
    {
        field(55011; "CMFRT AQ FS Jnl. Template Name"; Code[10])
        {
            Caption = 'CMFRT AQ FS Journal Template Name';
            ToolTip = 'Specifies the Job Journal Template used for material lines created by the Field Service API.';
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
                ApplicationArea = All; // Caption and ToolTip inherited from the table field
            }
        }
    }
}

enum 55040 "CMFRT AQ Buffer Status"
{
    value(55000; "CMFRT AQ None") { Caption = 'CMFRT AQ Blanc'; }
    value(55001; "CMFRT AQ Pending") { Caption = 'CMFRT AQ Pending'; }
    value(55002; "CMFRT AQ Processed") { Caption = 'CMFRT AQ Processed'; }
}
