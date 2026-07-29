// 18 characters including the prefix: the descriptive part "POI Entry" is 9,
// well inside the 21-character budget, with room for a later "Line" or "Buffer".
table 2045733 "CMFRT GD POI Entry"
{
    Caption = 'POI Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(2045733; "CMFRT GD Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        // Field names are measured the same way: 15 characters with the prefix.
        // The Caption carries the full wording, so the name does not have to.
        field(2045734; "CMFRT GD POI Name"; Text[100])
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

// Exactly at the 21-character budget (30 in total) and still readable: the
// descriptive part was planned around the prefix instead of shortened after it.
codeunit 2045735 "CMFRT GD POI Distance"
{
    // Procedure names are not bound by the 30-character limit, so they stay
    // fully self-describing per cmfrt-naming-prefix.md.
    procedure CMFRTGDCalculatePointOfInterestDistance(POIId: Guid): Decimal
    begin
    end;
}
