// Anti-pattern file name: Table2045085.CMFRT AM Address.al
// The object type is written as a prefix carrying the object ID, the declared
// name follows after a dot, and its spaces are kept. The file sorts by a number
// nobody navigates by, needs quoting in every path, and goes stale on renumber.
// Correct: CMFRTAMAddress.Table.al
table 2045085 "CMFRT AM Address"
{
    Caption = 'Address';
    DataClassification = CustomerContent;

    fields
    {
        field(2045085; "CMFRT AM Address No."; Code[20])
        {
            Caption = 'Address No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "CMFRT AM Address No.")
        {
            Clustered = true;
        }
    }
}

// Anti-pattern file name: Codeunit2045109.CMFRT AM Install.al
// Same defect, and the file also belongs under src/02 Install — see
// cmfrt-feature-folder-layout. Correct: CMFRTAMInstall.Codeunit.al
codeunit 2045109 "CMFRT AM Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
    end;
}

// Anti-pattern file name: AddressLogic.al
// No type segment at all, and the object portion does not echo the declared
// name, so neither grep nor symbol search maps file to object.
// Correct: CMFRTAMAddressHelp.Codeunit.al
codeunit 2045110 "CMFRT AM Address Help"
{
    procedure CMFRTAMValidateAddress(AddressNo: Code[20]): Boolean
    begin
    end;
}
