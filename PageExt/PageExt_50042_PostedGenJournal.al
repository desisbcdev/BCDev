pageextension 50042 PostedGenJournalExt extends "Posted General Journal"
{
    layout
    {





    }

    actions
    {

        addafter(Functions)
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
                    PostedGenJnlLine: Record "Posted Gen. Journal Line";
                begin
                    PostedGenJnlLine.RESET;
                    PostedGenJnlLine.SETRANGE("Journal Template Name", rec."Journal Template Name");
                    PostedGenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RUNMODAL(50029, TRUE, FALSE, PostedGenJnlLine);


                end;
            }
        }


    }


    var
        myInt: Integer;

}