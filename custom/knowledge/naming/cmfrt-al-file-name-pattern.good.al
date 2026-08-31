// File name: CMFRTAMAddress.Table.al
// The declared name "CMFRT AM Address" with its spaces removed, then the
// object-type segment. No object ID, no spaces, one object in the file.
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

// File name: CMFRTAMShipToAddress.TableExt.al
// An extension object is named after itself, not after the object it extends:
// the file carries "CMFRT AM Ship-to Address" minus its spaces, not
// "ShipToAddress". The house does the same for pages — CMFRTGUJobCard.PageExt.al.
tableextension 2045090 "CMFRT AM Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(2045090; "CMFRT AM Address No."; Code[20])
        {
            Caption = 'Address No.';
            DataClassification = CustomerContent;
            TableRelation = "CMFRT AM Address"."CMFRT AM Address No.";
        }
    }
}

// File name: CMFRTAMEdit.PermissionSet.al
// The type segment is matched case-insensitively — CMFRTAMEdit.permissionset.al
// is equally accepted, and both spellings ship in the house repos.
permissionset 2045122 "CMFRT AM Edit"
{
    Assignable = true;
    Caption = 'Address Management - Edit';
    Permissions = tabledata "CMFRT AM Address" = RIMD;
}
