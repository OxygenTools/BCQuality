// The namespace declaration is the first statement; the using directives follow
// immediately, before the object declaration, one per imported namespace.
//
// Each namespace below was read from the symbol packages this app compiles
// against — not inferred from the object's functional area. Verify them for the
// BC version in app.json: the base application was namespaced in BC24 and its
// layout is refined between releases, so an import that is correct on one
// version can be wrong on another.
namespace Astena.CMFRT.GD;

using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;
using System.Utilities;

codeunit 2045741 "CMFRT GD POI Sync"
{
    // Both the variable declarations and the Database::Customer attribute-style
    // reference resolve, because Microsoft.Sales.Customer is imported once for the
    // whole file.
    procedure CMFRTGDSyncCustomer(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        TypeHelper: Codeunit "Type Helper";
    begin
        if Customer.Get(CustomerNo) then
            Message(TypeHelper.GetFieldCaption(Database::Customer, Customer.FieldNo(Name)));
    end;

    // Item is referenced only here, which is what justifies the
    // Microsoft.Inventory.Item directive — every import ties to a reference.
    procedure CMFRTGDItemExists(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        exit(Item.Get(ItemNo));
    end;

    // CMFRT GD POI Entry needs no directive: it lives in this file's own
    // namespace, Astena.CMFRT.GD.
    procedure CMFRTGDCountEntries(): Integer
    var
        POIEntry: Record "CMFRT GD POI Entry";
    begin
        exit(POIEntry.Count());
    end;
}
