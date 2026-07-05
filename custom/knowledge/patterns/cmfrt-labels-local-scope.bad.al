codeunit 55026 "CMFRT AQ ServiceWarehouseMeth"
{
    var
        // Global labels: shared between unrelated procedures, outlive their
        // callers as dead text, and %1/%2 are undocumented for translators.
        CreateTransferOrdersQst: Label 'Create 2 transfer orders for job %1?';
        TransferOrdersCreatedMsg: Label 'Transfer orders %1 and %2 created.';

    local procedure DoCMFRTAQMakeTransferOrders(var Job: Record Job)
    var
        ConfirmMgt: Codeunit "Confirm Management";
    begin
        if not ConfirmMgt.GetResponseOrDefault(StrSubstNo(CreateTransferOrdersQst, Job."No."), true) then
            exit;
        // ... create orders ...
        Message(TransferOrdersCreatedMsg, 'T-001', 'T-002');
    end;
}
