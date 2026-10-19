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
    }

    // Copied from a pseudo-code sketch in the design document. AL has no systemactions keyword.
    // The parser closes the page here and reads the rest of the file as new objects:
    // AL0104, AL0107, AL0114 and AL0198 on this page, and a misleading AL0197 on another object.
    systemactions
    {
        systemaction(OK)
        {
            Caption = 'Insert';
            Enabled = HasDescriptionColumn;
        }
        systemaction(Cancel)
        {
            Caption = 'Discard';
        }
    }

    actions
    {
        // A system action outside area(SystemActions) is also wrong,
        // and Processing is not an action area of a PromptDialog page.
        area(Processing)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
            }
        }
    }

    var
        InstructionText: Text;
        HasDescriptionColumn: Boolean;
}
