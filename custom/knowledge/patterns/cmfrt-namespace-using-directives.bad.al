// Anti-pattern: the file declares a namespace, which removes the flat global view
// of the base application, and then gets the import list wrong in four separate
// ways. Only one namespace declaration is legal per file, so the failure modes are
// shown together here rather than as separate objects.
namespace Astena.CMFRT.GD;

using Microsoft.Sales;             // invented from the functional area, not looked
                                   // up: Customer does not live in Microsoft.Sales
using Microsoft.Purchases.Vendor;  // copied from a neighbouring file — nothing in
                                   // this file references a Vendor
using Astena.CMFRT.GD;             // the file's own namespace; objects here already
                                   // resolve without it
                                   // ... and the namespace that actually holds
                                   // Type Helper is never imported at all.

codeunit 2045740 "CMFRT GD POI Sync"
{
    // Each reference below fails independently: Customer and Type Helper because
    // their namespaces are not imported, and Database::Customer because an
    // attribute argument needs the import exactly like a variable declaration does.
    procedure CMFRTGDSyncCustomer(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        TypeHelper: Codeunit "Type Helper";
    begin
        if Customer.Get(CustomerNo) then
            Message(TypeHelper.GetFieldCaption(Database::Customer, Customer.FieldNo(Name)));
    end;
}
