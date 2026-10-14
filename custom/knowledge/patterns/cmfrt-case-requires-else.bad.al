codeunit 2045760 "CMFRT GD Status Processor"
{
    procedure CMFRTGDProcessByStatus(Status: Enum "CMFRT GD POI Status")
    begin
        // No else clause — a future enum value silently falls through
        // with no error and no action, producing a silent no-op.
        // The Archived branch is empty, so the reader cannot tell if a statement is missing.
        case Status of
            Status::Active:
                CMFRTGDActivatePOI();
            Status::Inactive:
                CMFRTGDDeactivatePOI();
            Status::Pending:
                CMFRTGDQueuePOIForReview();
            Status::Archived:
                ;
        end;
    end;
}
