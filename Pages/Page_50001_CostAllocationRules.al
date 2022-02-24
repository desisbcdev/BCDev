page 50001 "Cost Allocation Rules"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cost Allocation Header";
    Editable = false;
    CardPageId = "Cost Allocation Rule";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Cost Allocation No."; Rec."Cost Allocation No.")
                {
                    ApplicationArea = All;

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var
        SaleInvoice: Integer;
}