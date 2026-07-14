codeunit 55029 "CMFRT AQ FS Job Creator"
{
    local procedure CMFRTAQFillJobFromBuffer(var WorkOrderBuffer: Record "CMFRT AQ FS WO Buffer"; var Job: Record Job)
    begin
        Job.Init();
        // Primary key: direct assignment, never Validate.
        Job."No." := WorkOrderBuffer."CMFRT AQ No.";
        // Business fields: Validate so OnValidate logic runs.
        Job.Validate(Description, WorkOrderBuffer."CMFRT AQ Description");
        Job.Validate("Sell-to Customer No.", WorkOrderBuffer."CMFRT AQ Sell-to Customer No.");
        Job.Validate("Ship-to Address", WorkOrderBuffer."CMFRT AQ Ship-to Address");
        Job.Validate("Location Code", WorkOrderBuffer."CMFRT AQ Location Code");
    end;
}
