// Field deleted outright — any upgrade codeunit or dependent extension
// that referenced "CMFRT GD Error Path" will fail to compile.
table 2045085 "CMFRT GD Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = SystemMetadata; }
        field(2; "CMFRT GD ErrorPath"; Text[500])
        {
            Caption = 'Error Path';
            DataClassification = CustomerContent;
        }
        // "CMFRT GD Error Path" (field 2045325) was deleted here — breaking change.
    }
}
