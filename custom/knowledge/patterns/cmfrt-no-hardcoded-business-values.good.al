// The code comes from a No. Series and the token from a setup field. A consultant changes
// both on the setup page, and every object reads them through the same getter.
table 2045691 "CMFRT JO Setup"
{
    Caption = 'CMFRT JO Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(2045081; "CMFRT JO Primary Key"; Code[10])
        {
            Caption = 'CMFRT JO Primary Key';
        }
        field(2045082; "CMFRT JO VAT Clause Nos."; Code[20])
        {
            Caption = 'CMFRT JO VAT Clause Nos.';
            ToolTip = 'Specifies the number series for the VAT clauses that projects generate.';
            TableRelation = "No. Series";
        }
        field(2045083; "CMFRT JO VAT Clause Token"; Text[10])
        {
            Caption = 'CMFRT JO VAT Clause Token';
            ToolTip = 'Specifies the placeholder that marks a project variable in a VAT clause template.';
            InitValue = '%99';
        }
    }

    keys
    {
        key(PK; "CMFRT JO Primary Key") { Clustered = true; }
    }

    procedure CMFRTJOGetVATClauseToken(): Text
    begin
        Rec.Get();
        Rec.TestField("CMFRT JO VAT Clause Token");
        exit(Rec."CMFRT JO VAT Clause Token");
    end;
}

codeunit 2045690 "CMFRT JO Materialize VAT Cl."
{
    procedure CMFRTJOCreateClause(Description: Text[250]): Code[20]
    var
        CMFRTJOSetup: Record "CMFRT JO Setup";
        VATClause: Record "VAT Clause";
        NoSeries: Codeunit "No. Series";
    begin
        CMFRTJOSetup.Get();
        CMFRTJOSetup.TestField("CMFRT JO VAT Clause Nos.");
        VATClause.Init();
        VATClause.Validate(Code, NoSeries.GetNextNo(CMFRTJOSetup."CMFRT JO VAT Clause Nos."));
        VATClause.Validate(Description, Description);
        VATClause.Insert(true);
        exit(VATClause.Code);
    end;

    procedure CMFRTJOTemplateHasVariable(Description: Text): Boolean
    var
        CMFRTJOSetup: Record "CMFRT JO Setup";
    begin
        exit(StrPos(Description, CMFRTJOSetup.CMFRTJOGetVATClauseToken()) > 0);
    end;
}
