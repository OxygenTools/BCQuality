// The captions copy the short field names. After translation the user sees
// "IgnoreManualPrice" and "Templ. Code". The table uses a synonym, not the glossary term.
table 2045620 "CMFRT LT MeasureState"
{
    Caption = 'CMFRT LT MeasureState';
    DataClassification = CustomerContent;

    fields
    {
        field(2045081; "CMFRT LT Entry No."; Integer)
        {
            Caption = 'CMFRT LT Entry No.';
            DataClassification = CustomerContent;
        }
        field(2045090; "CMFRT LT IgnoreManualPrice"; Boolean)
        {
            Caption = 'CMFRT LT IgnoreManualPrice';
            DataClassification = CustomerContent;
        }
        field(2045100; "CMFRT LT Templ. Code"; Code[20])
        {
            Caption = 'CMFRT LT Templ. Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "CMFRT LT Entry No.") { Clustered = true; }
    }
}

// "Send" is a verb. "Exported to Excel" is an event, not a state.
enum 2045621 "CMFRT LT MeasureStateStatus"
{
    Extensible = true;

    value(2045081; "CMFRT LT Open") { Caption = 'CMFRT LT Open'; }
    value(2045082; "CMFRT LT Send") { Caption = 'CMFRT LT Send'; }
    value(2045083; "CMFRT LT Exported to Excel") { Caption = 'CMFRT LT Exported to Excel'; }
}
