// The writes run in one worker codeunit behind a single Codeunit.Run: all lines change, or
// none do, and no Commit is needed. The HTTP and JSON reads check each return value, so the
// caller knows which step failed.
codeunit 55021 "CMFRT LAN Copy Qty To Consume"
{
    TableNo = "Service Line";

    trigger OnRun()
    begin
        if Rec.FindSet(true) then
            repeat
                Rec.Validate("Qty. to Consume", Rec."Qty. to Invoice");
                Rec.Validate("Qty. to Invoice", 0);
                Rec.Modify(true);
            until Rec.Next() = 0;
    end;
}

codeunit 55020 "CMFRT LAN Service Order Mgmt"
{
    procedure CMFRTLANCopyQtyToConsume(var ServiceLine: Record "Service Line")
    var
        CMFRTLANCopyQtyToConsume: Codeunit "CMFRT LAN Copy Qty To Consume";
        CopyQtyErr: Label 'The service lines could not be updated: %1', Comment = '%1 = error text';
    begin
        if not CMFRTLANCopyQtyToConsume.Run(ServiceLine) then
            Error(CopyQtyErr, GetLastErrorText());
    end;

    procedure CMFRTLANReadColumnName(Url: Text; var ColumnName: Text): Boolean
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Body: Text;
        Json: JsonObject;
        Token: JsonToken;
    begin
        if not Client.Get(Url, Response) then
            exit(false);
        if not Response.IsSuccessStatusCode() then
            exit(false);
        Response.Content.ReadAs(Body);
        if not Json.ReadFrom(Body) then
            exit(false);
        if not Json.Get('displayName', Token) then
            exit(false);
        if not Token.IsValue() then
            exit(false);
        ColumnName := Token.AsValue().AsText();
        exit(true);
    end;
}
