pageextension 50034 JournalVoucherExt extends "Journal Voucher"
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