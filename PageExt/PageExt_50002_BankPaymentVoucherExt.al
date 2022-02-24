pageextension 50002 BankPaymentVoucherExt extends "Bank Payment Voucher"
{
    layout
    {
        modify("Reason Code")
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

        modify("Vendor GST Reg. No.")
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
        modify("TCS Nature of Collection")
        {
            Visible = false;
        }
        modify("T.A.N. No.")
        {
            Visible = false;
        }
        modify("T.C.A.N. No.")
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

        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
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
        addafter(PostAndPrint)
        {
            action("Export Bank Excel")
            {
                ApplicationArea = All;
                Caption = 'Export Bank Excel';
                Image = Print;
                Promoted = true;
                PromotedCategory = process;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE("Journal Template Name", rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RUNMODAL(50007, TRUE, FALSE, GenJnlLine);




                end;
            }
        }


    }


    var
        myInt: Integer;
        general: Record "Gen. Journal Line";

}