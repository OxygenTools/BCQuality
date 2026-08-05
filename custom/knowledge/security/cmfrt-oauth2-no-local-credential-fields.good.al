// The extension's setup table holds only its own settings.
// Client ID, Client Secret and Tenant ID live in the central OAuth2 configuration.
table 2045129 "CMFRT CC Azure App Setup"
{
    Caption = 'CMFRT CC Azure App Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(2045130; "CMFRT CC Unique Code"; Code[20])
        {
            Caption = 'Unique Code';
            DataClassification = CustomerContent;
        }
        field(2045140; "CMFRT CC Destination Path"; Text[250])
        {
            Caption = 'Destination Path';
            DataClassification = CustomerContent;
        }
        field(2045180; "CMFRT CC API"; Text[250])
        {
            Caption = 'API';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // Migrated away: obsoleted rather than deleted, and no longer shown on the page.
        field(2045100; "CMFRT CC Client ID"; Text[250])
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Moved to the central OAuth2 configuration in CMFRT System.';
            ObsoleteTag = '26.0';
        }
        field(2045110; "CMFRT CC Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Secrets are retrieved from the Astena Key Vault, never stored.';
            ObsoleteTag = '26.0';
        }
        field(2045120; "CMFRT CC Tenant ID"; Text[250])
        {
            Caption = 'Tenant ID';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Moved to the central OAuth2 configuration in CMFRT System.';
            ObsoleteTag = '26.0';
        }
    }

    keys
    {
        key(PK; "CMFRT CC Unique Code")
        {
            Clustered = true;
        }
    }
}
