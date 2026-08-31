// Path: src/Designation/CMFRTAMDesignation.Table.al
// The Designation feature owns a folder. Its table, its pages, its interface and
// its implementation codeunit sit together, so the whole concern is one folder.
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

// Path: src/Designation/CMFRTAMFindOverlapImpl.Codeunit.al
// Same feature, different object type — same folder. Nothing about this file's
// location repeats what its own .Codeunit.al segment already states.
codeunit 2045100 "CMFRT AM FindOverlapImpl" implements "CMFRT AM FindOverlapInt"
{
    procedure CMFRTAMFindOverlap(AddressNo: Code[20]): Boolean
    begin
    end;
}

// Path: src/02 Install/CMFRTAMInstall.Codeunit.al
// The reserved lifecycle folder. "02 Install" and "05 Upgrade" are fixed names,
// numbered so they sort above the feature folders.
codeunit 2045109 "CMFRT AM Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
    end;
}
