// A hand-rolled token request, with the secret read straight from the setup table.
codeunit 2045131 "CMFRT CC Graph Help"
{
    var
        AzureApp: Record "CMFRT CC Azure App Setup";

    // Not [NonDebuggable]: both the secret and the token are readable while debugging.
    procedure CMFRTCCGetTokenFromMGraph(): Text
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        ContentHeaders: HttpHeaders;
        Uri: Codeunit Uri;
        JsonResponse: JsonObject;
        OAuthToken: JsonToken;
        RequestBody: Text;
        ResponseText: Text;
        URL: Text;
        NoSetupErr: Label 'Azure App Setup not found.';
    begin
        if not AzureApp.Get() then
            Error(NoSetupErr);

        // Duplicates centrally maintained logic, and targets the v1 endpoint with 'resource='.
        RequestBody :=
            'resource=https://graph.microsoft.com' +
            '&grant_type=client_credentials' +
            '&client_id=' + Uri.EscapeDataString(AzureApp."CMFRT CC Client ID") +
            '&client_secret=' + Uri.EscapeDataString(AzureApp."CMFRT CC Client Secret") +
            '&scope=https://graph.microsoft.com/.default';

        URL := 'https://login.microsoftonline.com/' + AzureApp."CMFRT CC Tenant ID" + '/oauth2/token';

        RequestMessage.SetRequestUri(URL);
        RequestMessage.Method := 'POST';
        RequestMessage.Content.WriteFrom(RequestBody);
        RequestMessage.Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // No extension-ownership check: any extension that can read the table can mint a token.
        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content.ReadAs(ResponseText);
        JsonResponse.ReadFrom(ResponseText);
        JsonResponse.Get('access_token', OAuthToken);
        exit(OAuthToken.AsValue().AsText());
    end;
}
