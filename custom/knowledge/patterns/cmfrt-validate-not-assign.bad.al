codeunit 55029 "CMFRT AQ FS Job Creator"
{
    local procedure CMFRTAQFillJobFromBuffer(var WorkOrderBuffer: Record "CMFRT AQ FS WO Buffer"; var Job: Record Job)
    begin
        Job.Init();
        Job."No." := WorkOrderBuffer."CMFRT AQ No.";
        // Direct assignment skips OnValidate: dependent fields stay empty,
        // posting-group checks and field subscribers never run.
        Job.Description := WorkOrderBuffer."CMFRT AQ Description";
        Job."Sell-to Customer No." := WorkOrderBuffer."CMFRT AQ Sell-to Customer No.";
        Job."Ship-to Address" := WorkOrderBuffer."CMFRT AQ Ship-to Address";
        Job."Location Code" := WorkOrderBuffer."CMFRT AQ Location Code";
    end;
}
