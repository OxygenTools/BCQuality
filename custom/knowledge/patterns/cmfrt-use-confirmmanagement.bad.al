codeunit 2045750 "CMFRT GD Deletion Handler"
{
    procedure CMFRTGDDeletePOI(POICode: Code[20])
    var
        CMFRTGDPOI: Record "CMFRT GD POI";
    begin
        // Confirm built-in blocks test automation — automated tests hang here.
        if not Confirm('Delete POI %1?', false, POICode) then
            exit;

        if CMFRTGDPOI.Get(POICode) then
            CMFRTGDPOI.Delete(true);
    end;
}
