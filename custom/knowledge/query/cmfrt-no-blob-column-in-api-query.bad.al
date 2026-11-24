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
            column(itemNo; "CMFRT AQ Item No.") { }
            // A query does not run CalcFields. The API returns an empty value.
            column(document; "CMFRT AQ Document") { }
        }
    }
}
