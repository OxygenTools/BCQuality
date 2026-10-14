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
            Caption = 'CMFRT GD POI ID';
        }
    }
}

// Procedures use CMFRT<ABBR><ProcedureName> — concatenated, no spaces.
codeunit 2045700 "CMFRT GD Job Mgmt"
{
    procedure CMFRTGDLinkJobToPOI(JobNo: Code[20]; POIId: Guid)
    begin
        // Body left out: this sample shows the declaration only.
    end;

    local procedure CMFRTGDValidatePOIExists(POIId: Guid): Boolean
    begin
        // Body left out: this sample shows the declaration only.
    end;
}

// The test app follows the same rule — test, handler, and helper procedures all carry the prefix.
codeunit 2045750 "CMFRT GD Job Mgmt Tests"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('CMFRTGDHandlePOIConfirm')]
    procedure CMFRTGDLinkJobToPOISetsPOIId()
    begin
        // Body left out: this sample shows the declaration only.
    end;

    [ConfirmHandler]
    procedure CMFRTGDHandlePOIConfirm(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    local procedure CMFRTGDCreateJobWithPOI(var Job: Record Job)
    begin
        // Body left out: this sample shows the declaration only.
    end;
}
