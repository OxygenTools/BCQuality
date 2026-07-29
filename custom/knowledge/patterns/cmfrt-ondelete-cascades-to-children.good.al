namespace Astena.CMFRT.GD;

// Verify this namespace against the symbols the app compiles against — see
// patterns/cmfrt-namespace-using-directives.md.
using Microsoft.Sales.Customer;

// The owned parent cascades to EVERY dependent table, not only the lines.
table 2045750 "CMFRT GD POI Header"
{
    Caption = 'POI Header';
    DataClassification = CustomerContent;

    fields
    {
        field(2045750; "CMFRT GD No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2045752; "CMFRT GD Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
    }

    keys
    {
        key(PK; "CMFRT GD No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        POILine: Record "CMFRT GD POI Line";
        POILog: Record "CMFRT GD POI Log";
    begin
        // Filtered on the child's primary-key prefix, so the delete is
        // index-supported. DeleteAll(true) runs each line's own OnDelete, which is
        // what cascades to the comments hanging off the lines.
        POILine.SetRange("CMFRT GD Document No.", Rec."CMFRT GD No.");
        POILine.DeleteAll(true);

        // The log table is keyed on the header too. Cascading to the lines alone
        // would leave these rows orphaned.
        POILog.SetRange("CMFRT GD Document No.", Rec."CMFRT GD No.");
        POILog.DeleteAll(true);
    end;
}

// The child cascades downward in turn — and never back up to the header.
table 2045751 "CMFRT GD POI Line"
{
    Caption = 'POI Line';
    DataClassification = CustomerContent;

    fields
    {
        field(2045750; "CMFRT GD Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "CMFRT GD POI Header"."CMFRT GD No.";
        }
        field(2045751; "CMFRT GD Line No."; Integer)
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
        POIComment: Record "CMFRT GD POI Comment";
    begin
        POIComment.SetRange("CMFRT GD Document No.", Rec."CMFRT GD Document No.");
        POIComment.SetRange("CMFRT GD Line No.", Rec."CMFRT GD Line No.");
        POIComment.DeleteAll(true);
    end;
}

// A base-application parent cannot be given an OnDelete trigger, so the cascade
// for extension-owned children hangs off its delete event instead.
codeunit 2045752 "CMFRT GD POI Cleanup"
{
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteEvent', '', false, false)]
    local procedure CMFRTGDDeleteCustomerPOIData(var Rec: Record Customer; RunTrigger: Boolean)
    var
        POIHeader: Record "CMFRT GD POI Header";
    begin
        // A temporary buffer must never trigger a live delete.
        if Rec.IsTemporary() then
            exit;

        // Note the RunTrigger parameter is deliberately not checked: the extension's
        // own rows are cleaned up either way, because an orphan is worse than an
        // unexpected cleanup.
        POIHeader.SetRange("CMFRT GD Customer No.", Rec."No.");
        POIHeader.DeleteAll(true);
    end;
}
