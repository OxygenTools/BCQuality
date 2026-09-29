// The codeunit declares nothing; the standard-table grant was pushed into
// the permission set instead.
codeunit 2045300 "CMFRT RS Reserve Mgt."
{
    procedure CancelReservation(ItemNo: Code[20])
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.DeleteAll(true);
    end;
}

// Every holder of this set can now read and delete reservation entries
// directly, not only through the CMFRT code.
permissionset 2045301 "CMFRT RS Edit"
{
    Assignable = true;
    Caption = 'CMFRT RS Reservations - Edit';
    IncludedPermissionSets = "CMFRT RS Read";
    Permissions =
        tabledata "CMFRT RS Reserve Setup" = IMD,
        tabledata "Reservation Entry" = RIMD;
}
