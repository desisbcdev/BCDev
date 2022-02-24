pageextension 50008 PayentJnlExt extends "Payment Journal"
{
    layout
    {
        addafter(Amount)
        {
            field("Cost Allocation Rule"; Rec."Cost Allocation Rule")
            {
                ApplicationArea = all;
                Enabled = Rec.Amount <> 0;
                trigger OnValidate()
                var
                    CostAllocation: Codeunit "Purch.-Post Cost AllocationNew";
                begin
                    rec.TestField(Amount);
                    CostAllocation.SplitGenJournal(Rec);
                    CurrPage.Update(false);
                end;
            }
        }


        modify("Reason Code")
        {
            Visible = false;
        }
    }

    actions
    {

        addafter(Preview)
        {
            action(ExportLines)
            {
                ApplicationArea = All;
                Image = Export;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                begin
                    GenJnlLine.copy(Rec);
                    GenJnlLine.setrange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.setrange("Journal Batch Name", Rec."Journal Batch Name");
                    Report.RunModal(50011, false, false, GenJnlLine);

                end;
            }
            action("Line Narration")
            {
                PromotedOnly = true;
                ApplicationArea = Basic, Suite;
                Caption = 'Line Narration';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select this option to enter narration for a particular line.';

                trigger OnAction()
                var
                    GenNarration: Record "Gen. Journal Narration";
                    LineNarrationPage: Page "Line Narration";
                begin
                    GenNarration.Reset();
                    GenNarration.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenNarration.SetRange("Document No.", Rec."Document No.");
                    GenNarration.SetRange("Gen. Journal Line No.", Rec."Line No.");
                    LineNarrationPage.SetTableView(GenNarration);
                    LineNarrationPage.RunModal();

                    // ShowOldNarration();
                    VoucherFunctions.ShowOldNarration(Rec);
                    CurrPage.Update(true);
                end;
            }
            action("Voucher Narration")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Voucher Narration';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select this option to enter narration for the voucher.';

                trigger OnAction()
                var
                    GenNarration: Record "Gen. Journal Narration";
                    VoucherNarration: Page "Voucher Narration";
                begin
                    GenNarration.Reset();
                    GenNarration.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenNarration.SetRange("Document No.", Rec."Document No.");
                    GenNarration.SetFilter("Gen. Journal Line No.", '%1', 0);
                    VoucherNarration.SetTableView(GenNarration);
                    VoucherNarration.RunModal();

                    //ShowOldNarration();
                    VoucherFunctions.ShowOldNarration(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
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
        addafter("Post and &Print")
        {
            action("ExportBank Excel")
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

        GenJnlLine: Record "Gen. Journal Line";
        VoucherFunctions: Codeunit "Voucher Functions";

}