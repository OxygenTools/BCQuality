// Commented-out code, an empty OnValidate trigger and an empty snippet procedure.
tableextension 2045390 "CMFRT CLP Service Item Group" extends "Service Item Group"
{
    fields
    {
        field(2045390; "CMFRT CLP Climapulse Enabled"; Boolean)
        {
            Caption = 'CMFRT CLP Climapulse Enabled';
            ToolTip = 'Specifies if service items in this group are sent to Climapulse.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
    }

    procedure CMFRTCLPIsClimapulseEnabled(): Boolean
    begin
        // if Rec."CMFRT CLP Climapulse Enabled" then
        //     exit(true);
        // exit(false);
        exit(Rec."CMFRT CLP Climapulse Enabled");
    end;

    procedure CMFRTCLP()
    var
        myInt: Integer;
    begin
    end;
}
