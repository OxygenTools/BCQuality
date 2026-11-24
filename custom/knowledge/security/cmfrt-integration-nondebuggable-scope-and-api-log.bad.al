// An integration codeunit that reads credentials and responses without NonDebuggable.
// The calls go to telemetry only, with no GenericLOG entry.
codeunit 2045835 "CMFRT DS Dioss API"
{
    // Not [NonDebuggable]: the token and the response body are readable while debugging.
    procedure CMFRTDSSendDocument(DocumentId: Text; Token: Text) ResponseText: Text
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        RequestFailedErr: Label 'The request failed with status %1.', Comment = '%1 = HTTP status code';
    begin
        RequestMessage.SetRequestUri('https://api.example.com/documents/' + DocumentId);
        RequestMessage.Method := 'GET';
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Bearer ' + Token);

        Client.Send(RequestMessage, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RequestFailedErr, ResponseMessage.HttpStatusCode());

        ResponseMessage.Content.ReadAs(ResponseText);
        // Telemetry only: no GenericLOG entry for this external call.
        Session.LogMessage('CMFRTDS001', 'Document sent', Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'CMFRT DS');
    end;
}
