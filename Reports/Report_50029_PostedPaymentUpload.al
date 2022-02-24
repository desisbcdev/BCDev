report 50029 "Posted Payment Upload"
{
    Caption = 'Posted Payment Upload';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    ProcessingOnly = true;


    dataset
    {

        dataitem("Posted Gen. Journal Line"; "Posted Gen. Journal Line")
        {

            RequestFilterFields = "Journal Template Name", "Journal Batch Name";




            trigger OnAfterGetRecord();
            begin


                if "Account Type" = "Account Type"::Employee then
                    CurrReport.skip;

                ExcelBuffer.NewRow();
                LineGetValues();

                ExcelBuffer.AddColumn(ClientCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ProductCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentType, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(DrAcNum, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AmountVar, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(BankCodeIndicator, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryBank, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryBank, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryBranchIFSCCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryAcctNum, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryEMail, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryMobile, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(DebitNarration, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CreditNarration, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

                ExcelBuffer.AddColumn(EnrichmentArr[1], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[2], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[3], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[4], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[1], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[5], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[6], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[7], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[8], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[9], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[10], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[11], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[12], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[13], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[14], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[15], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[16], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[17], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[18], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[19], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[20], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[21], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[22], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EnrichmentArr[23], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                if ExportPaymentLine then begin
                    "Payment Exported" := true;
                    Modify;
                end;




            end;




            trigger OnPostDataItem();
            begin




                ExcelBuffer.CreateNewBook(ReportFileName);
                ExcelBuffer.WriteSheet(ReportFileName, CompanyName, UserId);
                ExcelBuffer.CloseBook();
                ExcelBuffer.SetFriendlyFilename(ReportFileName);
                ExcelBuffer.OpenExcel();




            end;

            trigger OnPreDataItem();
            begin


                ExcelBuffer.DELETEALL;
                CLEAR(ExcelBuffer);
                Setrange("Payment Exported", false);


                ExcelBuffer.AddColumn(ClinetCodeLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ProductCodeLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentTypeLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


                ExcelBuffer.AddColumn(PaymentRefNoLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentDateLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InstrumentDateLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(DrAcNoLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(AmountLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BankCodeIndicatorLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenificiaryCodeLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenificiaryNameLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenificiaryBankLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.AddColumn(BenificiaryBranchLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenificiaryAccNoLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LocationLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PrintLocationLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.AddColumn(InstrumentNumberLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenAdd1Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenAdd2Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenAdd3Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BenAdd4Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryEmailLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(BeneficiaryMobileLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(DebitNarrationLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CreditNarrationLbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentDetails1Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentDetails2Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentDetails3Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PaymentDetails4Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment1Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment2Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment3Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment4Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment5Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment6Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment7Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment8Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment9Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment10Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment11Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment12Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment13Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment14Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment15Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment16Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment17Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment18Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment19Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Enrichment20Lbl, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);









            end;
        }



    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Export)
                {
                    field("Export Payment Line"; ExportPaymentLine)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }
    }

    procedure LineGetValues();

    var
        CompBankAcct: record "Bank Account";
        VendRec: Record Vendor;
        EmployeeRec: record Employee;
        VendorBankAcct: Record "Vendor Bank Account";


    begin
        Clear(ProductCode);
        Clear(PaymentType);

        Clear(PaymentDate);
        Clear(DrAcNum);
        Clear(AmountVar);
        Clear(BeneficiaryName);
        Clear(BeneficiaryBank);
        Clear(BeneficiaryBranchIFSCCode);
        Clear(BeneficiaryAcctNum);
        Clear(BeneficiaryEMail);
        clear(DebitNarration);
        clear(CreditNarration);
        Clear(EnrichmentArr);
        clear(LoopCnt);
        Clear(DDVal);
        Clear(MMVal);
        Clear(ExportDateVar);



        CompBankAcct.Get("Posted Gen. Journal Line"."Bal. Account No.");




        if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::Vendor then begin
            ProductCode := 'RPAY';
            Vendrec.Get("Posted Gen. Journal Line"."Account No.");
            BeneficiaryName := VendRec.Name;
            VendorBankAcct.Get(VendRec."No.", VendRec."Preferred Bank Account Code");

            BeneficiaryBank := VendorBankAcct.Code;
            BeneficiaryBranchIFSCCode := VendorBankAcct."IFSC Code";
            BeneficiaryAcctNum := VendorBankAcct."Bank Account No.";
            BeneficiaryEMail := VendRec."E-Mail";
            BeneficiaryMobile := VendRec."Phone No.";
            if StrLen(VendRec.Name) > 40 then
                DebitNarration := copystr(VendRec.Name, 1, 40)
            else
                DebitNarration := VendRec.Name;

            if (VendorBankAcct.KotakBank) and (CompBankAcct.KotakBank) then
                PaymentType := 'IFT'
            else
                PaymentType := 'NEFT'
        end else
            if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::Employee then begin
                ProductCode := 'SALPAY';
                EmployeeRec.Get("Posted Gen. Journal Line"."Account No.");
                BeneficiaryName := EmployeeRec.FullName();
                /*
                BankAcct.Get(EmployeeRec."Bank Account No.");
                BeneficiaryBank := BankAcct.Name;
                BeneficiaryBranchIFSCCode := BankAcct."IFSC Code";
                BeneficiaryAcctNum := BankAcct."Bank Account No.";
                BeneficiaryEMail := EmployeeRec."E-Mail";
                BeneficiaryMobile := EmployeeRec."Phone No.";
                DebitNarration := EmployeeRec.FullName();
                if BankAcct.KotakBank then
                    PaymentType := 'IFT'
                else
                    PaymentType := 'NEFT'
                    */
            end else begin
                ProductCode := 'VPAY';
            end;

        if Today < "Posted Gen. Journal Line"."Posting Date" then
            ExportDateVar := "Posted Gen. Journal Line"."Posting Date"
        else
            ExportDateVar := Today;




        DDVal := Format(Date2DMY(ExportDateVar, 1));
        if Strlen(DDVal) < 2 then
            DDVal := '0' + DDVal;
        MMVal := Format(Date2DMY(ExportDateVar, 2));
        if Strlen(MMVal) < 2 then
            MMVal := '0' + MMVal;

        PaymentDate := DDVal + '/' + MMVal + Format(ExportDateVar, 0, '/<Year4>');


        DrAcNum := CompBankAcct."Bank Account No.";
        AmountVar := Round(abs("Posted Gen. Journal Line".Amount), 0.01);
        BankCodeIndicator := 'M';
        CreditNarration := 'D E SHAW';

        //Getting Invoice details>>  


        Case "Posted Gen. Journal Line"."Account Type" of
            "Gen. Journal Account Type"::Vendor:
                begin
                    DtldVendorLedgEntry.Reset;
                    DtldVendorLedgEntry.setrange("Vendor No.", "Posted Gen. Journal Line"."Account No.");
                    DtldVendorLedgEntry.SETRANGE("Document No.", "Posted Gen. Journal Line"."Document No.");
                    DtldVendorLedgEntry.SETRANGE("Entry Type", DtldVendorLedgEntry."Entry Type"::Application);
                    DtldVendorLedgEntry.setfilter("Applied Vend. Ledger Entry No.", '<>%1', 0);
                    IF DtldVendorLedgEntry.FINDSET THEN BEGIN
                        REPEAT

                            if DtldVendorLedgEntry."Vendor Ledger Entry No." <> DtldVendorLedgEntry."Applied Vend. Ledger Entry No." then begin

                                if VendorLedgerEntry.Get(DtldVendorLedgEntry."Vendor Ledger Entry No.") then begin
                                    LoopCnt += 1;
                                    EnrichmentArr[LoopCnt] := VendorLedgerEntry."Document No.";
                                end;
                            end;

                        until (DtldVendorLedgEntry.Next = 0) or (LoopCnt = 23);
                    end;


                end;
        //Getting Invoice details<<


        end;


        // Checking Valid values or not >>

        CheckNumericValues(DrAcNum, StrLen(DrAcNum), 'Debit Account');  // Numeric Values allowed



        CheckBeneficiaryValues(BeneficiaryBranchIFSCCode, StrLen(BeneficiaryBranchIFSCCode), VendorBankAcct.FieldCaption(VendorBankAcct."IFSC Code")); //Alpha Numeric Values allowed
        CheckNumericValues(BeneficiaryAcctNum, StrLen(BeneficiaryAcctNum), VendorBankAcct.FieldCaption(VendorBankAcct."Bank Account No."));  // Numeric Values allowed
        CheckNumericValues(BeneficiaryMobile, StrLen(BeneficiaryMobile), VendRec.FieldCaption(Vendrec."Mobile Phone No."));  // Numeric Values allowed

        // Checking Valid values or not <<


    end;


    PROCEDURE CheckNumericValues(TextVal: Code[15]; StrLenVal: Integer; FieldName: Text);
    VAR

        Position: Integer;
        RepCheckCu: Codeunit 50006;
    BEGIN

        FOR Position := 1 TO StrLenVal DO
            RepCheckCu.CheckIsNumeric(TextVal, Position, "Posted Gen. Journal Line"."Line No.", FieldName);


    END;




    PROCEDURE CheckBeneficiaryName(TextVal: Text[160]; StrLenVal: Integer; FieldName: Text);
    VAR

        Position: Integer;
        RepCheckCu: Codeunit 50006;
    BEGIN

        FOR Position := 1 TO StrLenVal DO
            RepCheckCu.CheckIsAlphabet(TextVal, Position, "Posted Gen. Journal Line"."Line No.", FieldName);
    END;


    PROCEDURE CheckBeneficiaryValues(TextVal: Code[100]; StrLenVal: Integer; FieldName: Text);
    VAR

        Position: Integer;
        RepCheckCu: Codeunit 50006;
    BEGIN

        FOR Position := 1 TO StrLenVal DO
            RepCheckCu.CheckIsAlphaNumeric(TextVal, Position, "Posted Gen. Journal Line"."Line No.", FieldName);


    END;




    var
        ExcelBuffer: Record "Excel Buffer";
        ReportFileName: Label 'PostedPaymentUpload';
        ClientCode: Label 'DESHAW';
        ProductCode: Code[10];
        PaymentType: code[10];

        PaymentDate: Text;
        ExportDateVar: Date;

        DrAcNum: code[15];
        AmountVar: Decimal;
        BankCodeIndicator: Code[1];
        BeneficiaryName: Code[160];
        BeneficiaryBank: code[11];

        BeneficiaryBranchIFSCCode: Code[11];

        BeneficiaryAcctNum: code[15];
        BeneficiaryEMail: text[250];
        BeneficiaryMobile: code[10];
        DebitNarration: text[40];
        CreditNarration: Text[40];
        EnrichmentArr: array[23] of Text[200];
        LoopCnt: Integer;
        DtldVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";


        DDVal: Text;
        MMVal: Text;

        ClinetCodeLbl: Label 'Client_Code';
        ProductCodeLbl: Label 'Product_Code';
        PaymentTypeLbl: Label 'Payment_Type';
        PaymentRefNoLbl: Label 'Payment_Ref_No.';
        PaymentDateLbl: Label 'Payment_Date';
        InstrumentDateLbl: Label 'InstrumentDate';
        DrAcNoLbl: Label 'Dr_Ac_No';
        AmountLbl: Label 'Amount';
        BankCodeIndicatorLbl: Label 'Bank_Code_Indicator';
        BenificiaryCodeLbl: Label 'Beneficiary_Code';
        BenificiaryNameLbl: Label 'Beneficiary_Name';
        BenificiaryBankLbl: Label 'Beneficiary_Bank';
        BenificiaryBranchLbl: Label 'Beneficiary_Branch / IFSC Code';
        BenificiaryAccNoLbl: Label 'Beneficiary_Acc_No';
        LocationLbl: Label 'Location';
        PrintLocationLbl: Label 'Print_Location';
        InstrumentNumberLbl: Label 'Instrument_Number';
        BenAdd1Lbl: Label 'Ben_Add1';
        BenAdd2Lbl: Label 'Ben_Add2';
        BenAdd3Lbl: Label 'Ben_Add3';
        BenAdd4Lbl: Label 'Ben_Add4';
        BeneficiaryEmailLbl: Label 'Beneficiary_Email';
        BeneficiaryMobileLbl: Label 'Beneficiary_Mobile';
        DebitNarrationLbl: Label 'Debit_Narration';
        CreditNarrationLbl: Label 'Credit_Narration';
        PaymentDetails1Lbl: Label 'Payment Details 1';
        PaymentDetails2Lbl: Label 'Payment Details 2';
        PaymentDetails3Lbl: Label 'Payment Details 3';
        PaymentDetails4Lbl: Label 'Payment Details 4';
        Enrichment1Lbl: Label 'Enrichment_1';
        Enrichment2Lbl: Label 'Enrichment_2';
        Enrichment3Lbl: Label 'Enrichment_3';
        Enrichment4Lbl: Label 'Enrichment_4';
        Enrichment5Lbl: Label 'Enrichment_5';
        Enrichment6Lbl: Label 'Enrichment_6';

        Enrichment7Lbl: Label 'Enrichment_7';
        Enrichment8Lbl: Label 'Enrichment_8';
        Enrichment9Lbl: Label 'Enrichment_9';
        Enrichment10Lbl: Label 'Enrichment_10';
        Enrichment11Lbl: Label 'Enrichment_11';
        Enrichment12Lbl: Label 'Enrichment_12';
        Enrichment13Lbl: Label 'Enrichment_13';
        Enrichment14Lbl: Label 'Enrichment_14';
        Enrichment15Lbl: Label 'Enrichment_15';
        Enrichment16Lbl: Label 'Enrichment_16';
        Enrichment17Lbl: Label 'Enrichment_17';
        Enrichment18Lbl: Label 'Enrichment_18';
        Enrichment19Lbl: Label 'Enrichment_19';
        Enrichment20Lbl: Label 'Enrichment_20';
        ExportPaymentLine: Boolean;










}

