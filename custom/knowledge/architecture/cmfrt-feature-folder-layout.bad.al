// Anti-pattern path: src/Table/CMFRTAMDesignation.Table.al
// The folder name equals an AL object type, so it says nothing the file's own
// .Table.al segment did not already say — and the Designation feature is now
// split across src/Table, src/Page, src/Interface and src/Codeunit.
// Correct: src/Designation/CMFRTAMDesignation.Table.al
table 2045086 "CMFRT AM Designation"
{
    Caption = 'Designation';
    DataClassification = CustomerContent;

    fields
    {
        field(2045086; "CMFRT AM Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "CMFRT AM Entry No.")
        {
            Clustered = true;
        }
    }
}

// Anti-pattern path: src/Codeunit/CMFRTAMFindOverlapImpl.Codeunit.al
// The other half of the same feature, three folders away from its table.
// Correct: src/Designation/CMFRTAMFindOverlapImpl.Codeunit.al
codeunit 2045100 "CMFRT AM FindOverlapImpl" implements "CMFRT AM FindOverlapInt"
{
    procedure CMFRTAMFindOverlap(AddressNo: Code[20]): Boolean
    begin
    end;
}

// Anti-pattern path: src/Codeunit/CMFRTAMInstall.Codeunit.al
// An install codeunit buried among the feature codeunits. The reserved folder
// exists so the app's lifecycle code is found without reading every file.
// Correct: src/02 Install/CMFRTAMInstall.Codeunit.al
codeunit 2045109 "CMFRT AM Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
    end;
}
