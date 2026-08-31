// File: CMFRTAMFindOverlapInt.Interface.al
// The suffix is glued to the descriptive part: "FindOverlapInt" is 14 of the
// 21-character descriptive budget, 23 in total with the 9-character prefix.
interface "CMFRT AM FindOverlapInt"
{
    procedure CMFRTAMFindOverlap(AddressNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
}

// File: CMFRTAMFindOverlapImpl.Codeunit.al
// The matching implementation: same descriptive part, Impl instead of Int, so
// the pair sorts adjacently and either name names the other.
codeunit 2045100 "CMFRT AM FindOverlapImpl" implements "CMFRT AM FindOverlapInt"
{
    procedure CMFRTAMFindOverlap(AddressNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        CMFRTAMOccupancy: Record "CMFRT AM Occupancy";
    begin
        CMFRTAMOccupancy.SetRange("CMFRT AM Address No.", AddressNo);
        CMFRTAMOccupancy.SetFilter("CMFRT AM From Date", '<=%1', ToDate);
        CMFRTAMOccupancy.SetFilter("CMFRT AM To Date", '>=%1', FromDate);
        exit(not CMFRTAMOccupancy.IsEmpty());
    end;
}

// The seam in use: the interface variable is typed by the Int name and assigned
// the Impl codeunit, which is where the suffix pair earns its keep — a caller
// reading this line knows immediately which name is the contract.
codeunit 2045101 "CMFRT AM OccupancyHelp"
{
    procedure CMFRTAMCheckOverlap(AddressNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        CMFRTAMFindOverlapImpl: Codeunit "CMFRT AM FindOverlapImpl";
        CMFRTAMFindOverlapInt: Interface "CMFRT AM FindOverlapInt";
    begin
        CMFRTAMFindOverlapInt := CMFRTAMFindOverlapImpl;
        exit(CMFRTAMFindOverlapInt.CMFRTAMFindOverlap(AddressNo, FromDate, ToDate));
    end;
}
