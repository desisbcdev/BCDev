codeunit 50001 "Purchase Event"
{
    trigger OnRun()
    begin

    end;

    var

        TotalAmountExclVATLbl: Label 'Total Excl. GST';
        TotalVATLbl: Label 'Total GST';
        TotalAmountInclVatLbl: Label 'Total Incl. GST';
        TotalLineAmountLbl: Label 'Subtotal';
        TotalLineAmountVat: Label ' Excl. VAT';
        TotalLineAmountGst: Label ' Excl. GST';


    // OnBeforeFinalizePosting

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure UpdatePOStatusType(var PurchaseHeader: Record "Purchase Header"; var EverythingInvoiced: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
    begin

        if not ((PurchaseHeader."Cancel Shortclose Appr. Status" = PurchaseHeader."Cancel Shortclose Appr. Status"::Cancelled) or
        (PurchaseHeader."Cancel Shortclose Appr. Status" = PurchaseHeader."Cancel Shortclose Appr. Status"::"Short Closed"))
        and
        (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order)
         then begin

            if EverythingInvoiced then begin
                PurchaseHeader."Status Type" := PurchaseHeader."Status Type"::"Completely Invoiced";
                PurchaseHeader.modify;
            end else begin
                PurchaseLine.reset;
                PurchaseLine.setrange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.setrange("Document No.", PurchaseHeader."No.");
                PurchaseLine.setfilter("Quantity Invoiced", '<>%1', 0);
                if PurchaseLine.FindFirst then begin
                    PurchaseHeader."Status Type" := PurchaseHeader."Status Type"::"Partially Invoiced";
                    PurchaseHeader.Modify()
                end else begin
                    if CheckFullyReceived(PurchaseHeader) then begin
                        PurchaseHeader."Status Type" := PurchaseHeader."Status Type"::"Fully Received Not Invoiced";
                        PurchaseHeader.Modify();
                    end else begin
                        PurchaseHeader."Status Type" := PurchaseHeader."Status Type"::"Partially Received";
                        PurchaseHeader.Modify();
                    end;

                end;


            end;
        end;
    end;

    procedure CheckFullyReceived(var PurchaseHeader: Record "Purchase Header"): boolean

    var
        PurchaseLine: Record "Purchase Line";
        EverythingReceived: Boolean;

    begin
        EverythingReceived := true;
        PurchaseLine.Reset;
        PurchaseLine.Setrange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.Setrange("Document No.", PurchaseHeader."No.");
        PurchaseLine.Setfilter(Quantity, '<>%1', 0);
        if PurchaseLine.FindFirst then begin
            repeat
                if PurchaseLine.Quantity <> (PurchaseLine."Quantity Received" + PurchaseLine."Qty. to Receive") then
                    EverythingReceived := false;
            until PurchaseLine.Next = 0;
        end;
        exit(EverythingReceived);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnFinalizePostingOnBeforeUpdateAfterPosting', '', false, false)]
    local procedure UpdateStatusPurchaseOrder(var PurchHeader: Record "Purchase Header")
    var

        PurchaseLine: Record "Purchase Line";
        PurchaseOrderLine: Record "Purchase Line";
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        PurchaseOrderHeader: Record "Purchase Header";

    begin
        if not ((PurchHeader."Cancel Shortclose Appr. Status" = PurchHeader."Cancel Shortclose Appr. Status"::Cancelled) or
        (PurchHeader."Cancel Shortclose Appr. Status" = PurchHeader."Cancel Shortclose Appr. Status"::"Short Closed"))
        and
        (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) then begin

            PurchaseLine.Reset;
            PurchaseLine.setrange("Document Type", PurchHeader."Document Type");
            PurchaseLine.setrange("Document No.", PurchHeader."No.");
            PurchaseLine.Setfilter(Quantity, '<>%1', 0);
            PurchaseLine.Setfilter("Receipt No.", '<>%1', '');
            if PurchaseLine.FindSet then begin
                repeat
                    if PurchReceiptLine.Get(PurchaseLine."Receipt No.", PurchaseLine."Receipt Line No.") then begin
                        if PurchaseOrderLine.Get(PurchaseOrderLine."Document Type"::Order, PurchReceiptLine."Order No.", PurchReceiptLine."Order Line No.") then begin
                            CheckFullyInvoiced(PurchaseOrderLine);
                        end;
                    end;
                until PurchaseLine.Next = 0;
            end;

        end;
    end;


    procedure CheckFullyInvoiced(PurchaseLinePar: Record "Purchase Line")

    var
        PurchaseOrderLine: Record "Purchase Line";
        PurchaseOrderHeader: Record "Purchase Header";
        AllLinesInvoiced: Boolean;

    begin
        AllLinesInvoiced := true;
        PurchaseOrderLine.Reset;
        PurchaseOrderLine.Setrange("Document Type", PurchaseLinePar."Document Type");
        PurchaseOrderLine.Setrange("Document No.", PurchaseLinePar."Document No.");
        PurchaseOrderLine.Setfilter(Quantity, '<>%1', 0);
        if PurchaseOrderLine.FindFirst then begin
            repeat
                if PurchaseOrderLine.Quantity <> PurchaseOrderLine."Quantity Invoiced" then
                    AllLinesInvoiced := false;
            until PurchaseOrderLine.Next = 0;
        end;

        if PurchaseOrderHeader.Get(PurchaseLinePar."Document Type"::Order, PurchaseLinePar."Document No.") then begin
            if AllLinesInvoiced then
                PurchaseOrderHeader."Status Type" := PurchaseOrderHeader."Status Type"::"Completely Invoiced"
            else
                PurchaseOrderHeader."Status Type" := PurchaseOrderHeader."Status Type"::"Partially Invoiced";
            PurchaseOrderHeader.Modify;
        end;




    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Line CaptionClass Mgmt", 'OnGetPurchaseLineCaptionClass', '', false, false)]
    local procedure ChangeCustomizedCaption(FieldNumber: Integer; PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; var Caption: Text; var PurchaseLine: Record "Purchase Line"
       )
    var
        DirectUnitCostInclGST: Label 'Direct Unit Cost Incl. GST';
        DirectUnitCostExclGST: Label 'Direct Unit Cost Excl. GST';
        LineAmtInclGST: Label 'Line Amount Incl. GST';
        LineAmtExclGST: Label 'Line Amount Excl. GST';
    begin


        Case FieldNumber of
            PurchaseLine.FieldNo("Direct Unit Cost"):
                begin
                    if PurchaseHeader."Prices Including VAT" then
                        Caption := DirectUnitCostInclGST
                    else
                        Caption := DirectUnitCostExclGST;
                    IsHandled := true;

                end;

            PurchaseLine.FieldNo("Line Amount"):
                begin
                    if PurchaseHeader."Prices Including VAT" then
                        Caption := LineAmtInclGST
                    else
                        Caption := LineAmtExclGST;
                    IsHandled := true;

                end;


        end;


    end;

    procedure GetTotalVATCaption(CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionClassWithCurrencyCode(TotalVATLbl, CurrencyCode));
    end;

    procedure GetTotalInclVATCaption(CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionClassWithCurrencyCode(TotalAmountInclVatLbl, CurrencyCode));
    end;

    procedure GetTotalExclVATCaption(CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionClassWithCurrencyCode(TotalAmountExclVATLbl, CurrencyCode));
    end;

    procedure GetTotalLineAmountWithVATAndCurrencyCaption(CurrencyCode: Code[10]; IncludesVAT: Boolean): Text
    begin
        exit(GetCaptionWithCurrencyCode(CaptionClassTranslate(GetCaptionWithVATInfo(TotalLineAmountLbl, IncludesVAT)), CurrencyCode));
    end;

    local procedure GetCaptionWithVATInfo(CaptionWithoutVATInfo: Text; IncludesVAT: Boolean): Text
    begin
        if IncludesVAT then
            exit(CaptionWithoutVATInfo + TotalLineAmountVat);

        exit(CaptionWithoutVATInfo + TotalLineAmountGst);
    end;

    local procedure GetCaptionClassWithCurrencyCode(CaptionWithoutCurrencyCode: Text; CurrencyCode: Code[10]): Text
    begin
        exit('3,' + GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode, CurrencyCode));
    end;

    local procedure GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode: Text; CurrencyCode: Code[10]): Text
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if CurrencyCode = '' then begin
            GLSetup.Get();
            CurrencyCode := GLSetup.GetCurrencyCode(CurrencyCode);
        end;

        if CurrencyCode <> '' then
            exit(CaptionWithoutCurrencyCode + StrSubstNo(' (%1)', CurrencyCode));

        exit(CaptionWithoutCurrencyCode);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertPaymentterms(var Rec: Record "Purchase Header")
    Var
        PaymentTermsAndConditions: Record "Payment Terms And Conditions";
        PaymentTermsSetup: Record "Payment Terms Conditions";
        LineNo: Integer;
    begin
        LineNo := 10000;
        if Rec."Document Type" = rec."Document Type"::Order then begin
            PaymentTermsSetup.Reset();
            PaymentTermsSetup.SetRange("Order Type", Rec."Order Type");
            if PaymentTermsSetup.FindSet then begin
                repeat

                    PaymentTermsAndConditions.Init();
                    PaymentTermsAndConditions.DocumentType := PaymentTermsAndConditions.DocumentType::Order;
                    PaymentTermsAndConditions.DocumentNo := Rec."No.";
                    PaymentTermsAndConditions.LineNo := LineNo;
                    PaymentTermsAndConditions.Sequence := PaymentTermsSetup.Sequence;
                    PaymentTermsAndConditions."Order Type" := Rec."Order Type";
                    PaymentTermsAndConditions.LineType := PaymentTermsSetup."Line Type";
                    PaymentTermsAndConditions.Description := PaymentTermsSetup.Description;

                    PaymentTermsAndConditions.Insert();
                    LineNo += 10000;
                until PaymentTermsSetup.Next = 0;
            end;
        end;




    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer);
    begin
        HideDialog := true;
        NewConfirmPost(PurchaseHeader);
    end;

    local procedure NewConfirmPost(var PurchaseHeader: Record "Purchase Header"): Boolean
    var
        Selection: Integer;
        ConfirmManagement: Codeunit "Confirm Management";
        // ShipInvoiceQst: Label '&Receive ,&Invoice ,Receive &and Invoice';
        ShipInvoiceQst: Label '&Receive';
        PostConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
        ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
        NothingToPostErr: Label 'There is nothing to post.';
        DocCancelShortErr: Label 'Document already %1';
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    if (PurchaseHeader."Cancel Shortclose Appr. Status" = PurchaseHeader."Cancel Shortclose Appr. Status"::Cancelled) or
                       (PurchaseHeader."Cancel Shortclose Appr. Status" = PurchaseHeader."Cancel Shortclose Appr. Status"::"Short Closed") then
                        Error(DocCancelShortErr, PurchaseHeader."Cancel Shortclose Appr. Status");
                    Selection := StrMenu(ShipInvoiceQst, 1);
                    PurchaseHeader.Receive := Selection in [1, 1];
                    //PurchaseHeader.Invoice := Selection in [2, 3];
                    if Selection = 0 then
                        exit(false);
                end

            else
                if not ConfirmManagement.GetResponseOrDefault(
                     StrSubstNo(PostConfirmQst, LowerCase(Format(PurchaseHeader."Document Type"))), true)
                then
                    exit(false);
        end;
        PurchaseHeader."Print Posted Documents" := false;
        exit(true);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure NoSeries(VAR PurchHeader: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; VAR NoSeriesCode: Code[20])
    begin


        CASE PurchHeader."Document Type" OF


            PurchHeader."Document Type"::Order:
                begin
                    if PurchHeader."Order Type" = PurchHeader."Order Type"::"Work Order" THEN begin
                        PurchSetup.Testfield("Work Order No. Series");
                        NoSeriesCode := PurchSetup."Work Order No. Series";
                    end else
                        if PurchHeader."Order Type" = PurchHeader."Order Type"::"AMC Order" THEN begin
                            PurchSetup.Testfield("AMC Order No. Series");
                            NoSeriesCode := PurchSetup."AMC Order No. Series";

                        end else
                            if PurchHeader."Order Type" = PurchHeader."Order Type"::"Maintenance Contract" THEN begin
                                PurchSetup.Testfield("Maintenancecontract No. Series");
                                NoSeriesCode := PurchSetup."Maintenancecontract No. Series";
                            end;
                end;


        END;




    end;

    [EventSubscriber(ObjectType::Table, database::"Purch. Rcpt. Line", 'OnInsertInvLineFromRcptLineOnBeforeValidateQuantity', '', false, false)]
    local procedure OnInsertInvLineFromRcptLineOnBeforeValidateQuantity(PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        PurchaseHeader: Record "Purchase Header";
        PurChaseReceiptHeader: Record "Purch. Rcpt. Header";
        PoType: Option;
    begin
        PurChaseReceiptHeader.Reset();
        PurChaseReceiptHeader.setrange("No.", PurchRcptLine."Document No.");
        if PurChaseReceiptHeader.FindFirst() then begin
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
            PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
            if PurchaseHeader.FindFirst() then begin
                if PurchaseHeader."Order Type" = PurchaseHeader."Order Type"::" " then begin
                    PurchaseHeader."Order Type" := PurChaseReceiptHeader."Order Type";
                    PurchaseHeader.Modify();
                end;
            end;
        end;


    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Dimensions", 'OnBeforeCheckPurchDim', '', false, false)]
    local procedure PurchaseOrderSkipDimension(var IsHandled: Boolean; PurchaseHeader: Record "Purchase Header")
    begin

        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            IsHandled := true;



    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Tax", 'OnAfterValidatePurchaseLineFields', '', false, false)]
    local procedure HandlePurchaseUseCaseCust(var PurchaseLine: Record "Purchase Line")


    begin

        Clear(CurrAmt);
        Clear(PreviousInvAmount);
        Clear(ConcessionalCodeVar);

        TaxTransactionValue.Reset;
        TaxTransactionValue.Setrange("Tax Record ID", PurchaseLine.RecordId);
        TaxTransactionValue.Setrange("Value Type", TaxTransactionValue."Value Type"::ATTRIBUTE);
        TaxTransactionValue.Setrange("Value ID", 28);
        if TaxTransactionValue.FindFirst() then
            ConcessionalCodeVar := TaxTransactionValue."Column Value"
        else
            ConcessionalCodeVar := '';

        TaxTransactionValue.Reset;
        TaxTransactionValue.Setrange("Tax Record ID", PurchaseLine.RecordId);
        TaxTransactionValue.Setrange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.Setrange("Value ID", 1);
        TaxTransactionValue.setrange("Tax Type", 'TDS');
        if TaxTransactionValue.FindFirst() then
            TDSRateVar := TaxTransactionValue.Percent
        else
            TDSRateVar := 0;

        PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
        if (PurchaseHeader."Posting Date" <> 0D) and (PurchaseLine."TDS Section Code" <> '') and (ConcessionalCodeVar <> '') then begin
            StDate := DMY2DATE(1, 4, DATE2DMY(PurchaseHeader."Posting Date", 3));
            IF DATE2DMY(PurchaseHeader."Posting Date", 2) IN [1 .. 3] THEN
                StDate := DMY2DATE(1, 4, DATE2DMY(PurchaseHeader."Posting Date", 3) - 1);
            EndDate := DMY2DATE(31, 3, DATE2DMY(StDate, 3) + 1);

            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code", Applied);

            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", PurchaseLine."Buy-from Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee PAN No.", Vendor."P.A.N. No.");
            TDSEntry.SetRange("Posting Date", StDate, EndDate);
            TDSEntry.SETRANGE(Section, PurchaseLine."TDS Section Code");
            TDSEntry.SetRange("Concessional Code", ConcessionalCodeVar);
            TDSEntry.SETRANGE(Applied, FALSE);
            IF TDSEntry.FindSet() THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount");
                PreviousInvAmount := ABS(TDSEntry."Invoice Amount");
            END;

            PurchaseLineRec2.reset;
            PurchaseLineRec2.setrange("Document Type", PurchaseLine."Document Type");
            PurchaseLineRec2.setrange("Document No.", PurchaseLine."Document No.");
            PurchaseLineRec2.setfilter(Quantity, '<>%1', 0);
            PurchaseLineRec2.SetFilter("Line No.", '<>%1', PurchaseLine."Line No.");
            PurchaseLineRec2.setrange("TDS Section Code", PurchaseLine."TDS Section Code");
            if PurchaseLineRec2.FindSet then
                repeat
                    CurrAmt += PurchaseLineRec2."Line Amount";
                until PurchaseLineRec2.Next = 0;



            TDSConcessionalCodeRec.Reset();
            TDSConcessionalCodeRec.SetRange("Vendor No.", PurchaseLine."Buy-from Vendor No.");
            TDSConcessionalCodeRec.SetRange(Section, PurchaseLine."TDS Section Code");
            TDSConcessionalCodeRec.SetRange("Concessional Code", ConcessionalCodeVar);
            TDSConcessionalCodeRec.SetRange("Concession Status", TDSConcessionalCodeRec."Concession Status"::Open);
            if TDSConcessionalCodeRec.FindFirst() then
                if (PreviousInvAmount + CurrAmt + PurchaseLine."Line Amount") > TDSConcessionalCodeRec."Concession Limit amount" then
                    Message(TDSConsessionalMsg, Vendor.Name, TDSConcessionalCodeRec.Section, TDSRateVar,
                       TDSConcessionalCodeRec."Concession Limit amount");


        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"GST Purchase Subscribers", 'OnBeforePurchaseLineHSNSACEditable', '', false, false)]
    local procedure PurchaseLineHSNCodeEditable(PurchaseLine: Record "Purchase Line"; var IsEditable: Boolean; var IsHandled: Boolean)
    var

        PurchaseHeaderLRec: Record "Purchase Header";
    begin


        if PurchaseHeaderLRec.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") and
             (PurchaseHeaderLRec.Status = PurchaseHeaderLRec.Status::Released) and
             (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) and (PurchaseLine."Quantity Received" = 0) then begin
            IsHandled := true;
            IsEditable := true;

        end;


    end;


    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeTestStatusOpen', '', false, false)]
    local procedure GSTGroupCodeSelection(var IsHandled: Boolean; CallingFieldNo: Integer; var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")


    begin

        if (PurchaseHeader.Status = PurchaseHeader.Status::Released) and (CallingFieldNo = 18080) and
             (PurchaseLine."Quantity Received" = 0) then
            IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure GenJnlCopyfromPurchase(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Vendor Invoice Date" := PurchaseHeader."Vendor Invoice Date";
        GenJournalLine."PI Date" := PurchaseHeader."PI Date";

    end;





    Var

        TDSEntry: record "TDS Entry";
        Vendor: Record Vendor;
        PreviousInvAmount: Decimal;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLineRec2: Record "Purchase Line";
        TDSSectionRec: Record "TDS Section";
        TaxTransactionValue: Record "Tax Transaction Value";
        TDSConcessionalCodeRec: Record "TDS Concessional Code";
        StDate: Date;
        EndDate: Date;
        CurrAmt: Decimal;
        ConcessionalCodeVar: Code[20];
        TDSRateVar: Decimal;

        TDSConsessionalMsg: Label 'Vendor: %1 has TDS Lower deduction certificate under %2 at %3 with a limit of %4 for current FY';




}