pageextension 50004 CashReceiptVoucherExt extends "Cash Receipt Voucher"
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