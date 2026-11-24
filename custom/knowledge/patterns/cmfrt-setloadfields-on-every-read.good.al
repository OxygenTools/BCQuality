codeunit 55060 "CMFRT GDI Item Cleanup"
{
    local procedure DoCMFRTGDIIsItemBlocked(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        // The code reads one field, so the read loads only that field.
        Item.SetLoadFields(Blocked);
        if Item.Get(ItemNo) then
            exit(Item.Blocked);
    end;

    local procedure DoCMFRTGDIDeleteBlockedItems()
    var
        Item: Record Item;
    begin
        // Delete needs every field. The read loads the full record once.
        Item.SetRange(Blocked, true);
        if Item.FindSet() then
            repeat
                Item.Delete(true);
            until Item.Next() = 0;
    end;
}
