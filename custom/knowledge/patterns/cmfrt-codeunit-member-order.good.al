codeunit 2045790 "CMFRT GD POI Management"
{
    // 1. Global procedures — the codeunit's API.
    procedure CMFRTGDActivatePOI(var POI: Record "CMFRT GD POI")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCMFRTGDActivatePOI(POI, IsHandled);
        DoCMFRTGDActivatePOI(POI, IsHandled);
        OnAfterCMFRTGDActivatePOI(POI);
    end;

    procedure CMFRTGDDeactivatePOI(var POI: Record "CMFRT GD POI")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCMFRTGDDeactivatePOI(POI, IsHandled);
        DoCMFRTGDDeactivatePOI(POI, IsHandled);
        OnAfterCMFRTGDDeactivatePOI(POI);
    end;

    // 2. Local procedures.
    local procedure DoCMFRTGDActivatePOI(var POI: Record "CMFRT GD POI"; IsHandled: Boolean)
    begin
        if IsHandled then
            exit;
        POI.Validate(Status, POI.Status::Active);
        POI.Modify(true);
    end;

    local procedure DoCMFRTGDDeactivatePOI(var POI: Record "CMFRT GD POI"; IsHandled: Boolean)
    begin
        if IsHandled then
            exit;
        POI.Validate(Status, POI.Status::Inactive);
        POI.Modify(true);
    end;

    // 3. Event publishers — always last, in the order of the procedures that raise them.
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTGDActivatePOI(var POI: Record "CMFRT GD POI"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTGDActivatePOI(var POI: Record "CMFRT GD POI")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCMFRTGDDeactivatePOI(var POI: Record "CMFRT GD POI"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCMFRTGDDeactivatePOI(var POI: Record "CMFRT GD POI")
    begin
    end;
}
