// Object names without the CMFRT prefix collide with other extensions.
pageextension 2045661 "Job Card Extension" extends "Job Card"
{
}

// Unprefixed fields are indistinguishable from base application fields.
tableextension 2045660 "Job Extension" extends Job
{
    fields
    {
        field(2045081; "POI ID"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'POI ID';
        }
    }
}

// Unprefixed procedures have no ownership signal for reviewers.
codeunit 2045700 "Job Management"
{
    procedure LinkJobToPOI(JobNo: Code[20]; POIId: Guid)
    begin
    end;

    local procedure ValidatePOIExists(POIId: Guid): Boolean
    begin
    end;
}

// The test app is not exempt — unprefixed test, handler, and helper procedures are the same violation.
codeunit 2045750 "Job Mgmt Tests"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandlePOIConfirm')]
    procedure LinkJobToPOI()
    begin
    end;

    [ConfirmHandler]
    procedure HandlePOIConfirm(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    local procedure CreateJobWithPOI(var Job: Record Job)
    begin
    end;
}
