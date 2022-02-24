table 50006 "Fixed Deposit"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Document No.";
    LookupPageId = "Fixed Deposit List";
    DrillDownPageId = "Fixed Deposit List";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
            trigger OnValidate();
            begin
                IF "Document No." <> xRec."Document No." THEN BEGIN
                    PurchSetup.GET();
                    NoSeriesMgt.TestManual(PurchSetup."FD No Series");
                    "No. Series" := '';
                END;
            end;

        }
        field(2; Bank; code[20])
        {

            DataClassification = ToBeClassified;
            Caption = 'Bank';
            trigger OnLookup()
            var

            begin

                CheckStatus();
                BankNameLookup()

            end;

        }
        field(4; "FD Advice No"; Code[20])
        {
            DataClassification = ToBeClassified;

            Caption = 'FD Advice No';
            trigger OnValidate()
            var

            begin
                CheckStatus();

            end;
        }
        field(5; Principal; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Principal';
            DecimalPlaces = 2;
            trigger OnValidate()
            var

            begin
                CheckStatus();

            end;
        }
        field(6; "Rate of Interest Kotak"; Decimal)
        {
            DataClassification = ToBeClassified;

            DecimalPlaces = 2;
        }
        field(7; "Rate of Interest Citi"; Decimal)
        {
            DataClassification = ToBeClassified;

            DecimalPlaces = 2;
        }
        field(8; "FD Made On"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'FD Made on';
            trigger OnValidate()
            var

            begin
                CheckStatus();

            end;
        }
        field(9; Days; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Days';

            trigger OnValidate()
            begin

                CheckStatus();
                "Fd Maturity Date" := CalcDate(Format(days) + 'D', "FD Made On");
                "Intrest Earned" := 0;

            end;

        }
        field(10; "Fd Maturity Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fd Maturity Date';
            Editable = false;
        }
        field(11; Status; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            OptionMembers = Open,Close;
            OptionCaption = 'Open,Close';
        }
        field(12; "Intrest Earned"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Interest Earned';
            DecimalPlaces = 2;
            Editable = false;
        }
        field(13; "Rate of Interest Axis"; Decimal)
        {
            DataClassification = ToBeClassified;

            DecimalPlaces = 2;
            Caption = 'Rate of Interest';
            trigger OnValidate()
            var

            begin
                CheckStatus();

            end;
        }
        field(14; "FD Period"; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                //  "Fd Maturity Date" := CalcDate("FD Period", "FD Made On");
                // Days := "Fd Maturity Date" - "FD Made On";
            end;
        }
        field(15; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }

        field(17; "Rate of Interest HDFC"; Decimal)
        {
            DataClassification = ToBeClassified;

            DecimalPlaces = 2;
        }

        Field(20; "Interest Acc A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Interest Acc A/C';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            trigger OnValidate()
            var

            begin
                CheckStatus();

            end;
        }

        Field(23; "Interest Rev A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Interest Rev A/C';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            trigger OnValidate()
            var

            begin
                CheckStatus();

            end;
        }

        Field(26; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posted';
            Editable = false;

        }
        field(27; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                CheckStatus();
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(28; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                CheckStatus();
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");

            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }



    }

    keys
    {
        key(Pk; "Document No.")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    begin
        IF "Document No." = '' THEN BEGIN
            PurchSetup.GET();
            PurchSetup.TESTFIELD("FD No Series");
            NoSeriesMgt.InitSeries(PurchSetup."FD No Series", xRec."No. Series", 0D, "Document No.", "No. Series");
        END;
    end;


    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        CheckStatus();

    end;

    trigger OnRename()
    begin

    end;

    Procedure BankNameLookup()
     BankAcct: Record "Bank Account";
    begin

        BankAcct.Reset();

        if Page.RunModal(Page::"Bank Account List", BankAcct) = Action::LookupOK then
            Rec.Validate(Bank, BankAcct.Name);


    end;

    Procedure CheckStatus()
    begin
        TestField(Posted, false);
    end;


    procedure DocumentPost()
    begin
        CheckStatus();

        clear(GenJnlPostCU);

        if not Confirm(ConfirmDoc) then
            exit;

        PurchSetup.Get;
        Rec.TestField("Intrest Earned");

        PurchSetup.TestField("Fixed Deposit Jnl. Tem. Name");
        PurchSetup.TestField("Fixed Deposit Jnl. Batch Name");
        Rec.TestField("Interest Acc A/C");
        Rec.TestField("Interest Rev A/C");

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

        GenJnlLineRec.VALIDATE("Account No.", "Interest Rev A/C");

        GenJnlLineRec.VALIDATE("Bal. Account Type", GenJnlLineRec."Bal. Account Type"::"G/L Account");
        GenJnlLineRec.VALIDATE("Bal. Account No.", "Interest Acc A/C");
        GenJnlLineRec.VALIDATE(Amount, "Intrest Earned");
        GenJnlLineRec."Fixed Deposit No." := Rec."Document No.";
        GenJnlLineRec.Description := "Document No.";
        if Rec."Dimension Set ID" <> 0 then begin
            GenJnlLineRec.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLineRec.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
            GenJnlLineRec."Dimension Set ID" := Rec."Dimension Set ID";
        end;



        GenJnlPostCU.RUN(GenJnlLineRec);
        Posted := true;
        Modify;


        Message(PostedMsg);




    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode, IsHandled);
        if IsHandled then
            exit;


        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    procedure ShowDimensions()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowDimensions(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1', "Document No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var FixedDeposit: Record "Fixed Deposit"; var xFixedDeposit: Record "Fixed Deposit"; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var FixedDeposit: Record "Fixed Deposit"; var xFixedDeposit: Record "Fixed Deposit"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowDimensions(var FixedDeposit: Record "Fixed Deposit"; xFixedDeposit: Record "Fixed Deposit"; var IsHandled: Boolean)
    begin
    end;


    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ConfirmDoc: Label 'Do you want create journal entries ?';
        PostedMsg: Label 'Document posted';
        GenJnlPostCU: Codeunit "Gen. Jnl.-Post Line";
        GenJnlLineRec: record "Gen. Journal Line";
        GenJnlTemplateRec: record "Gen. Journal Template";
        GenJnlBatchRec: Record "Gen. Journal Batch";
        PostedNumGvar: Code[20];
        DimMgt: Codeunit DimensionManagement;



}