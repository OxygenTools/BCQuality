// Step 1: Objects set — owns all AL objects with execute access.
permissionset 2045222 "CMFRT GD Objects"
{
    Assignable = true;
    Caption = 'CMFRT GD Geodynamics - Objects';
    Permissions =
        table "CMFRT GD POI" = X,
        table "CMFRT GD Setup" = X,
        page "CMFRT GD POI" = X,
        page "CMFRT GD Setup" = X,
        codeunit "CMFRT GD IGeodynamics" = X,
        codeunit "CMFRT GD IGeodynamics Impl" = X;
}

// Step 2: Read set — inherits object access, adds tabledata read.
permissionset 2045221 "CMFRT GD Read"
{
    Assignable = true;
    Caption = 'CMFRT GD Geodynamics - Read';
    IncludedPermissionSets = "CMFRT GD Objects";
    Permissions =
        tabledata "CMFRT GD POI" = R,
        tabledata "CMFRT GD Setup" = R;
}

// Step 3: Edit set — inherits Read, adds insert/modify/delete.
permissionset 2045226 "CMFRT GD Edit"
{
    Assignable = true;
    Caption = 'CMFRT GD Geodynamics - Edit';
    IncludedPermissionSets = "CMFRT GD Read";
    Permissions =
        tabledata "CMFRT GD POI" = IMD,
        tabledata "CMFRT GD Setup" = IMD;
}
