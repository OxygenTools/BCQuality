pageextension 2045680 "CMFRT AQ Posted Rcpt Subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addlast(Control1)
        {
            // All shows the control to users who did not buy the feature of the app.
            field("CMFRT AQ Lift No."; Rec."CMFRT AQ Lift No.")
            {
                ApplicationArea = All;
            }

            // Basic is also wrong. The control must use the ApplicationArea of the app.
            field("CMFRT AQ Inspection Date"; Rec."CMFRT AQ Inspection Date")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
