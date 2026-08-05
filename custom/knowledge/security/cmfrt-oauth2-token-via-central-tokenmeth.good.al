// Step 1 — one value per extension and purpose, added to the enum in the CMFRT System app
// (the enum is Extensible = false, so this is not an enumextension in the consuming app).
enum 2046088 "CMFRT SY OAuth2 Action"
{
    Extensible = false;

    value(2045000; "CMFRT CC Azure App Setup")
    {
        Caption = 'CMFRT CC Azure App Setup';
    }
}

// Step 2 — ask the central codeunit for a token and use it as a bearer token.
codeunit 2045131 "CMFRT CC Graph Help"
{
    [NonDebuggable]
    procedure CMFRTCCGetDriveItem(ItemPath: Text) ResponseText: Text
    var
        OAuth2TokenMeth: Codeunit "CMFRT SY OAuth2 Token Meth";
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        AccessToken: Text;
        NoTokenErr: Label 'No access token could be retrieved for the %1 OAuth2 configuration.', Comment = '%1 = OAuth2 action code';
        RequestFailedErr: Label 'The request to Microsoft Graph failed with status %1.', Comment = '%1 = HTTP status code';
    begin
        // The return value reports success; the token comes back in the var parameter.
        if not OAuth2TokenMeth.CMFRTSYGetAccessToken(
            Enum::"CMFRT SY OAuth2 Action"::"CMFRT CC Azure App Setup", AccessToken)
        then
            Error(NoTokenErr, Enum::"CMFRT SY OAuth2 Action"::"CMFRT CC Azure App Setup");

        RequestMessage.SetRequestUri(ItemPath);
        RequestMessage.Method := 'GET';
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error(RequestFailedErr, 0);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RequestFailedErr, ResponseMessage.HttpStatusCode());

        ResponseMessage.Content.ReadAs(ResponseText);
        // The token is not stored anywhere; it goes out of scope with this call.
    end;
}
