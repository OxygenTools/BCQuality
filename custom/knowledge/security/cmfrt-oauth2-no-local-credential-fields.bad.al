// The Azure app registration is duplicated into the extension's own setup table.
table 2045129 "CMFRT CC Azure App Setup"
{
    Caption = 'CMFRT CC Azure App Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(2045100; "CMFRT CC Client ID"; Text[250])
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }
        // A secret in a table field: readable in the database, in exports and in RapidStart packages.
        field(2045110; "CMFRT CC Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
        }
        field(2045120; "CMFRT CC Tenant ID"; Text[250])
        {
            Caption = 'Tenant ID';
            DataClassification = CustomerContent;
        }
        field(2045130; "CMFRT CC Unique Code"; Code[20])
        {
            Caption = 'Unique Code';
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
            group("CMFRT CC Azure")
            {
                Caption = 'Azure';

                field("CMFRT CC Client ID"; Rec."CMFRT CC Client ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the client ID of the Azure app registration.';
                }
                // Masked hides the value on screen only — it is still plain text in the record.
                field("CMFRT CC Client Secret"; Rec."CMFRT CC Client Secret")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the client secret of the Azure app registration.';
                    ExtendedDatatype = Masked;
                }
                field("CMFRT CC Tenant ID"; Rec."CMFRT CC Tenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tenant ID of the Azure app registration.';
                }
            }
        }
    }
}
