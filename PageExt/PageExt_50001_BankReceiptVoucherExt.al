pageextension 50001 BankReceiptVoucherExt extends "Bank Receipt Voucher"
{
    layout
    {
        modify("Reason Code")
        {
            Visible = false;
        }

        modify("TDS Section Code")
        {
            Visible = false;
        }

        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }

        modify("T.A.N. No.")
        {
            Visible = false;
        }
        modify("TDS Certificate Receivable")
        {
            Visible = false;
        }

        modify("Location Code")
        {
            Visible = false;
        }
        modify("GST on Advance Payment")
        {
            Visible = false;
        }
        modify("Amount Excl. GST")
        {
            Visible = false;
        }
        modify("GST TDS/GST TCS")
        {
            Visible = false;
        }

        modify("GST TCS State Code")
        {
            Visible = false;
        }

        modify("GST TDS/TCS Base Amount")
        {
            Visible = false;
        }

        modify("GST Group Code")
        {
            Visible = false;
        }

        modify("HSN/SAC Code")
        {
            Visible = false;
        }

        modify("Location State Code")
        {
            Visible = false;
        }

        modify("GST Group Type")
        {
            Visible = false;
        }

        modify("Customer GST Reg. No.")
        {
            Visible = false;
        }
        modify("Location GST Reg. No.")
        {
            Visible = false;
        }

        modify("GST Vendor Type")
        {
            Visible = false;
        }
        modify("Bank Charge")
        {
            Visible = false;
        }

        modify("EU 3-Party Trade")
        {
            Visible = false;
        }

        modify("Gen. Posting Type")
        {
            Visible = false;
        }

        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Cheque No.")
        {
            Visible = false;
        }
        modify("Cheque Date")
        {
            Visible = false;
        }




        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }

        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }


        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }

        modify("Deferral Code")
        {
            Visible = false;
        }

        modify(Correction)
        {
            Visible = false;
        }

        modify(Comment)
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
                Rec.TestField("Reason Code");
            end;
        }
        modify(SendApprovalRequestJournalBatch)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Reason Code");
            end;
        }

    }

    var

}