// Stateless service codeunit. Nothing here holds state between calls, yet the helper
// instances and the label sit at object scope so three procedures can reach them.
codeunit 2045120 "CMFRT GA Endpoint Meth"
{
    var
        // Shared between unrelated procedures, outlive their callers as dead state,
        // and hide that Resolve() and Validate() exchange nothing at all.
        EndpointConfig: Record "CMFRT GA Endpoint";
        ConfigCache: Codeunit "CMFRT GA Config Cache";
        TypeMapper: Codeunit "CMFRT GA Type Mapper";
        ValidationFailedCodeLbl: Label 'VALIDATION_FAILED', Locked = true;

    procedure CMFRTGAResolve(EndpointCode: Code[30]): Text
    begin
        // Reads EndpointConfig — but so does CMFRTGAValidate, and neither can tell
        // whether the other left a stale record behind.
        ConfigCache.CMFRTGAGet(EndpointCode, EndpointConfig);
        exit(TypeMapper.CMFRTGAMapType(EndpointConfig."CMFRT GA Payload Type"));
    end;

    procedure CMFRTGAValidate(EndpointCode: Code[30]): Code[30]
    begin
        ConfigCache.CMFRTGAGet(EndpointCode, EndpointConfig);
        if EndpointConfig."CMFRT GA Payload Type" = EndpointConfig."CMFRT GA Payload Type"::" " then
            exit(ValidationFailedCodeLbl);
        exit('');
    end;
}
