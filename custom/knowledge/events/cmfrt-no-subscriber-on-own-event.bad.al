codeunit 55060 "CMFRT GDW Line Sync Meth"
{
    procedure CMFRTGDWSyncLines(DocumentNo: Code[20])
    var
        LineSyncFlag: Codeunit "CMFRT GDW Line Sync Flag";
    begin
        // The flag has no reader outside this app.
        BindSubscription(LineSyncFlag);
        DoCMFRTGDWSyncLines(DocumentNo);
    end;

    local procedure DoCMFRTGDWSyncLines(DocumentNo: Code[20])
    var
        IsLineSync: Boolean;
    begin
        OnCMFRTGDWCheckLineSync(IsLineSync);
        if IsLineSync then
            exit;
    end;

    [InternalEvent(false)]
    local procedure OnCMFRTGDWCheckLineSync(var IsLineSync: Boolean)
    begin
    end;
}

codeunit 55061 "CMFRT GDW Line Sync Flag"
{
    Access = Internal;
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CMFRT GDW Line Sync Meth", 'OnCMFRTGDWCheckLineSync', '', false, false)]
    local procedure SetLineSync(var IsLineSync: Boolean)
    begin
        IsLineSync := true;
    end;
}
