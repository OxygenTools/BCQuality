// The ticket added "Expected Receipt Date" to an existing page. The new field correctly
// carries no page-level ToolTip — it inherits the one on the table field. The fields
// beside it still declare theirs inline, so the page now holds both shapes at once.
pageextension 2045458 "CMFRT JO JobPlanLinePurchView" extends "Job Planning Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("CMFRT JO Vendor No."; Rec."CMFRT JO Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor the purchase line is created for.';
            }
            field("CMFRT JO Order No."; Rec."CMFRT JO Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the purchase order the planning line was posted to.';
            }
            // Added by this ticket — no page-level ToolTip, per the current standard.
            field("CMFRT JO Expected Receipt"; Rec."CMFRT JO Expected Receipt")
            {
                ApplicationArea = All;
            }
        }
    }
}
