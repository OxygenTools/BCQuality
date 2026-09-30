codeunit 2045790 "CMFRT GD POI Management"
{
    procedure CMFRTGDActivatePOI(var POI: Record "CMFRT GD POI")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCMFRTGDActivatePOI(POI, IsHandled);
        DoCMFRTGDActivatePOI(POI, IsHandled);
        OnAfterCMFRTGDActivatePOI(POI);
    end;

    // Publishers and the local body declared in the middle, next to their caller:
    // the next global procedure is now buried below them.
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTGDActivatePOI(var POI: Record "CMFRT GD POI"; var IsHandled: Boolean)
    begin
    end;

    local procedure DoCMFRTGDActivatePOI(var POI: Record "CMFRT GD POI"; IsHandled: Boolean)
    begin
        if IsHandled then
            exit;
        POI.Validate(Status, POI.Status::Active);
        POI.Modify(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTGDActivatePOI(var POI: Record "CMFRT GD POI")
    begin
    end;

    // A global procedure after publishers and locals splits the API group in two.
    // (Its OnBefore/OnAfter triple is omitted to keep the sample on the ordering defect.)
    procedure CMFRTGDDeactivatePOI(var POI: Record "CMFRT GD POI")
    begin
        POI.Validate(Status, POI.Status::Inactive);
        POI.Modify(true);
    end;
}
