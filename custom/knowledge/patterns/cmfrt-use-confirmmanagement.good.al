codeunit 2045750 "CMFRT GD Deletion Handler"
{
    procedure CMFRTGDDeletePOI(POICode: Code[20])
    var
        CMFRTGDPOI: Record "CMFRT GD POI";
        ConfirmManagement: Codeunit "Confirm Management";
        DeleteConfirmQst: Label 'Delete POI %1?', Comment = '%1 = POI Code';
    begin
        if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(DeleteConfirmQst, POICode), false) then
            exit;

        if CMFRTGDPOI.Get(POICode) then
            CMFRTGDPOI.Delete(true);
    end;
}
