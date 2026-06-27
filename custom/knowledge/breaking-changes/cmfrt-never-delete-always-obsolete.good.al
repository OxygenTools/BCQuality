// Obsoleted field kept at the end of the table — never deleted.
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

        // Obsolete section at the end — original field retained with state = Removed.
        field(2045325; "CMFRT GD Error Path"; Text[200])
        {
            Caption = 'Error Path (Obsolete)';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced by field "CMFRT GD ErrorPath" with extended length.';
            ObsoleteTag = 'Task-29100';
        }
    }
}
