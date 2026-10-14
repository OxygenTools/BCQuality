// The tooltips only repeat the field name. Copilot and the user learn nothing.
table 2045600 "CMFRT CH ChangeHeader"
{
    Caption = 'CMFRT CH ChangeHeader';
    DataClassification = CustomerContent;

    fields
    {
        field(2045081; "CMFRT CH No."; Code[20])
        {
            Caption = 'CMFRT CH No.';
            DataClassification = CustomerContent;
            // Generated text with the prefix in it.
            ToolTip = 'Specifies the value of the CMFRT CH No. field.';
        }
        field(2045100; "CMFRT CH Status"; Enum "CMFRT CH ChangeHeaderStatus")
        {
            Caption = 'CMFRT CH Status';
            DataClassification = CustomerContent;
            // An enum field that does not name its values.
            ToolTip = 'Specifies the status.';
        }
        field(2045110; "CMFRT CH Reason Code"; Code[10])
        {
            Caption = 'CMFRT CH Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
            // An AL name in user text.
            ToolTip = 'Specifies the value of the CMFRTCHReasonCode field';
        }
    }

    keys
    {
        key(PK; "CMFRT CH No.") { Clustered = true; }
    }
}

page 2045601 "CMFRT CH ChangeOrder"
{
    Caption = 'CMFRT CH ChangeOrder';
    PageType = Document;
    SourceTable = "CMFRT CH ChangeHeader";

    actions
    {
        area(Processing)
        {
            action(CMFRTCHApprove)
            {
                Caption = 'CMFRT CH Approve';
                Image = Approve;
                // Names the action and nothing else.
                ToolTip = 'Approve.';

                trigger OnAction()
                begin
                    Rec.CMFRTCHApprove();
                end;
            }
        }
    }
}
