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

                // Computed, never stored: the answer lives in the central configuration.
                field(CMFRTCCOAuth2Configured; CMFRTCCOAuth2Configured)
                {
                    ApplicationArea = All;
                    Caption = 'OAuth2 Configured';
                    ToolTip = 'Specifies whether a central OAuth2 configuration exists for this extension.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("CMFRT CC Open OAuth2 Setup")
            {
                ApplicationArea = All;
                Caption = 'OAuth2 Configuration';
                ToolTip = 'Open the central OAuth2 configuration for this extension.';
                Image = Setup;
                RunObject = page "CMFRT SY OAuth2 Config List";
                RunPageLink = "CMFRT SY Code" = const("CMFRT CC Azure App Setup");
            }
        }
    }

    var
        CMFRTCCOAuth2Configured: Boolean;

    trigger OnOpenPage()
    begin
        CMFRTCCUpdateOAuth2Status();
    end;

    trigger OnAfterGetRecord()
    begin
        CMFRTCCUpdateOAuth2Status();
    end;

    local procedure CMFRTCCUpdateOAuth2Status()
    var
        OAuth2TokenMeth: Codeunit "CMFRT SY OAuth2 Token Meth";
    begin
        CMFRTCCOAuth2Configured :=
            OAuth2TokenMeth.CMFRTSYConfigExists(
                Enum::"CMFRT SY OAuth2 Action"::"CMFRT CC Azure App Setup");
    end;
}
