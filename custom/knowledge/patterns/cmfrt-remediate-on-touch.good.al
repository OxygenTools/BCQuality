// Same ticket, remediated on touch: the two pre-existing page-level tooltips moved to the
// table extension fields this app owns, so every field on the page now inherits. The move
// is mechanical and breaks no dependent — only the .g.xlf trans-units are re-keyed.
tableextension 2045458 "CMFRT JO PurchaseJobPlanning" extends "Job Planning Line"
{
    fields
    {
        field(2045458; "CMFRT JO Vendor No."; Code[20])
        {
            Caption = 'CMFRT JO Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            ToolTip = 'Specifies the vendor the purchase line is created for.';
        }
        field(2045459; "CMFRT JO Order No."; Code[20])
        {
            Caption = 'CMFRT JO Order No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the purchase order the planning line was posted to.';
        }
        field(2045460; "CMFRT JO Expected Receipt"; Date)
        {
            Caption = 'CMFRT JO Expected Receipt';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date the vendor is expected to deliver the planned quantity.';
        }
    }
}

pageextension 2045458 "CMFRT JO JobPlanLinePurchView" extends "Job Planning Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("CMFRT JO Vendor No."; Rec."CMFRT JO Vendor No.")
            {
                ApplicationArea = All;
            }
            field("CMFRT JO Order No."; Rec."CMFRT JO Order No.")
            {
                ApplicationArea = All;
            }
            field("CMFRT JO Expected Receipt"; Rec."CMFRT JO Expected Receipt")
            {
                ApplicationArea = All;
            }
        }
    }
}
