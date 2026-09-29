// The codeunit that modifies the standard table declares the grant itself,
// indirect and limited to the operations its body performs.
codeunit 2045300 "CMFRT RS Reserve Mgt."
{
    Permissions = tabledata "Reservation Entry" = rimd;

    procedure CancelReservation(ItemNo: Code[20])
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.DeleteAll(true);
    end;
}

// The app's permission sets list only the app's own objects and tables.
permissionset 2045301 "CMFRT RS Edit"
{
    Assignable = true;
    Caption = 'CMFRT RS Reservations - Edit';
    IncludedPermissionSets = "CMFRT RS Read";
    Permissions =
        tabledata "CMFRT RS Reserve Setup" = IMD;
}
