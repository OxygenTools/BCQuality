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
