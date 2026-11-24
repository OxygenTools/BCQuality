table 55052 "CMFRT AQ App Item"
{
    fields
    {
        field(55052; "CMFRT AQ Item No."; Code[20])
        {
            Caption = 'CMFRT AQ Item No.';
        }
        field(55053; "CMFRT AQ Document"; Blob)
        {
            Caption = 'CMFRT AQ Document';
        }
    }
}

query 55052 "CMFRT AQ App Item"
{
    QueryType = API;
    APIPublisher = 'cmfrt';
    APIGroup = 'aquaSecurity';
    APIVersion = 'v1.0';
    EntityName = 'appItem';
    EntitySetName = 'appItems';

    elements
    {
        dataitem(AppItem; "CMFRT AQ App Item")
        {
            // No BLOB column. The BLOB is read in a separate step.
            column(itemNo; "CMFRT AQ Item No.") { }
        }
    }
}

codeunit 55052 "CMFRT AQ Read Document"
{
    procedure CMFRTAQReadDocument(ItemNo: Code[20]) DocumentText: Text
    var
        AppItem: Record "CMFRT AQ App Item";
        DocumentInStream: InStream;
    begin
        AppItem.Get(ItemNo);
        AppItem.CalcFields("CMFRT AQ Document");
        AppItem."CMFRT AQ Document".CreateInStream(DocumentInStream, TextEncoding::UTF8);
        DocumentInStream.ReadText(DocumentText);
    end;
}
