// The list page has a caption, a teaching tip and search terms with the
// glossary synonyms in English and Dutch. The FactBox names its entity.
page 2045610 "CMFRT MS ProgressStateVersions"
{
    Caption = 'CMFRT MS Progress Statements';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CMFRT MS ProgressStateVersion";
    AboutTitle = 'About progress statements';
    AboutText = 'A progress statement claims payment from the client for the work done in a period. Each period can have several versions. Only an approved version can be invoiced.';
    AdditionalSearchTerms = 'progress statement, billing statement, payment application, progress billing, vorderingsstaat';
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
            part(VersionTotals; "CMFRT MS PSV Totals FactBox")
            {
                Caption = 'CMFRT MS Progress Statement Totals';
                SubPageLink = "CMFRT MS Job No." = field("CMFRT MS Job No.");
            }
        }
    }
}
