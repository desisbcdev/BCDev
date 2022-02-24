report 50015 "WorkOrder"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = './WorkOrder.rdl';
    Caption = 'Work Order';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";
            column(No_PurchHdr; "No.")
            { }
            column(Order_Date; "Order Date")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Subject; Subject)
            {

            }
            column(SubCap; SubCap)
            { }
            column(RefCap; RefCap)
            { }
            column(PartNoCap; PartNoCap)
            { }
            column(DescriptionCap; DescriptionCap)
            { }
            column(ServiceDurationCap; ServiceDurationCap)
            { }
            column(QuantityCap; QuantityCap)
            { }
            column(UnitPriceCap; UnitPriceCap)
            { }
            column(PaymentCap; PaymentCap)
            { }
            column(DeliveryCap; DeliveryCap)
            { }
            column(Text001; Text001)
            { }
            column(Text002; Text002)
            { }
            column(Text003; Text003)
            { }
            column(Text004; Text004)
            { }
            column(Text005; Text005)
            { }
            column(Text006; Text006)
            { }
            column(DeliveryAddrCap; DeliveryAddrCap)
            { }
            column(TaxesCap; TaxesCap)
            { }
            column(TermsconditionsCap; TermsconditionsCap)
            { }
            column(BillingAddrCap; BillingAddrCap)
            { }
            column(EndTextCap; EndTextCap)
            { }
            column(ThankingCap; ThankingCap)
            { }
            column(YourSincerelyCap; YourSincerelyCap)
            { }
            column(AuthoriseSignatoryCap; AuthoriseSignatoryCap)
            { }
            column(PurchaseorderCap; PurchaseorderCap)
            { }
            column(DearSirCap; DearSirCap)
            { }
            column(VendName; vendor.Name)
            { }
            column(vendAdd; vendor.Address)
            { }
            column(vendor_Addr2; vendor."Address 2")
            { }
            column(vendor_city; vendor.City)
            { }
            column(vendor_PostCode; vendor."Post Code")
            { }
            column(vendor_countryRegion; vendor."Country/Region Code")
            { }
            column(RefValue; RefValue)
            { }
            column(RefCap1; RefCap1)
            { }
            column(UserSetup_signature; UserSetup.Signature)
            { }
            column(text007; text007)
            { }
            column(text008; text008)
            { }
            column(Text009; Text009)
            { }
            column(OthersCap; OthersCap)
            { }
            column(MaintenanceCap; MaintenanceCap)
            { }
            column(WarrantyCap; WarrantyCap)
            { }
            column(LiquidationDamageCap; LiquidationDamageCap)
            { }
            column(IndianRupeeCap; IndianRupeeCap)
            { }


            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(Document_No_; "Document No.")
                {

                }
                column(No_PurchLine; "No.")
                {

                }

                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Line_Description; "Line Description")
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(Unit_Price__LCY_; "Unit Price (LCY)")
                { }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                { }
                column(AmountInWords; AmountInWords)
                { }
                column(NoText_1; NoText[1])
                { }
                column(item_picture; item.Picture)
                { }
                column(ItemNameCap; ItemNameCap)
                { }
                column(UomCaption; UomCaption)
                { }
                column(RateUomCaption; RateUomCaption)
                { }
                column(AmountCaption; AmountCaption)
                { }
                column(RefImageCap; RefImageCap)
                { }
                column(TotalCap; TotalCap)
                { }
                column(TableCap; TableCap)
                { }
                column(TableValue; TableValue)
                { }
                column(AnnexureCap; AnnexureCap)
                {

                }
                column(TotalAmountInclVAT; TotalAmountInclVAT)
                { }


                trigger OnAfterGetRecord()
                begin
                    if item.get("No.") then;
                    //item.CalcFields(Picture);
                    /*   AmountVendor := TotalAmountInclVAT;

                      RepCheck.InitTextVariable;
                      RepCheck.FormatNoText(NoText, AmountVendor, "Purchase Line"."Currency Code");
                      // AmountInWords := NoText[1]; */
                end;


            }
            trigger OnAfterGetRecord()
            begin
                if vendor.get("Buy-from Vendor No.") then;



                RefValue := StrSubstNo(RefCap, "Vendor Quote No", "Vendor Quote Date");
                TableValue := StrSubstNo(TableCap, "No.");


                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document No.", "No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                IF ApprovalEntry.FINDLAST THEN begin
                    UserSetup.RESET;
                    IF UserSetup.GET(ApprovalEntry."Approver ID") THEN begin
                        UserSetup.CALCFIELDS("Signature");
                    end;
                end;
                clear(Text001);
                Clear(Text002);
                Clear(Text003);
                Clear(Text004);
                clear(Text005);
                Clear(text006);
                Clear(text007);
                Clear(text008);
                clear(Text009);
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");
                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::Payment);
                if PaymentTerms.FindFirst() then
                    Text001 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");
                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::Taxes);
                if PaymentTerms.FindFirst() then
                    Text002 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");
                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::"Terms & Conditions");
                if PaymentTerms.FindFirst() then
                    Text003 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");

                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::Maintenance);
                if PaymentTerms.FindFirst() then
                    Text004 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");

                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::"Billing & Installation Address");
                if PaymentTerms.FindFirst() then
                    Text005 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");
                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::"Delivery & Installation");
                if PaymentTerms.FindFirst() then
                    text006 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");

                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::Warranty);
                if PaymentTerms.FindFirst() then
                    text007 := PaymentTerms.Description;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(DocumentNo, "No.");

                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::"Liquidated Damages");
                if PaymentTerms.FindFirst() then
                    text008 := PaymentTerms.Description;
                PaymentTerms.SetRange(LineType, PaymentTerms.LineType::Others);
                if PaymentTerms.FindFirst() then
                    Text009 := PaymentTerms.Description;



                Clear(TempPurchLine);
                Clear(PurchPost);
                Clear(TotalAmountInclVAT);
                TempPurchLine.DeleteAll();
                TempVATAmountLine.DeleteAll();
                PurchPost.GetPurchLines("Purchase Header", TempPurchLine, 0);
                TempPurchLine.CalcVATAmountLines(0, "Purchase Header", TempPurchLine, TempVATAmountLine);
                TempPurchLine.UpdateVATOnLines(0, "Purchase Header", TempPurchLine, TempVATAmountLine);
                VATAmount := TempVATAmountLine.GetTotalVATAmount();
                VATBaseAmount := TempVATAmountLine.GetTotalVATBase();
                VATDiscountAmount :=
                  TempVATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT() + GSTTot;

                TempPrepmtInvBuf.DeleteAll();
                PurchPostPrepmt.GetPurchLines("Purchase Header", 0, TempPrepmtPurchLine);
                if not TempPrepmtPurchLine.IsEmpty then begin
                    PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header", TempPurchLine);
                    if not TempPurchLine.IsEmpty then
                        PurchPostPrepmt.CalcVATAmountLines("Purchase Header", TempPurchLine, TempPrePmtVATAmountLineDeduct, 1);
                end;
                PurchPostPrepmt.CalcVATAmountLines("Purchase Header", TempPrepmtPurchLine, PrepmtVATAmountLine, 0);
                PrepmtVATAmountLine.DeductVATAmountLine(TempPrePmtVATAmountLineDeduct);
                PurchPostPrepmt.UpdateVATOnLines("Purchase Header", TempPrepmtPurchLine, PrepmtVATAmountLine, 0);
                PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount();
                PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT();


                // amount in words
                clear(AmountVendor);
                AmountVendor := TotalAmountInclVAT;
                ReportCheck.InitTextVariable;
                ReportCheck.FormatNoText(NoText, AmountVendor, "Purchase Header"."Currency Code");
                // Message('%1', NoText[1]);
                //RepCheck.AddToNoText(NoText,NoTextIndex,PrintExponent,(FORMAT(No * DecimalPosition) + '/' + FORMAT(DecimalPosition)));

            end;
        }

    }


    var
        vendor: Record Vendor;
        item: Record Item;
        PaymentTerms: Record "Payment Terms And Conditions";
        RepCheck: Report Check;
        ReportCheck: Codeunit NumbertoText;
        ApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
        NoText: array[2] of Text[200];
        AmountVendor: Decimal;
        AnnexureCap: label 'As per Annexure -1';
        AmountInWords: Text;
        TableCap: Label 'Annexure - I for WO no-%1';
        TableValue: Text;
        DearSirCap: Label 'Dear Sir,';
        SubCap: Label 'Sub: Work order for ';
        RefCap: label 'Ref: Your E-Mail quote no %1 ,Dated %2 ';
        RefCap1: Label 'With reference to the above subject, we are pleased to place a Work order as per the following terms and conditions.';
        RefValue: Text;
        PartNoCap: label 'Sl No.';
        IndianRupeeCap: Label 'Indian Rupees';
        DescriptionCap: Label 'Description';
        ServiceDurationCap: Label 'Service Duration(Months)';
        QuantityCap: Label 'Qty';
        UnitPriceCap: Label 'Total Price(INR)';
        ItemNameCap: Label 'Item Name';
        TotalCap: Label 'Total';
        UomCaption: Label 'UOM';
        RefImageCap: Label 'Ref.Image';
        WarrantyCap: Label '7. Warranty';
        text007: Text;
        LiquidationDamageCap: label '8. Liquidated Damages';
        text008: Text;
        Text009: Text;
        OthersCap: Label '9. Others';
        RateUomCaption: Label 'Rate/UOM';
        AmountCaption: Label 'Amount(INR)';
        PaymentCap: Label '1. Payment';
        Text001: Text;
        DeliveryCap: Label '6. Delivery and Installation';
        text006: Text;
        MaintenanceCap: Label '4. Maintenance';
        Text002: Text;
        TaxesCap: Label '2. Taxes ';
        Text003: Text;
        TermsconditionsCap: Label '3. Terms & Conditions ';
        Text004: Text;
        BillingAddrCap: Label '5. Billing & Installation Address ';
        Text005: Text;
        DeliveryAddrCap: Label '6. Delivery Address ';


        EndTextCap: Label 'Please sign a copy of this letter as a token of your acceptance.';
        ThankingCap: Label 'Thanking you.';
        YourSincerelyCap: Label 'Yours sincerely,';
        PurchaseorderCap: Label 'WORK ORDER';
        AuthoriseSignatoryCap: Label 'Authorised Signatory';
        TempPrepmtPurchLine: Record "Purchase Line" temporary;
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";

        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line";
        TempPrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        PrepmtDimSetEntry: Record "Dimension Set Entry";
        TempPrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";

        PurchCountPrinted: Codeunit "Purch.Header-Printed";
        FormatAdd: Codeunit "Format Address";
        PurchPost: Codeunit "Purch.-Post";
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        TDSCompAmount: array[20] of Decimal;
        CessAmount: Decimal;
        GSTComponentCodeName: array[20] of Code[20];
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopy: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        DimText: Text[120];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        TDSAmt: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        OtherTaxesAmount: Decimal;
        GSTTot: Decimal;
        ChargesAmount: Decimal;
        [InDataSet]
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalTaxAmount: Decimal;
        GLAccountNo: Code[20];
        TotalGSTAmount: Decimal;
        IsGSTApplicable: Boolean;
        PrepmtLoopLineNo: Integer;
        VatAmtSpecLbl: Label 'VAT Amount Specification in ';
        LocalCurrencyLbl: Label 'Local Currency';
        ExchangeRateLbl: Label 'Exchange rate: %1/%2', Comment = '%1 = Relational Exch. Rate Amount %2 = Exchange Rate Amount';
        TotalIncTaxLbl: Label 'Total %1 Incl. Taxes', Comment = '%1 Total Inc Tax';
        TotalExclTaxLbl: Label 'Total %1 Excl. Taxes', Comment = '%1 Total Excl Tax';
        PurchLbl: Label 'Purchaser';
        TotalLbl: Label 'Total %1', Comment = '%1 Total';
        CopyLbl: Label 'COPY';
        OrderLbl: Label 'Order %1', Comment = '%1 Order';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        OrderNoCaptionLbl: Label 'Order No.';
        PageCaptionLbl: Label 'Page';
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        DirectUnitCostCaptionLbl: Label 'Direct Unit Cost';
        DiscPercentCaptionLbl: Label 'Discount %';
        AmtCaptionLbl: Label 'Amount';
        LineDiscAmtCaptionLbl: Label 'Line Discount Amount';
        AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';
        SubtotalCaptionLbl: Label 'Subtotal';
        TaxAmtCaptionLbl: Label 'Tax Amount';
        OtherTaxesAmtCaptionLbl: Label 'Other Taxes Amount';
        ChrgsAmtCaptionLbl: Label 'Charges Amount';
        TotalTDSIncleSHECessCaptionLbl: Label 'Total TDS Amount';
        VATDiscAmtCaptionLbl: Label 'Payment Discount on VAT';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        PmtDetailsCaptionLbl: Label 'Payment Details';
        VendNoCaptionLbl: Label 'Vendor No.';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        DescCaptionLbl: Label 'Description';
        GLAccNoCaptionLbl: Label 'G/L Account No.';
        PrepmtSpecCaptionLbl: Label 'Prepayment Specification';
        PrepmtVATAmtSpecCaptionLbl: Label 'Prepayment VAT Amount Specification';
        PrepmtVATIdentCaptionLbl: Label 'VAT Identifier';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        VATPercentCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentCaptionLbl: Label 'VAT Identifier';
        TotalCaptionLbl: Label 'Total';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        ShpMethodDescCaptionLbl: Label 'Shipment Method';
        PrepmtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms';
        DocDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        CompanyRegistrationLbl: Label 'Company Registration No.';
        VendorRegistrationLbl: Label 'Vendor GST Reg No.';




}