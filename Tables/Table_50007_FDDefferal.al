table 50007 "FD Defferal"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(7; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }

        field(9; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(12; PeriodDays; Integer)
        {
            DataClassification = ToBeClassified;

        }

        Field(15; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure DocumentPost()
    begin


        Clear(GenJnlPostCU);
        Clear(PostedNumGvar);

        if not Confirm(ConfirmDoc) then
            exit;

        PurchSetup.Get;
        Rec.TestField(Posted, false);
        FixedDeposit.Get(Rec."Document No.");

        PurchSetup.TestField("Fixed Deposit Jnl. Tem. Name");
        PurchSetup.TestField("Fixed Deposit Jnl. Batch Name");
        FixedDeposit.TestField("Interest Acc A/C");
        FixedDeposit.TestField("Interest Rev A/C");

        GenJnlLineRec.RESET;
        GenJnlLineRec.SETRANGE("Journal Template Name", PurchSetup."Fixed Deposit Jnl. Tem. Name");
        GenJnlLineRec.SETRANGE("Journal Batch Name", PurchSetup."Fixed Deposit Jnl. Batch Name");
        IF GenJnlLineRec.FINDFIRST THEN
            GenJnlLineRec.DELETEALL;

        GenJnlBatchRec.Get(PurchSetup."Fixed Deposit Jnl. Tem. Name", PurchSetup."Fixed Deposit Jnl. Batch Name");
        GenJnlBatchRec.TestField("No. Series");



        PostedNumGvar := NoSeriesMgt.GetNextNo(GenJnlBatchRec."No. Series", WORKDATE, TRUE);

        GenJnlLineRec.INIT;
        GenJnlLineRec.VALIDATE("Journal Template Name", PurchSetup."Fixed Deposit Jnl. Tem. Name");
        GenJnlLineRec.VALIDATE("Journal Batch Name", PurchSetup."Fixed Deposit Jnl. Batch Name");
        GenJnlLineRec."Line No." := 1000;
        GenJnlLineRec.VALIDATE("Posting Date", Today);

        GenJnlTemplateRec.GET(GenJnlLineRec."Journal Template Name");
        GenJnlLineRec."Source Code" := GenJnlTemplateRec."Source Code";
        GenJnlLineRec."Document No." := PostedNumGvar;



        GenJnlLineRec.VALIDATE("Account Type", GenJnlLineRec."Account Type"::"G/L Account");

        GenJnlLineRec.VALIDATE("Account No.", FixedDeposit."Interest Acc A/C");

        GenJnlLineRec.VALIDATE("Bal. Account Type", GenJnlLineRec."Bal. Account Type"::"G/L Account");
        GenJnlLineRec.VALIDATE("Bal. Account No.", FixedDeposit."Interest Rev A/C");
        GenJnlLineRec.VALIDATE(Amount, Rec.Amount);
        GenJnlLineRec."Fixed Deposit No." := Rec."Document No.";
        GenJnlLineRec.Description := "Document No.";

        if FixedDeposit."Dimension Set ID" <> 0 then begin
            GenJnlLineRec.Validate("Shortcut Dimension 1 Code", FixedDeposit."Shortcut Dimension 1 Code");
            GenJnlLineRec.Validate("Shortcut Dimension 2 Code", FixedDeposit."Shortcut Dimension 2 Code");
            GenJnlLineRec."Dimension Set ID" := FixedDeposit."Dimension Set ID";
        end;



        GenJnlPostCU.RUN(GenJnlLineRec);
        Posted := true;
        Modify;
        Message(PostedMsg);
    end;


    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FixedDeposit: Record "Fixed Deposit";

        GenJnlPostCU: Codeunit "Gen. Jnl.-Post Line";
        GenJnlLineRec: record "Gen. Journal Line";
        GenJnlTemplateRec: record "Gen. Journal Template";
        GenJnlBatchRec: Record "Gen. Journal Batch";
        PostedNumGvar: Code[20];
        ConfirmDoc: Label 'Do you want post entry ?';
        PostedMsg: Label 'Document posted';





}