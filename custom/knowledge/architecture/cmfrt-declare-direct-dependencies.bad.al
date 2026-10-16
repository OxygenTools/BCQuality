// app.json of the app, "dependencies" (excerpt). CMFRT Job is missing:
//   { "id": "67231ede-eb64-4240-92b0-e77d0364ea05", "name": "CMFRT Base", "publisher": "Astena", "version": "1.0.0.0" },
//   { "id": "80ee167a-4366-47c9-9de4-bf4ebe5ff52d", "name": "CMFRT Calc", "publisher": "Astena", "version": "1.0.0.0" },
//   { "id": "778f19d8-422a-492b-9b51-3e3f4e046bd7", "name": "CMFRT Service", "publisher": "Astena", "version": "1.0.0.0" }
// The table extension compiles only because CMFRT Calc and CMFRT Service declare
// CMFRT Job and set "propagateDependencies": true. If both apps drop it, this app
// stops building without a change of its own.
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
