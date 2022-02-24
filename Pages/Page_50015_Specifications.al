page 50015 Specifications
{
    PageType = ListPart;
    ApplicationArea = all;
    UsageCategory = Lists;

    SourceTable = Specification;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Serial No./Product Code"; Rec."Serial No./Product Code")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                Field(UOM; Rec.UOM)
                {
                    ApplicationArea = All;

                }
                field(Qty; Rec.Qty)
                {
                    ApplicationArea = all;
                }

                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                }

            }
        }

    }


}