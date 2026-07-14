codeunit 55026 "CMFRT AQ ServiceWarehouseMeth"
{
    local procedure DoCMFRTAQMakeTransferOrders(var Job: Record Job)
    var
        ConfirmMgt: Codeunit "Confirm Management";
        CreateTransferOrdersQst: Label 'Create 2 transfer orders for job %1?', Comment = '%1 = Job No.';
        TransferOrdersCreatedMsg: Label 'Transfer orders %1 and %2 created.', Comment = '%1 = Transfer Order No. 1, %2 = Transfer Order No. 2';
    begin
        if not ConfirmMgt.GetResponseOrDefault(StrSubstNo(CreateTransferOrdersQst, Job."No."), true) then
            exit;
        // ... create orders ...
        Message(TransferOrdersCreatedMsg, 'T-001', 'T-002');
    end;
}
