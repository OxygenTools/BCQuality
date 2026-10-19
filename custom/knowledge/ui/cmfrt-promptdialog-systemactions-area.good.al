page 2045675 "CMFRT GD POI From Attachment"
{
    PageType = PromptDialog;
    Caption = 'Create points of interest from a file';
    Extensible = false;
    PromptMode = Prompt;

    layout
    {
        area(Prompt)
        {
            field(InstructionText; InstructionText)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Describe which columns of the file hold the points of interest';
            }
        }
        area(Content)
        {
            field(ProposalText; ProposalText)
            {
                ApplicationArea = All;
                Caption = 'Proposed points of interest';
                ToolTip = 'Shows the points of interest that the file proposes, before you insert them.';
                MultiLine = true;
                Editable = false;
            }
        }
    }

    actions
    {
        // System actions exist only inside area(SystemActions) of the actions section.
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Read the attached file and propose the points of interest it holds.';

                trigger OnAction()
                var
                    POIProposalMgmt: Codeunit "CMFRT GD POI Proposal Mgmt";
                begin
                    POIProposalMgmt.CMFRTGDPropose(InstructionText, ProposalText, HasDescriptionColumn);
                end;
            }
            systemaction(OK)
            {
                Caption = 'Insert';
                ToolTip = 'Insert the proposed points of interest into the list.';
                // Enabled accepts a global Boolean variable of the page.
                Enabled = HasDescriptionColumn;
            }
            systemaction(Cancel)
            {
                Caption = 'Discard';
                ToolTip = 'Close the dialog and discard the proposed points of interest.';
            }
        }
    }

    // Bound to controls and to the Enabled property, so these stay at page scope.
    var
        InstructionText: Text;
        ProposalText: Text;
        HasDescriptionColumn: Boolean;
}
