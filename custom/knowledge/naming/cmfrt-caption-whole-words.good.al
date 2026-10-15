// The field names are short to fit the 30-character limit.
// The captions use whole words and the glossary term "Bill of Quantities".
table 2045620 "CMFRT LT MeasureState"
{
    Caption = 'CMFRT LT Bill of Quantities';
    DataClassification = CustomerContent;

    fields
    {
        field(2045081; "CMFRT LT Entry No."; Integer)
        {
            Caption = 'CMFRT LT Entry No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the number of the bill of quantities line.';
        }
        field(2045090; "CMFRT LT IgnoreManualPrice"; Boolean)
        {
            Caption = 'CMFRT LT Ignore Manual Price';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies if the unit price from the price list replaces a price that a user entered on the line.';
        }
        field(2045100; "CMFRT LT Templ. Code"; Code[20])
        {
            Caption = 'CMFRT LT Template Code';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the template that creates the lines of a new bill of quantities.';
        }
    }

    keys
    {
        key(PK; "CMFRT LT Entry No.") { Clustered = true; }
    }
}

// Each value caption names a state in whole words.
enum 2045621 "CMFRT LT MeasureStateStatus"
{
    Extensible = true;

    value(2045081; "CMFRT LT Open") { Caption = 'CMFRT LT Open'; }
    value(2045082; "CMFRT LT Sent") { Caption = 'CMFRT LT Sent'; }
    value(2045083; "CMFRT LT Approved") { Caption = 'CMFRT LT Approved'; }
}
