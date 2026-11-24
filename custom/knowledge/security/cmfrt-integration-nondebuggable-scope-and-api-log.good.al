// Only the procedures that handle credentials, tokens or responses are NonDebuggable.
codeunit 2045835 "CMFRT DS Dioss API"
{
    [NonDebuggable]
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
        // Write the call to GenericLOG here. Use the public procedures of CMFRT_GenericLOG.
    end;

    // No credential, token or response: this procedure stays debuggable.
    procedure CMFRTDSBuildDocumentUri(DocumentId: Text): Text
    begin
        exit('https://api.example.com/documents/' + DocumentId);
    end;
}
