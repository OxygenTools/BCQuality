// Each tooltip answers a question that the caption does not answer.
// The enum field names its values. No tooltip holds the CMFRT prefix or an AL name.
table 2045600 "CMFRT CH ChangeHeader"
{
    Caption = 'CMFRT CH Budget Change Order';
    DataClassification = CustomerContent;

    fields
    {
        field(2045081; "CMFRT CH No."; Code[20])
        {
            Caption = 'CMFRT CH No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the number of the budget change order. The number comes from the number series in the project setup.';
        }
        field(2045100; "CMFRT CH Status"; Enum "CMFRT CH ChangeHeaderStatus")
        {
            Caption = 'CMFRT CH Status';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the state of the budget change order. New: lines can change. Approved: ready to post. Posted: the project budget is updated.';
        }
        field(2045110; "CMFRT CH Reason Code"; Code[10])
        {
            Caption = 'CMFRT CH Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
            ToolTip = 'Specifies why the project budget changes, for example extra work that the client ordered.';
        }
    }

    keys
    {
        key(PK; "CMFRT CH No.") { Clustered = true; }
    }
}

page 2045601 "CMFRT CH ChangeOrder"
{
    Caption = 'CMFRT CH Budget Change Order';
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
                ToolTip = 'Set the budget change order to Approved, so that you can post it. You can approve only a change order with status New.';

                trigger OnAction()
                begin
                    Rec.CMFRTCHApprove();
                end;
            }
        }
    }
}
