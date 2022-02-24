pageextension 50028 SaleOrderExt extends "sales order"
{
    layout
    {
        addlast(General)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = all;

            }


        }
    }

    actions
    {
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                rec.TestField("Reason Code");
            end;
        }
    }

    var
        myInt: Integer;
}