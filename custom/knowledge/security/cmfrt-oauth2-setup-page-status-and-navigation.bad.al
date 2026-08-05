// The credential fields were removed, but nothing replaced them: the page is silent
// about the OAuth2 configuration, and the stored flag goes stale.
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
        // Persisted answer to a question the central configuration owns.
        // Set once at registration; still true after the configuration is deleted.
        field(2045200; "CMFRT CC OAuth2 Configured"; Boolean)
        {
            Caption = 'OAuth2 Configured';
            DataClassification = CustomerContent;
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

page 2045129 "CMFRT CC Azure App Setup"
{
    PageType = Card;
    SourceTable = "CMFRT CC Azure App Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("CMFRT CC Connection")
            {
                Caption = 'Connection';

                field("CMFRT CC OAuth2 Configured"; Rec."CMFRT CC OAuth2 Configured")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether OAuth2 has been configured.';
                }
                field("CMFRT CC Destination Path"; Rec."CMFRT CC Destination Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination path for generated files.';
                }
            }
        }
    }

    // No navigation action either: the user has to find the configuration in the list themselves.
}
