codeunit 50008 ApprovalPosting
{

    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnReleaseDocument', '', true, true)]

    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        IsHandledAutoPosting: Boolean;
    begin
        //General Journals Auto posting when final approver approves
        case RecRef.Number of
            DATABASE::"Gen. Journal Batch":
                begin
                    Handled := true;
                    RecRef.SetTable(GenJournalBatch);

                    IsHandledAutoPosting := false;


                    if IsHandledAutoPosting then
                        exit;

                    GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
                    if GenJournalLine.FindSet() then
                        GenJnlPostBatch.Run(GenJournalLine);
                end;
            DATABASE::"Gen. Journal Line":
                begin
                    Handled := true;
                    RecRef.SetTable(GenJournalLine);

                    IsHandledAutoPosting := false;


                    if IsHandledAutoPosting then
                        exit;

                    GenJournalLine2.SetFilter("Journal Template Name", GenJournalLine."Journal Template Name");
                    GenJournalLine2.SetFilter("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    GenJournalLine2.SetFilter("Document No.", GenJournalLine."Document No.");
                    if GenJournalLine2.FindSet() then
                        GenJnlPost.Run(GenJournalLine2);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DocumentNoVisibility, 'OnBeforeEmployeeNoIsVisible', '', false, false)]
    local procedure EMPNumVisiblity(var IsVisible: Boolean; var IsHandled: Boolean)
    begin
        IsVisible := true;
        IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Table, database::"CV Ledger Entry Buffer", 'OnAfterCopyFromEmplLedgerEntry', '', false, false)]
    local procedure UpdateReasonCodeinGenJnl(EmployeeLedgerEntry: Record "Employee Ledger Entry"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin

        CVLedgerEntryBuffer."Reason Code" := EmployeeLedgerEntry."Reason Code"

    end;





}
