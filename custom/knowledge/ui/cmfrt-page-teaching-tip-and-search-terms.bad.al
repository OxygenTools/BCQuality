// The page is searchable but has no teaching tip and no search terms.
// A user who searches for "vorderingsstaat" or "progress statement" does not find it.
page 2045610 "CMFRT MS ProgressStateVersions"
{
    Caption = 'CMFRT MS ProgressStateVersions';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CMFRT MS ProgressStateVersion";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("CMFRT MS Job No."; Rec."CMFRT MS Job No.") { }
                field("CMFRT MS Status"; Rec."CMFRT MS Status") { }
            }
        }
        area(FactBoxes)
        {
            // No caption: the FactBox shows the object name.
            part(VersionTotals; "CMFRT MS PSV Totals FactBox")
            {
                SubPageLink = "CMFRT MS Job No." = field("CMFRT MS Job No.");
            }
        }
    }
}
