// Anti-pattern: a header table with no OnDelete trigger. TableRelation on the line
// table (below) validates that the header exists when a line is written — it never
// deletes anything. Deleting this header leaves every line, log row, and comment in
// the database, and nothing reports it.
table 2045755 "CMFRT GD POI Header"
{
    Caption = 'POI Header';
    DataClassification = CustomerContent;

    fields
    {
        field(2045755; "CMFRT GD No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "CMFRT GD No.")
        {
            Clustered = true;
        }
    }
}

table 2045756 "CMFRT GD POI Line"
{
    Caption = 'POI Line';
    DataClassification = CustomerContent;

    fields
    {
        field(2045755; "CMFRT GD Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            // Anti-pattern (the belief, not the property): this relation is often
            // assumed to cascade the delete. It does not — BC has no declarative
            // cascade delete.
            TableRelation = "CMFRT GD POI Header"."CMFRT GD No.";
        }
        field(2045756; "CMFRT GD Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "CMFRT GD Document No.", "CMFRT GD Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        POIHeader: Record "CMFRT GD POI Header";
    begin
        // Anti-pattern: cascading upward. The header's OnDelete is already running
        // when this line is deleted as part of the cascade, so the two triggers
        // recurse into each other.
        if POIHeader.Get(Rec."CMFRT GD Document No.") then
            POIHeader.Delete(true);
    end;
}

codeunit 2045757 "CMFRT GD POI Post"
{
    procedure CMFRTGDDeleteDocument(DocumentNo: Code[20])
    var
        POIHeader: Record "CMFRT GD POI Header";
        POILine: Record "CMFRT GD POI Line";
        POIComment: Record "CMFRT GD POI Comment";
    begin
        POILine.SetRange("CMFRT GD Document No.", DocumentNo);
        // Anti-pattern: false skips each line's own OnDelete, so the lines go but
        // every comment hanging off them is orphaned.
        POILine.DeleteAll(false);

        // Anti-pattern: an unfiltered DeleteAll inside a delete routine wipes the
        // comment table for every document, not just this one.
        POIComment.DeleteAll(true);

        if POIHeader.Get(DocumentNo) then
            // Anti-pattern: Delete() without true skips the header's OnDelete
            // trigger. Even a correctly written cascade produces orphans when one
            // call site deletes the parent like this.
            POIHeader.Delete();
    end;
}
