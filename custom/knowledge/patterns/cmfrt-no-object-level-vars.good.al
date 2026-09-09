// Same codeunit, declarations pushed into the procedures that use them. ConfigCache and
// the label are declared twice — that duplication is the intended outcome, not a smell.
codeunit 2045120 "CMFRT GA Endpoint Meth"
{
    procedure CMFRTGAResolve(EndpointCode: Code[30]): Text
    var
        EndpointConfig: Record "CMFRT GA Endpoint";
        ConfigCache: Codeunit "CMFRT GA Config Cache";
        TypeMapper: Codeunit "CMFRT GA Type Mapper";
    begin
        // ConfigCache is SingleInstance, so a per-procedure declaration still reaches
        // the one shared cache. A non-SingleInstance callee holding its own state
        // would get a fresh instance here — check before localizing.
        ConfigCache.CMFRTGAGet(EndpointCode, EndpointConfig);
        exit(TypeMapper.CMFRTGAMapType(EndpointConfig."CMFRT GA Payload Type"));
    end;

    procedure CMFRTGAValidate(EndpointCode: Code[30]): Code[30]
    var
        EndpointConfig: Record "CMFRT GA Endpoint";
        ConfigCache: Codeunit "CMFRT GA Config Cache";
        ValidationFailedCodeLbl: Label 'VALIDATION_FAILED', Locked = true;
    begin
        ConfigCache.CMFRTGAGet(EndpointCode, EndpointConfig);
        exit(DoCMFRTGACheckPayloadType(EndpointConfig, ValidationFailedCodeLbl));
    end;

    // State the caller already holds travels as a parameter — `var` only where the
    // callee writes back. This is what replaces the shared object-level record.
    local procedure DoCMFRTGACheckPayloadType(EndpointConfig: Record "CMFRT GA Endpoint"; FailureCode: Code[30]): Code[30]
    begin
        if EndpointConfig."CMFRT GA Payload Type" = EndpointConfig."CMFRT GA Payload Type"::" " then
            exit(FailureCode);
        exit('');
    end;
}

// Exception 4: AL resolves a control source expression and the StyleExpr property
// against object scope only, so these two declarations must stay where they are.
page 2045121 "CMFRT GA Endpoint Card"
{
    SourceTable = "CMFRT GA Endpoint";

    layout
    {
        area(Content)
        {
            group(Status)
            {
                field(SchemaJsonControl; SchemaJson)
                {
                    ApplicationArea = All;
                    Caption = 'Schema';
                    StyleExpr = EnabledStyleTxt;
                    ToolTip = 'Specifies the generated schema for this endpoint.';
                }
            }
        }
    }

    var
        SchemaJson: Text;
        EnabledStyleTxt: Text;

    trigger OnAfterGetRecord()
    var
        SchemaBuilder: Codeunit "CMFRT GA Schema Builder";
    begin
        SchemaJson := SchemaBuilder.CMFRTGABuildSchema(Rec);
        if Rec."CMFRT GA Enabled" then
            EnabledStyleTxt := 'Favorable'
        else
            EnabledStyleTxt := 'Subordinate';
    end;
}
