// Two try methods. The first keeps a half-written service line when Modify fails after
// the Validate calls. The second turns every HTTP and JSON failure into the same false.
codeunit 55020 "CMFRT LAN Service Order Mgmt"
{
    procedure CMFRTLANCopyQtyToConsume(var ServiceLine: Record "Service Line")
    var
        CopyQtyErr: Label 'Line %1 could not be updated: %2', Comment = '%1 = Line No., %2 = error text';
    begin
        if ServiceLine.FindSet(true) then
            repeat
                if not CMFRTLANTryCopyQtyToConsume(ServiceLine) then
                    Error(CopyQtyErr, ServiceLine."Line No.", GetLastErrorText());
            until ServiceLine.Next() = 0;
    end;

    [TryFunction]
    local procedure CMFRTLANTryCopyQtyToConsume(var ServiceLine: Record "Service Line")
    begin
        ServiceLine.Validate("Qty. to Consume", ServiceLine."Qty. to Invoice");
        ServiceLine.Validate("Qty. to Invoice", 0);
        ServiceLine.Modify(true);
    end;

    [TryFunction]
    local procedure CMFRTLANTryReadColumnName(Url: Text; var ColumnName: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Body: Text;
        Json: JsonObject;
        Token: JsonToken;
    begin
        Client.Get(Url, Response);
        Response.Content.ReadAs(Body);
        Json.ReadFrom(Body);
        Json.Get('displayName', Token);
        ColumnName := Token.AsValue().AsText();
    end;
}
