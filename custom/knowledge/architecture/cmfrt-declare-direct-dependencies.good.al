// app.json of the app, "dependencies" (excerpt):
//   { "id": "80ee167a-4366-47c9-9de4-bf4ebe5ff52d", "name": "CMFRT Calc", "publisher": "Astena", "version": "1.0.0.0" },
//   { "id": "9c86d936-e2ee-46d3-86a1-9b7b99b728bf", "name": "CMFRT Job", "publisher": "Astena", "version": "1.0.0.0" }
// CMFRT Job defines "CMFRT JO Comfort Job Setup", so the app declares CMFRT Job
// directly. The change that adds this table extension also adds that entry.
tableextension 55010 "CMFRT GDW Job Setup" extends "CMFRT JO Comfort Job Setup"
{
    fields
    {
        field(55000; "CMFRT GDW Min. Margin Pct."; Decimal)
        {
            Caption = 'CMFRT GDW Minimum Margin Pct.';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
        }
    }
}
