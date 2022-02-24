report 50035 "General Jnl Import From Excel"
{


    Caption = 'General Jnl Import From Excel';

    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {

    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }


    }

    labels
    {
    }

    trigger OnPreReport();
    var
        X: Integer;
    begin
        ReadExcelSheet();
        GetLastRow;



        FOR X := 2 TO TotalRows DO
            CheckValidations(X);

        LineNum := 10000;
        FOR X := 2 TO TotalRows DO
            InsertData(X);

        if GenJnlBatchRec."Auto Posting" then begin
            clear(GenJnlPostBatch);

            GenJnlLineRec.Reset;
            GenJnlLineRec.SetRange("Journal Template Name", GenJnlBatchRec."Journal Template Name");
            GenJnlLineRec.SetRange("Journal Batch Name", GenJnlBatchRec.Name);
            if GenJnlLineRec.FindSet() then
                GenJnlPostBatch.Run(GenJnlLineRec);

            Message(PostingMsg, JournalTemplateName, JournalBatchName);

        end else
            Message(ImportMsg, JournalTemplateName, JournalBatchName);

        ExcelBuffer.DELETEALL;

    end;










    procedure GetLastRow();
    begin
        ExcelBuffer.SetRange("Row No.", 1);
        TotalColumns := ExcelBuffer.Count;
        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    procedure InsertData(RowNo: Integer);
    var

    begin

        Clear(JournalTemplateName);
        Clear(JournalBatchName);
        Clear(PostingDate);
        Clear(DocumentNum);
        Clear(AcctTypeVar);
        Clear(AccountNum);
        Clear(BalAcctTypeVar);
        Clear(BalAccountNum);
        Clear(AmountVar);
        Clear(BalAccountName);
        Clear(AccountName);
        Clear(GD1Code);
        Clear(GD2Code);
        Clear(LineDesc);
        Clear(ReasonCode);
        Clear(AppliesToDocNum);



        JournalTemplateName := GetValueAtCell(RowNo, 1);   // Journal Template Name

        JournalBatchName := GetValueAtCell(RowNo, 2);   // Journal Batch Name

        GenJnlBatchRec.Get(JournalTemplateName, JournalBatchName);




        DocumentNum := NoSeriesMgt.GetNextNo(GenJnlBatchRec."No. Series", WORKDATE, TRUE);
        if EVALUATE(PostingDate, GetValueAtCell(RowNo, 3)) then;   // Posting Date


        if Evaluate(AcctTypeVar, GetValueAtCell(RowNo, 4)) then; // Account Type
        AccountNum := GetValueAtCell(RowNo, 5);  // Account No.
        AccountName := GetValueAtCell(RowNo, 6);  // Account Name

        if AccountNum = '' then
            AccountNum := GetAcctNum(AcctTypeVar, AccountName);



        if Evaluate(AmountVar, GetValueAtCell(RowNo, 7)) then;   // Amount
        if Evaluate(BalAcctTypeVar, GetValueAtCell(RowNo, 8)) then; // Balance Acct Type
        BalAccountNum := GetValueAtCell(RowNo, 9);  // Balance Account No.
        BalAccountName := GetValueAtCell(RowNo, 10);  // Balance Account Name

        if BalAccountNum = '' then
            BalAccountNum := GetAcctNum(BalAcctTypeVar, BalAccountName);

        GD1Code := GetValueAtCell(RowNo, 11);  // GD1
        GD2Code := GetValueAtCell(RowNo, 12);  // GD2
        LineDesc := GetValueAtCell(RowNo, 13);  // Line description
        ReasonCode := GetValueAtCell(RowNo, 14);  // Reason Code
        AppliesToDocNum := GetValueAtCell(RowNo, 15);  // Applies to Document number




        GenJnlLineRec.INIT;
        GenJnlLineRec.VALIDATE("Journal Template Name", JournalTemplateName);
        GenJnlLineRec.VALIDATE("Journal Batch Name", JournalBatchName);
        GenJnlLineRec."Line No." := LineNum;
        GenJnlLineRec.VALIDATE("Posting Date", PostingDate);

        GenJnlTemplateRec.GET(GenJnlLineRec."Journal Template Name");
        GenJnlLineRec."Source Code" := GenJnlTemplateRec."Source Code";
        GenJnlLineRec."Document No." := DocumentNum;

        GenJnlLineRec.VALIDATE("Account Type", AcctTypeVar);
        GenJnlLineRec.VALIDATE("Account No.", AccountNum);

        GenJnlLineRec.VALIDATE("Bal. Account Type", BalAcctTypeVar);
        GenJnlLineRec.VALIDATE("Bal. Account No.", BalAccountNum);

        GenJnlLineRec.VALIDATE(Amount, AmountVar);
        if GD1Code <> '' then
            GenJnlLineRec.validate("Shortcut Dimension 1 Code", GD1Code);
        if GD2Code <> '' then
            GenJnlLineRec.validate("Shortcut Dimension 2 Code", GD2Code);
        GenJnlLineRec.Description := LineDesc;
        GenJnlLineRec."Reason Code" := ReasonCode;
        if AppliesToDocNum <> '' then
            GenJnlLineRec.Validate("Applies-to Doc. No.", AppliesToDocNum);


        GenJnlLineRec.INSERT(TRUE);
        LineNum += 10000;





    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    begin
        IF ExcelBuffer1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuffer1."Cell Value as Text");
        EXIT('');
    end;

    procedure CheckValidations(RowNo: Integer)
    var


    begin
        Clear(AcctTypeVar);
        Clear(AccountNum);
        Clear(BalAcctTypeVar);
        Clear(BalAccountNum);
        Clear(BalAccountName);
        Clear(AccountName);
        Clear(GD1Code);
        Clear(GD2Code);
        Clear(LineDesc);
        Clear(ReasonCode);
        clear(AppliesToDocNum);



        if not GenJnlTemplateRec.GET(GetValueAtCell(RowNo, 1)) then
            Error(ExcelRowColErr, RowNo, 1);

        if not GenJnlBatchRec.GET(GetValueAtCell(RowNo, 1), GetValueAtCell(RowNo, 2)) then
            Error(ExcelRowColErr, RowNo, 2);
        GenJnlBatchRec.TestField("No. Series");




        if not (Evaluate(AcctTypeVar, GetValueAtCell(RowNo, 4))) then
            Error(ExcelRowColErr, RowNo, 4);

        if not (Evaluate(BalAcctTypeVar, GetValueAtCell(RowNo, 8))) then
            Error(ExcelRowColErr, RowNo, 8);

        if not (Evaluate(PostingDate, GetValueAtCell(RowNo, 3))) then
            Error(ExcelRowColErr, RowNo, 3);

        AccountNum := GetValueAtCell(RowNo, 5);  // Account No.

        if AccountNum = '' then begin
            AccountName := GetValueAtCell(RowNo, 6);  // Account Name
            if AccountName = '' then
                Error(ExcelRowColErr, RowNo, 6);

        end;


        BalAccountNum := GetValueAtCell(RowNo, 9);  // Balance Account No.
        if BalAccountNum = '' then begin
            BalAccountName := GetValueAtCell(RowNo, 10);  // Balance Account Name

            if BalAccountName = '' then
                Error(ExcelRowColErr, RowNo, 10);

        end;

        if CheckAcctNum(AcctTypeVar, AccountNum, AccountName, RowNo, 6) then // Heare 6 represents Acct name col number
            Error(ExcelRowColErr, RowNo, 5);

        if CheckAcctNum(BalAcctTypeVar, BalAccountNum, BalAccountName, RowNo, 10) then // Heare 10 represents Bal Acct name col number
            Error(ExcelRowColErr, RowNo, 9);

        GD1Code := GetValueAtCell(RowNo, 11);  // GD1
        GD2Code := GetValueAtCell(RowNo, 12);  // GD2
        CheckDimension(GD1Code, GD2Code, RowNo);

        LineDesc := GetValueAtCell(RowNo, 13);  // Line Desc
        ReasonCode := GetValueAtCell(RowNo, 14);  // Reason Code
        if ReasonCode <> '' then
            if Not ReasonCodeRec.Get(ReasonCode) then
                Error(ExcelRowColErr, RowNo, 14);


        AppliesToDocNum := GetValueAtCell(RowNo, 15);  // Applies to Document Number
        if AppliesToDocNum <> '' then
            if StrLen(AppliesToDocNum) > 20 then
                Error(ExcelRowColErr, RowNo, 15);



    end;

    Procedure CheckAcctNum(AcctTypePar: Enum "Gen. Journal Account Type"; AcctNumLPar: Code[20];
                            AcctNamePar: Text[100]; RowNumPar: Integer; ColumnNumPar: Integer): Boolean

    Var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;
        ErrorFound: Boolean;



    begin

        Clear(ErrorFound);
        case AcctTypePar of
            AcctTypePar::"G/L Account":
                begin
                    if AcctNumLPar <> '' then begin
                        if not GLAcc.Get(AcctNumLPar) then
                            ErrorFound := true;
                    end else begin
                        GLAcc.Reset;
                        GLAcc.Setrange(Name, AcctNamePar);
                        if not GLAcc.FindFirst() then
                            Error(ExcelRowColErr, RowNumPar, ColumnNumPar);

                    end;

                end;
            AcctTypePar::Customer:
                begin
                    if AcctNumLPar <> '' then begin
                        if not Cust.Get(AcctNumLPar) then
                            ErrorFound := true;

                    end else begin
                        Cust.Reset;
                        Cust.Setrange(Name, AcctNamePar);
                        if not Cust.FindFirst() then
                            Error(ExcelRowColErr, RowNumPar, ColumnNumPar);

                    end;


                end;
            AcctTypePar::Vendor:
                begin
                    if AcctNumLPar <> '' then begin
                        if not Vend.Get(AcctNumLPar) then
                            ErrorFound := true;

                    end else begin
                        Vend.Reset;
                        Vend.Setrange(Name, AcctNamePar);
                        if not Vend.FindFirst() then
                            Error(ExcelRowColErr, RowNumPar, ColumnNumPar);

                    end;
                end;
            AcctTypePar::Employee:
                begin
                    if AcctNumLPar <> '' then begin
                        if not Employee.Get(AcctNumLPar) then
                            ErrorFound := true;

                    end else begin
                        Employee.Reset;
                        Employee.Setrange("First Name", AcctNamePar);
                        if not Employee.FindFirst() then
                            Error(ExcelRowColErr, RowNumPar, ColumnNumPar);

                    end;
                end;
            AcctTypePar::"Bank Account":
                begin
                    if AcctNumLPar <> '' then begin
                        if not Bank.Get(AcctNumLPar) then
                            ErrorFound := true;

                    end else begin
                        Bank.Reset;
                        Bank.Setrange(Name, AcctNamePar);
                        if not Bank.FindFirst() then
                            Error(ExcelRowColErr, RowNumPar, ColumnNumPar);

                    end;
                end;
            AcctTypePar::"Fixed Asset":
                begin
                    if AcctNumLPar <> '' then begin
                        if not FixedAsset.Get(AcctNumLPar) then
                            ErrorFound := true;

                    end else begin
                        FixedAsset.Reset;
                        FixedAsset.Setrange(Description, AcctNamePar);
                        if not FixedAsset.FindFirst() then
                            Error(ExcelRowColErr, RowNumPar, ColumnNumPar);

                    end;
                end;

        end;

        exit(ErrorFound);

    end;

    Procedure GetAcctNum(AcctTypePar: Enum "Gen. Journal Account Type"; AcctNamePar: Text[100]): Code[20]

    Var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;


    begin
        Case AcctTypePar of
            AcctTypePar::"G/L Account":
                begin
                    GLAcc.Reset;
                    GLAcc.Setrange(Name, AcctNamePar);
                    if GLAcc.FindFirst() then
                        exit(GLAcc."No.");
                end;
            AcctTypePar::Customer:
                begin
                    Cust.Reset;
                    Cust.Setrange(Name, AcctNamePar);
                    if Cust.FindFirst() then
                        exit(Cust."No.");
                end;
            AcctTypePar::Vendor:
                begin
                    Vend.Reset;
                    Vend.Setrange(Name, AcctNamePar);
                    if Vend.FindFirst() then
                        exit(Vend."No.");
                end;
            AcctTypePar::Employee:
                begin
                    Employee.Reset;
                    Employee.Setrange("First Name", AcctNamePar);
                    if Employee.FindFirst() then
                        exit(Employee."No.");
                end;
            AcctTypePar::"Bank Account":
                begin
                    Bank.Reset;
                    Bank.Setrange(Name, AcctNamePar);
                    if Bank.FindFirst() then
                        exit(Bank."No.");
                end;
            AcctTypePar::"Fixed Asset":
                begin
                    FixedAsset.Reset;
                    FixedAsset.Setrange(Description, AcctNamePar);
                    if FixedAsset.FindFirst() then
                        exit(FixedAsset."No.");
                end;
        end;
    end;


    procedure CheckDimension(DimVal1: Code[20]; DimVal2: Code[20]; RowNumPar: integer)
    begin
        GeneralLedgerSetup.get;
        if DimVal1 <> '' then
            if not DimensionValue.get(GeneralLedgerSetup."Global Dimension 1 Code", DimVal1) then
                Error(ExcelRowColErr, RowNumpar, 11);

        if DimVal2 <> '' then
            if not DimensionValue.get(GeneralLedgerSetup."Global Dimension 2 Code", DimVal2) then
                Error(ExcelRowColErr, RowNumPar, 12);





    end;






    var
        GenJnlLineRec: Record "Gen. Journal Line";
        GenJnlTemplateRec: Record "Gen. Journal Template";
        GenJnlBatchRec: REcord "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        ReasonCodeRec: REcord "Reason Code";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";

        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PostingDate: Date;
        DocumentNum: code[20];
        AccountNum: Code[20];
        AmountVar: Decimal;
        BalAccountNum: Code[20];
        AccountName: Text[100];
        BalAccountName: Text[100];
        AcctTypeVar: Enum "Gen. Journal Account Type";
        BalAcctTypeVar: Enum "Gen. Journal Account Type";
        GD1Code: Code[20];
        GD2Code: Code[20];
        LineDesc: Text[100];
        ReasonCode: code[10];


        AppliesToDocNum: code[20];

        ExcelBuffer: Record "Excel Buffer";
        TotalRows: Integer;
        ExcelBuffer1: Record "Excel Buffer";


        SheetName: Text;



        ImportMsg: Label 'Journal Template Name %1 Batch Name %2 lines are Created';
        ExcelRowColErr: Label 'Importing Data check Row %1 and Column No. %2';
        PostingMsg: Label 'Journal Template Name %1 Batch Name %2 lines are successfully posted';
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';

        LineNum: Integer;

        TotalColumns: Integer;
        FileName: Text;


    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);

        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        ExcelBuffer.OpenBookStream(IStream, SheetName);
        ExcelBuffer.ReadSheet();
    end;























}

