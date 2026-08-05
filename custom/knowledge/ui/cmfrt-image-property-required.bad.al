page 2045670 "CMFRT GD POI Activities"
{
    PageType = CardPart;
    SourceTable = "CMFRT GD POI Cue";

    layout
    {
        area(Content)
        {
            cuegroup("CMFRT GD Open POIs")
            {
                Caption = 'Open POIs';

                // No Image on an integer cue field — the cue renders without an icon.
                field("CMFRT GD Open POI Count"; Rec."CMFRT GD Open POI Count")
                {
                    ApplicationArea = All;
                    Caption = 'Open POIs';
                    ToolTip = 'Specifies the number of points of interest that are not yet processed.';
                    DrillDownPageId = "CMFRT GD POI List";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // No Image on the group — the submenu is indistinguishable from its neighbours.
            group("CMFRT GD POI Group")
            {
                Caption = 'POI';
                ToolTip = 'Manage points of interest.';

                // No Image on the action — UICop raises AW0005 and the action bar looks inconsistent.
                action("CMFRT GD Recalculate Distances")
                {
                    ApplicationArea = All;
                    Caption = 'Recalculate Distances';
                    ToolTip = 'Recalculate the distance between each point of interest and the job site.';

                    trigger OnAction()
                    var
                        POIMgmt: Codeunit "CMFRT GD POI Mgmt";
                    begin
                        POIMgmt.CMFRTGDRecalculateDistances();
                    end;
                }

                fileuploadaction("CMFRT GD Import POI File")
                {
                    ApplicationArea = All;
                    Caption = 'Import POIs';
                    ToolTip = 'Import points of interest from a comma-separated file.';
                    // Guessed icon name that is not in the library at https://aka.ms/bcicons.
                    Image = ImportPointOfInterest;
                    AllowMultipleFiles = false;
                    AllowedFileExtensions = '.csv';

                    trigger OnAction(Files: List of [FileUpload])
                    var
                        POIMgmt: Codeunit "CMFRT GD POI Mgmt";
                    begin
                        POIMgmt.CMFRTGDImportPOIFiles(Files);
                    end;
                }
            }
        }
    }
}
