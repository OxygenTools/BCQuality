pageextension 55120 "CMFRT AQ Posted Rcpt Subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addlast(Control1)
        {
            // Every new control uses the ApplicationArea of the app.
            field("CMFRT AQ Lift No."; Rec."CMFRT AQ Lift No.")
            {
                ApplicationArea = CMFRTBouwApplicationArea;
            }

            field("CMFRT AQ Inspection Date"; Rec."CMFRT AQ Inspection Date")
            {
                ApplicationArea = CMFRTBouwApplicationArea;
            }
        }
    }
}
