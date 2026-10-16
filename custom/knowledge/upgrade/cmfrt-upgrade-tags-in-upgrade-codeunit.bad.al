// The tag getter and the tag subscriber sit in a second codeunit, apart from the upgrade code that uses them.
codeunit 55002 "CMFRT EX Upgrade Tags"
{
    internal procedure CMFRTEXGetMoveRegionCodeTag(): Code[250]
    begin
        exit('CMFRT-EX-P26000-1-MoveRegionCode-20261016');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure CMFRTEXRegisterPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(CMFRTEXGetMoveRegionCodeTag());
    end;
}

codeunit 55003 "CMFRT EX Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        CMFRTEXMoveRegionCode();
    end;

    local procedure CMFRTEXMoveRegionCode()
    var
        Customer: Record Customer;
        CMFRTEXUpgradeTags: Codeunit "CMFRT EX Upgrade Tags";
        UpgradeTag: Codeunit "Upgrade Tag";
        CustomerDataTransfer: DataTransfer;
    begin
        if UpgradeTag.HasUpgradeTag(CMFRTEXUpgradeTags.CMFRTEXGetMoveRegionCodeTag()) then
            exit;

        CustomerDataTransfer.SetTables(Database::Customer, Database::Customer);
        CustomerDataTransfer.AddFieldValue(Customer.FieldNo("CMFRT EX Old Region"), Customer.FieldNo("CMFRT EX Region Code"));
        CustomerDataTransfer.CopyFields();

        UpgradeTag.SetUpgradeTag(CMFRTEXUpgradeTags.CMFRTEXGetMoveRegionCodeTag());
    end;
}
