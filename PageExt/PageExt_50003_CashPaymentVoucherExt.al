pageextension 50003 CashPaymentVoucherExt extends "Cash Payment Voucher"
{
    layout
    {
        modify("Reason Code")
        {
            Visible = false;
        }
    }

    actions
    {
        modify(SendApprovalRequestJournalLine)
        {
            trigger OnBeforeAction()
            begin
                rec.TestField("Reason Code");
            end;
        }
        modify(SendApprovalRequestJournalBatch)
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