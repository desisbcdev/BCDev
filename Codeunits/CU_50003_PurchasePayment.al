codeunit 50003 PurchasePayment
{
    trigger OnRun()
    begin

    end;

    var

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure CreatePaymentJnl(PurchInvHdrNo: Code[20]; var PurchaseHeader: Record "Purchase Header")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlManagement: Codeunit GenJnlManagement;


    begin

        if ((PurchInvHdrNo <> '') and
             ((PurchaseHeader."Payment Terms Code" = '') or (PurchaseHeader."Payment Terms Code" = '0D'))) then begin
            clear(GenJnlManagement);
            VendorLedgerEntry.reset;
            VendorLedgerEntry.setrange("Document type", VendorLedgerEntry."Document Type"::Invoice);
            VendorLedgerEntry.setrange("Document No.", PurchInvHdrNo);
            if VendorLedgerEntry.FindFirst then begin
                GetBatchRecord(GenJournalBatch);
                MakeGenJnlLines(VendorLedgerEntry);
                // GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch);
            end;


        end;


    end;

    local procedure GetBatchRecord(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        PurchasePaySetUp: Record "Purchases & Payables Setup";

    begin
        PurchasePaySetUp.Get;
        PurchasePaySetUp.TestField("Payment Journal Template Name");
        PurchasePaySetUp.TestField("Payment Journal Batch Name");

        JournalTemplateName := PurchasePaySetUp."Payment Journal Template Name";//CreatePayment.GetTemplateName;
        JournalBatchName := PurchasePaySetUp."Payment Journal Batch Name";//CreatePayment.GetBatchNumber;

        GenJournalTemplate.Get(JournalTemplateName);
        GenJournalBatch.Get(JournalTemplateName, JournalBatchName);
        SetNextNo(GenJournalBatch."No. Series", true);
    end;

    procedure MakeGenJnlLines(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        GenJnlLine: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        TempPaymentBuffer: Record "Payment Buffer" temporary;
        PaymentAmt: Decimal;
        SummarizePerVend: Boolean;
        VendorLedgerEntryView: Text;
    begin
        TempPaymentBuffer.Reset();
        TempPaymentBuffer.DeleteAll();
        PostingDate := WorkDate();

        VendorLedgerEntryView := VendorLedgerEntry.GetView();
        VendorLedgerEntry.SetCurrentKey("Entry No.");
        if VendorLedgerEntry.Find('-') then
            repeat
                if PostingDate < VendorLedgerEntry."Posting Date" then
                    Error(EarlierPostingDateErr, VendorLedgerEntry."Document Type", VendorLedgerEntry."Document No.");
                if VendorLedgerEntry."Applies-to ID" = '' then begin
                    VendorLedgerEntry.CalcFields("Remaining Amount");
                    TempPaymentBuffer."Vendor No." := VendorLedgerEntry."Vendor No.";
                    TempPaymentBuffer."Currency Code" := VendorLedgerEntry."Currency Code";

                    if VendorLedgerEntry."Payment Method Code" = '' then begin
                        if Vendor.Get(VendorLedgerEntry."Vendor No.") then
                            TempPaymentBuffer."Payment Method Code" := Vendor."Payment Method Code";
                    end else
                        TempPaymentBuffer."Payment Method Code" := VendorLedgerEntry."Payment Method Code";

                    TempPaymentBuffer.CopyFieldsFromVendorLedgerEntry(VendorLedgerEntry);

                    OnUpdateTempBufferFromVendorLedgerEntry(TempPaymentBuffer, VendorLedgerEntry);
                    TempPaymentBuffer."Dimension Entry No." := 0;
                    TempPaymentBuffer."Global Dimension 1 Code" := '';
                    TempPaymentBuffer."Global Dimension 2 Code" := '';
                    TempPaymentBuffer."Dimension Set ID" := VendorLedgerEntry."Dimension Set ID";
                    TempPaymentBuffer."Vendor Ledg. Entry No." := VendorLedgerEntry."Entry No.";
                    TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendorLedgerEntry."Document Type";

                    if CheckCalcPmtDiscGenJnlVend(VendorLedgerEntry."Remaining Amount", VendorLedgerEntry, 0, false) then
                        PaymentAmt := -(VendorLedgerEntry."Remaining Amount" - VendorLedgerEntry."Remaining Pmt. Disc. Possible")
                    else
                        PaymentAmt := -VendorLedgerEntry."Remaining Amount";

                    TempPaymentBuffer.Reset();
                    TempPaymentBuffer.SetRange("Vendor No.", VendorLedgerEntry."Vendor No.");
                    TempPaymentBuffer.SetRange("Vendor Ledg. Entry Doc. Type", TempPaymentBuffer."Vendor Ledg. Entry Doc. Type");
                    if TempPaymentBuffer.Find('-') then begin
                        TempPaymentBuffer.Amount += PaymentAmt;
                        SummarizePerVend := true;
                        TempPaymentBuffer.Modify();
                    end else begin
                        TempPaymentBuffer."Document No." := NextDocNo;
                        NextDocNo := IncStr(NextDocNo);
                        TempPaymentBuffer.Amount := PaymentAmt;
                        TempPaymentBuffer.Insert();
                    end;
                    VendorLedgerEntry."Applies-to ID" := TempPaymentBuffer."Document No.";

                    VendorLedgerEntry."Amount to Apply" := VendorLedgerEntry."Remaining Amount";
                    CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendorLedgerEntry);
                end;
            until VendorLedgerEntry.Next() = 0;

        CopyTempPaymentBufferToGenJournalLines(TempPaymentBuffer, GenJnlLine, SummarizePerVend);
        VendorLedgerEntry.SetView(VendorLedgerEntryView);
        Message(PaymentMessage, GenJnlLine."Document No.");
    end;

    local procedure CopyTempPaymentBufferToGenJournalLines(var TempPaymentBuffer: Record "Payment Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line"; SummarizePerVend: Boolean)
    var
        Vendor: Record Vendor;
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        LastLineNo: Integer;
    begin
        GenJnlLine.LockTable();
        GenJournalBatch.Get(JournalTemplateName, JournalBatchName);
        GenJournalTemplate.Get(JournalTemplateName);
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast then begin
            LastLineNo := GenJnlLine."Line No.";
            GenJnlLine.Init();
        end;

        TempPaymentBuffer.Reset();
        TempPaymentBuffer.SetCurrentKey("Document No.");
        TempPaymentBuffer.SetFilter(
          "Vendor Ledg. Entry Doc. Type", '<>%1&<>%2', TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);
        if TempPaymentBuffer.Find('-') then
            repeat
                with GenJnlLine do begin
                    Init;
                    Validate("Journal Template Name", JournalTemplateName);
                    Validate("Journal Batch Name", JournalBatchName);
                    LastLineNo += 10000;
                    "Line No." := LastLineNo;
                    if TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" = TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Invoice then
                        "Document Type" := "Document Type"::Payment
                    else
                        "Document Type" := "Document Type"::Refund;
                    "Posting No. Series" := GenJournalBatch."Posting No. Series";
                    "Document No." := TempPaymentBuffer."Document No.";
                    "Account Type" := "Account Type"::Vendor;

                    SetHideValidation(true);
                    Validate("Posting Date", PostingDate);
                    Validate("Account No.", TempPaymentBuffer."Vendor No.");

                    if Vendor."No." <> TempPaymentBuffer."Vendor No." then
                        Vendor.Get(TempPaymentBuffer."Vendor No.");
                    Description := Vendor.Name;

                    "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
                    Validate("Bal. Account No.", BalAccountNo);
                    Validate("Currency Code", TempPaymentBuffer."Currency Code");

                    "Message to Recipient" := GetMessageToRecipient(SummarizePerVend, TempPaymentBuffer);
                    "Bank Payment Type" := BankPaymentType;
                    "Applies-to ID" := "Document No.";

                    "Source Code" := GenJournalTemplate."Source Code";
                    "Reason Code" := GenJournalBatch."Reason Code";
                    "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
                    "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
                    "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";

                    Validate(Amount, TempPaymentBuffer.Amount);

                    "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
                    "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";

                    Validate("Payment Method Code", TempPaymentBuffer."Payment Method Code");

                    TempPaymentBuffer.CopyFieldsToGenJournalLine(GenJnlLine);

                    OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine, TempPaymentBuffer);
                    UpdateDimensions(GenJnlLine, TempPaymentBuffer);
                    Insert;
                end;
            until TempPaymentBuffer.Next() = 0;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DimMgt: Codeunit DimensionManagement;
        NewDimensionID: Integer;
        DimSetIDArr: array[10] of Integer;
    begin
        with GenJnlLine do begin
            IF "Dimension Set ID" = 0 then begin
                NewDimensionID := "Dimension Set ID";

                DimBuf.Reset();
                DimBuf.DeleteAll();
                DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.", DimBuf);
                if DimBuf.FindSet then
                    repeat
                        DimVal.Get(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                        TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
                        TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
                        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                        TempDimSetEntry.Insert();
                    until DimBuf.Next() = 0;
                NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
                "Dimension Set ID" := NewDimensionID;

                CreateDim(
                DimMgt.TypeToTableID1("Account Type".AsInteger()), "Account No.",
                DimMgt.TypeToTableID1("Bal. Account Type".AsInteger()), "Bal. Account No.",
                DATABASE::Job, "Job No.",
                DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
                DATABASE::Campaign, "Campaign No.");
                if NewDimensionID <> "Dimension Set ID" then begin
                    DimSetIDArr[1] := "Dimension Set ID";
                    DimSetIDArr[2] := NewDimensionID;
                    "Dimension Set ID" :=
                    DimMgt.GetCombinedDimensionSetID(DimSetIDArr, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                end;
            end;

            DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code",
              "Shortcut Dimension 2 Code");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer" temporary; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    begin
    end;

    local procedure SetNextNo(GenJournalBatchNoSeries: Code[20]; KeepSavedDocumentNo: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if (GenJournalBatchNoSeries = '') then begin
            if not KeepSavedDocumentNo then
                NextDocNo := ''
        end else begin
            GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
            GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
            if GenJournalLine.FindLast then
                NextDocNo := IncStr(GenJournalLine."Document No.")
            else
                NextDocNo := NoSeriesMgt.GetNextNo3(GenJournalBatchNoSeries, PostingDate, false, true);
            Clear(NoSeriesMgt);
        end;
    end;

    procedure CheckCalcPmtDiscGenJnlVend(RemainingAmt: Decimal; OldVendLedgEntry2: Record "Vendor Ledger Entry"; ApplnRoundingPrecision: Decimal; CheckAmount: Boolean): Boolean
    var
        NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
        PaymentToleranceManagement: Codeunit "Payment Tolerance Management";
    begin
        NewCVLedgEntryBuf."Document Type" := NewCVLedgEntryBuf."Document Type"::Payment;
        NewCVLedgEntryBuf."Posting Date" := PostingDate;
        NewCVLedgEntryBuf."Remaining Amount" := RemainingAmt;
        OldCVLedgEntryBuf2.CopyFromVendLedgEntry(OldVendLedgEntry2);
        exit(
          PaymentToleranceManagement.CheckCalcPmtDisc(
            NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, false, CheckAmount));
    end;

    local procedure GetMessageToRecipient(SummarizePerVend: Boolean; TempPaymentBuffer: Record "Payment Buffer" temporary): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompanyInformation: Record "Company Information";
    begin
        if SummarizePerVend then begin
            CompanyInformation.Get();
            exit(CompanyInformation.Name);
        end;

        VendorLedgerEntry.Get(TempPaymentBuffer."Vendor Ledg. Entry No.");
        if VendorLedgerEntry."Message to Recipient" <> '' then
            exit(VendorLedgerEntry."Message to Recipient");

        exit(
          StrSubstNo(
            MessageToRecipientMsg,
            TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
            TempPaymentBuffer."Applies-to Ext. Doc. No."));
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchase-Post Prepayments", 'OnAfterPostPrepayments', '', false, false)]
    local procedure CreatePrePaymentJnl(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlManagement: Codeunit GenJnlManagement;



    begin

        if ((PurchInvHeader."No." <> '') and (PurchHeader."Prepayment %" <> 0)) then begin

            Clear(GenJnlManagement);
            VendorLedgerEntry.reset;
            VendorLedgerEntry.setrange("Document type", VendorLedgerEntry."Document Type"::Invoice);
            VendorLedgerEntry.setrange("Document No.", PurchInvHeader."No.");
            if VendorLedgerEntry.FindFirst then begin
                GetBatchRecord(GenJournalBatch);
                MakeGenJnlLines(VendorLedgerEntry);
                GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch);
            end;


        end;


    end;




    var


        PostingDate: Date;
        BalAccountNo: Code[20];
        NextDocNo: Code[20];
        JournalBatchName: Code[10];
        JournalTemplateName: Code[10];
        BankPaymentType: Enum "Bank Payment Type";
        StartingDocumentNoErr: Label 'The value in the Starting Document No. field must have a number so that we can assign the next number in the series.';
        BatchNumberNotFilledErr: Label 'You must fill the Batch Name field.';
        PostingDateNotFilledErr: Label 'You must fill the Posting Date field.';
        SpecifyStartingDocNumErr: Label 'In the Starting Document No. field, specify the first document number to be used.';
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment = '%1 document type, %2 Document No.';
        EarlierPostingDateErr: Label 'You cannot create a payment with an earlier posting date for %1 %2.', Comment = '%1 - Document Type, %2 - Document No.. You cannot create a payment with an earlier posting date for Invoice INV-001.';
        PaymentMessage: Label 'Journal created Document No. %1';



}