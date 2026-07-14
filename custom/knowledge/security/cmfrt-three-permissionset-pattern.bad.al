// Only one flat permission set — no composition, no read-only role.
// Adding a new table means updating this one set and hoping nothing was missed.
permissionset 2045222 "CMFRT GD Geodynamics"
{
    Assignable = true;
    Caption = 'CMFRT GD Geodynamics';
    Permissions =
        table "CMFRT GD POI" = X,
        tabledata "CMFRT GD POI" = RIMD,
        table "CMFRT GD Setup" = X,
        tabledata "CMFRT GD Setup" = RIMD,
        page "CMFRT GD POI" = X,
        page "CMFRT GD Setup" = X,
        codeunit "CMFRT GD IGeodynamics" = X,
        codeunit "CMFRT GD IGeodynamics Impl" = X;
}
