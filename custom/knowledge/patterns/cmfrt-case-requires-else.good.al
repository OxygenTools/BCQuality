codeunit 2045760 "CMFRT GD Status Processor"
{
    procedure CMFRTGDProcessByStatus(Status: Enum "CMFRT GD POI Status")
    begin
        case Status of
            Status::Active:
                CMFRTGDActivatePOI();
            Status::Inactive:
                CMFRTGDDeactivatePOI();
            Status::Pending:
                CMFRTGDQueuePOIForReview();
            Status::Archived:
                exit; // An archived POI is read-only and needs no action.
            else
                // New enum values added in the future are caught here
                // instead of silently doing nothing.
                Error('Unhandled POI status: %1', Status);
        end;
    end;
}
