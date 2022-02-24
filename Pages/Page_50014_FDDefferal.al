page 50014 "FD Defferal"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FD Defferal";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;

                }

                field(PeriodDays; Rec.PeriodDays)
                {

                    ApplicationArea = All;

                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 2;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;

                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {


            action(PostLine)
            {
                ApplicationArea = All;
                Caption = 'Post Line';
                Image = Post;

                trigger OnAction()
                begin

                    Rec.DocumentPost();

                end;
            }
        }
    }
}