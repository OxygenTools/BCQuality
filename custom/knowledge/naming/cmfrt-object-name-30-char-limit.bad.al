// Anti-pattern: 32 characters with the prefix. The descriptive part
// "Point Of Interest Entry" is 23, over the 21-character budget, so the name
// cannot ship with the mandatory CMFRT prefix.
table 2045730 "CMFRT GD Point Of Interest Entry"
{
    Caption = 'Point Of Interest Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(2045730; "CMFRT GD Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        // Anti-pattern: field names carry the same prefix and the same 30-character
        // limit. This one is 31.
        field(2045731; "CMFRT GD Point Of Interest Name"; Text[100])
        {
            Caption = 'Point Of Interest Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "CMFRT GD Entry No.")
        {
            Clustered = true;
        }
    }
}

// Anti-pattern: the descriptive name is exactly 30 characters, so it compiles
// while unprefixed and looks fine in isolation. Adding "CMFRT GD " makes it 39.
// The reviewer sees a missing-prefix violation; the actual cause is that the
// name was never planned inside the 21-character budget.
codeunit 2045731 "Point Of Interest Distance Mgt"
{
    trigger OnRun()
    begin
    end;
}

// Anti-pattern: abbreviated past comprehensibility to buy room for the prefix.
// It fits at 22 characters, but nobody reading a dependency list can tell what
// this codeunit does.
codeunit 2045732 "CMFRT GD POIDstCalcJnl"
{
    trigger OnRun()
    begin
    end;
}
