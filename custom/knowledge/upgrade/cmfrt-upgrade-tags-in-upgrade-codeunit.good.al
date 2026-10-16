// One upgrade codeunit holds the trigger, the tag getter, the guarded step and the tag subscriber.
codeunit 55003 "CMFRT EX Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        CMFRTEXMoveRegionCode();
    end;

    internal procedure CMFRTEXGetMoveRegionCodeTag(): Code[250]
    begin
        exit('CMFRT-EX-P26000-1-MoveRegionCode-20261016');
    end;

    local procedure CMFRTEXMoveRegionCode()
    var
        Customer: Record Customer;
        UpgradeTag: Codeunit "Upgrade Tag";
        CustomerDataTransfer: DataTransfer;
    begin
        if UpgradeTag.HasUpgradeTag(CMFRTEXGetMoveRegionCodeTag()) then
            exit;

        CustomerDataTransfer.SetTables(Database::Customer, Database::Customer);
        CustomerDataTransfer.AddFieldValue(Customer.FieldNo("CMFRT EX Old Region"), Customer.FieldNo("CMFRT EX Region Code"));
        CustomerDataTransfer.CopyFields();

        UpgradeTag.SetUpgradeTag(CMFRTEXGetMoveRegionCodeTag());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure CMFRTEXRegisterPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(CMFRTEXGetMoveRegionCodeTag());
    end;
}
