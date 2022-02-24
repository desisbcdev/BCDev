report 50020 PurchaseOrder2
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseOrder2.rdl';
    Caption = 'Purchase Order2';


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
            column(OthersCaption; OthersCaption)
            {

            }

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
            column(Subject; Subject)
            { }
            column(Vend_Name; vendor.Name)
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
            column(CurrencyValue; CurrencyValue)
            { }
            column(UnitPriceValue; UnitPriceValue)
            { }
            column(RefCap1; RefCap1)
            { }
            column(UserSetup_signature; UserSetup.Signature)
            { }
            column(IndianRupeeCap; IndianRupeeCap)
            { }
            column(DescriptionVAr; DescriptionVAr)
            {

            }
            column(TotalPriceValue; TotalPriceValue)
            {

            }
            column(FrightChargesCap; FrightChargesCap)
            {

            }
            column(CifCap; CifCap)
            {

            }


            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = FIELD("No."), "Document Type" = field("Document Type");
                column(Document_No_; "Document No.")
                {

                }
                column(No_PurchLine; "No.")
                {

                }

                column(Description; "Line Description")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Price__LCY_; "Unit Price (LCY)")
                { }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                { }
                column(AmountInWords; AmountInWords)
                { }
                column(NoText_1; NoText[1])
                { }
                column(NoGvar; NoGvar)
                { }
                column(FrieghtChargeGvar; FrieghtChargeGvar)
                { }
                column(TotalPriceGvar; TotalPriceGvar)
                { }


                trigger OnAfterGetRecord()
                begin
                    Clear(NoGvar);
                    clear(AmountVendor);
                    AmountVendor := TotalAmountInclVAT;
                    ReportCheck.InitTextVariable;
                    ReportCheck.FormatNoText(NoText, AmountVendor, "Purchase Line"."Currency Code");



                    if Type = Type::"Fixed Asset" then begin
                        if FixedAsset.Get("No.") then
                            NoGvar := FixedAsset."Part Number";
                    end else begin
                        NoGvar := "No.";
                    end;


                    if type <> type::"Charge (Item)" then
                        TotalPriceGvar += Quantity * "Direct Unit Cost";



                    if type = type::"Charge (Item)" then begin
                        FrieghtChargeGvar += "Line Amount";
                        CurrReport.Skip();
                    end








                end;


            }
            dataitem("Payment Terms And Conditions"; "Payment Terms And Conditions")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = DocumentNo = FIELD("No."), DocumentType = field("Document Type");
                column(DocumentNo_PTC; DocumentNo)
                { }
                column(LineType_PTC; LineType)
                { }
                column(Description_PTC; Description)
                { }
                trigger OnAfterGetRecord()
                begin
                    CheckGvar := true;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if vendor.get("Buy-from Vendor No.") then;

                RefValue := StrSubstNo(RefCap, "Vendor Quote No", "Vendor Quote Date");


                //UserSetup.CALCFIELDS("Signature");
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);

                IF ApprovalEntry.FINDLAST THEN begin
                    UserSetup.RESET;
                    IF UserSetup.GET(ApprovalEntry."Approver ID") THEN begin
                        UserSetup.CALCFIELDS("Signature");
                    end;
                end;
                if "Currency Code" = '' then
                    TotalPriceValue := StrSubstNo(TotalPriceCap, 'INR')
                else
                    TotalPriceValue := StrSubstNo(TotalPriceCap, "Currency Code");
                if "Currency Code" = '' then begin
                    CurrencyValue := 'Indian Rupees'
                end else begin
                    currency.get("Currency Code");
                    CurrencyValue := currency.Description;
                end;
                if "Report View" = "Report View"::"Po Product" then
                    DescriptionVAr := 'Product Description'
                else
                    DescriptionVAr := 'Description';











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


            end;


        }

    }

    /*     requestpage
        {
            layout
            {
                area(Content)
                {
                    group(GroupName)
                    {
                        field(Name; SourceExpression)
                        {
                            ApplicationArea = All;

                        }
                    }
                }
            } */

    /*    actions
       {
           area(processing)
           {
               action(ActionName)
               {
                   ApplicationArea = All;
               }
           }
       }
   } */

    var
        vendor: Record Vendor;
        RepCheck: Report Check;
        ReportCheck: Codeunit NumbertoText;
        PaymentTerms: Record "Payment Terms And Conditions";
        ApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
        currency: Record Currency;
        FixedAsset: Record "Fixed Asset";
        NoGvar: Code[20];
        CurrencyValue: Text;
        CheckGvar: Boolean;

        NoText: array[2] of text;
        AmountVendor: Decimal;
        AmountInWords: Text;
        FrieghtChargeGvar: Decimal;
        TotalPriceGvar: decimal;
        DearSirCap: Label 'Dear Sir,';
        SubCap: Label 'Sub: Purchase order for ';
        RefCap: label 'Ref: Your E-Mail quote no %1 ,Dated %2 ';
        RefCap1: Label 'With reference to the above subject, we are pleased to place a purchase order as per the following terms and conditions.';
        RefValue: Text;

        PartNoCap: label 'Part Number';
        IndianRupeeCap: Label 'Indian Rupees';
        DescriptionCap: Label 'Description';
        ServiceDurationCap: Label 'Service Duration(Months)';
        QuantityCap: Label 'Qty';
        UnitPriceCap: Label 'Unit Price';
        TotalPriceCap: Label 'Total Price(%1)';
        TotalPriceValue: Text;
        UnitPriceValue: Text;
        PaymentCap: Label '1. Payment';
        DeliveryCap: Label '2. Delivery';
        TaxesCap: Label '3. Taxes ';
        TermsconditionsCap: Label '4. Terms & Conditions';
        BillingAddrCap: Label '5. Billing Address ';
        DeliveryAddrCap: Label '6. Delivery Address ';

        EndTextCap: Label 'Please sign a copy of this letter as a token of your acceptance.';
        OthersCaption: Label 'Others';

        ThankingCap: Label 'Thanking you.';
        YourSincerelyCap: Label 'Yours sincerely,';
        PurchaseorderCap: Label 'PURCHASE ORDER';
        AuthoriseSignatoryCap: Label 'Authorised Signatory';
        FrightChargesCap: Label 'Freight Charges';
        CifCap: Label 'CIF Hyderabad Airport Price';
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
        DescriptionVAr: Text;

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