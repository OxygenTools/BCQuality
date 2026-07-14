// Objects use "CMFRT <ABBR> <Name>" with spaces.
pageextension 2045661 "CMFRT GD Job" extends "Job Card"
{
}

// Fields use "CMFRT <ABBR> <FieldName>" with spaces.
tableextension 2045660 "CMFRT GD Job Ext" extends Job
{
    fields
    {
        field(2045081; "CMFRT GD POI ID"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'POI ID';
        }
    }
}

// Procedures use CMFRT<ABBR><ProcedureName> — concatenated, no spaces.
codeunit 2045700 "CMFRT GD Job Mgmt"
{
    procedure CMFRTGDLinkJobToPOI(JobNo: Code[20]; POIId: Guid)
    begin
    end;

    local procedure CMFRTGDValidatePOIExists(POIId: Guid): Boolean
    begin
    end;
}
