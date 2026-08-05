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

                // Integer cue fields support Image — the name comes from https://aka.ms/bcicons.
                field("CMFRT GD Open POI Count"; Rec."CMFRT GD Open POI Count")
                {
                    ApplicationArea = All;
                    Caption = 'Open POIs';
                    ToolTip = 'Specifies the number of points of interest that are not yet processed.';
                    Image = Job;
                    DrillDownPageId = "CMFRT GD POI List";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // Action groups carry Image as well, not only the actions inside them.
            group("CMFRT GD POI Group")
            {
                Caption = 'POI';
                ToolTip = 'Manage points of interest.';
                Image = List;

                action("CMFRT GD Recalculate Distances")
                {
                    ApplicationArea = All;
                    Caption = 'Recalculate Distances';
                    ToolTip = 'Recalculate the distance between each point of interest and the job site.';
                    Image = Calculate;

                    trigger OnAction()
                    var
                        POIMgmt: Codeunit "CMFRT GD POI Mgmt";
                    begin
                        POIMgmt.CMFRTGDRecalculateDistances();
                    end;
                }

                // fileuploadaction supports Image too (runtime version 13.0 and later).
                fileuploadaction("CMFRT GD Import POI File")
                {
                    ApplicationArea = All;
                    Caption = 'Import POIs';
                    ToolTip = 'Import points of interest from a comma-separated file.';
                    Image = Import;
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
