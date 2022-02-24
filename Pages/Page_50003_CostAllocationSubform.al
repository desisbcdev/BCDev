page 50003 "Cost Allocation Subform"
{
    PageType = ListPart;
    SourceTable = "Cost Allocation Line";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;

                }
                field("Dimension Value Code"; Rec."Dimension Value Code")
                {
                    ApplicationArea = all;
                }
                field("Allocation %"; Rec."Allocation %")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}