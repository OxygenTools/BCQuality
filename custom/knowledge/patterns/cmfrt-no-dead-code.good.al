// Only the code that runs. Git history keeps the old lines.
tableextension 2045390 "CMFRT CLP Service Item Group" extends "Service Item Group"
{
    fields
    {
        field(2045390; "CMFRT CLP Climapulse Enabled"; Boolean)
        {
            Caption = 'CMFRT CLP Climapulse Enabled';
            ToolTip = 'Specifies if service items in this group are sent to Climapulse.';
            DataClassification = CustomerContent;
        }
    }

    procedure CMFRTCLPIsClimapulseEnabled(): Boolean
    begin
        exit(Rec."CMFRT CLP Climapulse Enabled");
    end;
}
