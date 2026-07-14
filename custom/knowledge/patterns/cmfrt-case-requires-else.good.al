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
            else
                // New enum values added in the future are caught here
                // instead of silently doing nothing.
                Error('Unhandled POI status: %1', Status);
        end;
    end;
}
