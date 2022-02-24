pageextension 50029 SaleInvoiceExt extends "Sales Invoice"
{
    layout
    {
        modify("Reason Code")
        {
            Visible = true;

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