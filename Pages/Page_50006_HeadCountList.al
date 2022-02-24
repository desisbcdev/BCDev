page 50006 HeadCountList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Head Count";
    Caption = 'Head Count List';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;

                }
                field("No. Of Employees joined"; Rec."No. Of Employees joined")
                {
                    ApplicationArea = all;
                }
                field("No. Of Employees Present"; Rec."No. Of Employees Present")
                {
                    ApplicationArea = all;
                }
                field("Total Employees Present"; Rec."Total Employees Present")
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