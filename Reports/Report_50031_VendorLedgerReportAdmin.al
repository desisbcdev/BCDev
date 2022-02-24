report 50031 "Vendor Ledger Report Admin"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './VendorLedgerReportAdmin.rdl';
    Caption = 'Vendor Ledger Report For Admin';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;
            column(No_Vendor; "No.")
            {

            }
            column(VoucherTypeCap; VoucherTypeCap)
            { }
            column(VoucherNumberCap; VoucherNumberCap)
            { }
            column(VoucherDateCap; VoucherDateCap)
            { }
            column(InvoiceNumberCap; InvoiceNumberCap)
            { }
            column(InvoicedateCap; InvoicedateCap)
            { }
            column(BaseAmountCap; BaseAmountCap)
            { }
            column(TaxAmountCap; TaxAmountCap)
            { }
            column(GrossAmountCap; GrossAmountCap)
            { }
            column(TDSRateCap; TDSRateCap)
            { }
            column(TDSAmountCap; TDSAmountCap)
            { }
            column(PaymentRefDetailsCap; PaymentRefDetailsCap)
            { }
            column(NetpayableCap; NetpayableCap)
            { }
            column(CgstCap; CgstCap)
            { }
            column(SgstCap; SgstCap)
            { }
            column(IgstCap; IgstCap)
            { }
            column(TransactionNumberCap; TransactionNumberCap)
            { }
            column(TransactionDateCap; TransactionDateCap)
            { }
            column(TransactionAmountCap; TransactionAmountCap)
            { }
            column(VendorLedgReportCap; VendorLedgReportCap)
            { }
            column(CompanyInfo_picture; CompanyInfo.Picture)
            { }
            column(PoNoCap; PoNoCap)
            { }
            column(PoDateCap; PoDateCap)
            { }
            column(VendorNoCap; VendorNoCap)
            { }
            column(VendorNameCap; VendorNameCap)
            { }
            column(SubjectCap; SubjectCap)
            { }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLinkReference = Vendor;
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = WHERE("Document Type" = CONST(Invoice));

                column(Vendor_No_VLE; "Vendor No.")
                { }
                column(Vendor_Name; "Vendor Name")
                { }
                column(Document_Type; "Document Type")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Posting_Date; "Posting Date")
                { }

                column(Remaining_Amount; "Remaining Amount")
                { }
                column(BaseAmount; BaseAmount)
                { }
                column(TdsRate; TdsRate)
                { }
                column(TdsAmount; TdsAmount)
                { }
                column(Amount_Gross; Amount)
                { }
                column(SGSTAmt; SGSTAmt)
                { }
                column(CGSTAmt; CGSTAmt)
                { }
                column(IGSTAmt; IGSTAmt)
                { }
                column(PoNo; PoNo)
                { }
                column(OrderDateGvar; OrderDateGvar)
                { }
                column(SubJectGvar; SubJectGvar)
                { }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLinkReference = "Vendor Ledger Entry";
                    DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No.");
                    DataItemTableView = WHERE("Entry Type" = CONST(Application), Unapplied = CONST(false));
                    column(Document_No_DVLE; "Document No.")
                    { }
                    column(Transactiondate; Transactiondate)
                    { }
                    column(TransactionAmount; TransactionAmount)
                    { }
                    column(TransactionNo; TransactionNo)
                    { }
                    trigger OnAfterGetRecord()
                    begin
                        clear(Transactiondate);
                        Clear(TransactionAmount);
                        Clear(TransactionNo);
                        VendorLedgerEntryGrec.Reset();
                        VendorLedgerEntryGrec.SetRange("Document No.", "Document No.");

                        if VendorLedgerEntryGrec.FindFirst() then begin
                            Transactiondate := VendorLedgerEntryGrec."Posting Date";
                            TransactionAmount := VendorLedgerEntryGrec.Amount;
                            TransactionNo := VendorLedgerEntryGrec."U.T.R.No.";
                        end;
                        // TatDays := "Vendor Ledger Entry"."Posting Date" - Transactiondate;
                    end;
                }




                trigger OnAfterGetRecord()
                begin
                    clear(BaseAmount);
                    clear(PoNo);
                    Clear(OrderDateGvar);
                    Clear(SubJectGvar);

                    PurchaseInvoiceLine.Reset();
                    PurchaseInvoiceLine.SetRange("Document No.", "Document No.");
                    if PurchaseInvoiceLine.FindSet() then begin
                        repeat
                            BaseAmount += PurchaseInvoiceLine."Line Amount";
                        until PurchaseInvoiceLine.Next = 0;
                    end;
                    PurchaseInvLine2.Reset();
                    PurchaseInvLine2.SetRange("Document No.", "Document No.");
                    PurchaseInvLine2.SetFilter(Quantity, '<>%1', 0);
                    PurchaseInvLine2.SetFilter("Order No.", '<>%1', '');
                    if PurchaseInvLine2.FindFirst() then begin
                        PoNo := PurchaseInvLine2."Order No.";
                    end;

                    PurchInvHeader2.Reset();
                    PurchInvHeader2.SetRange("No.", "Document No.");
                    if PurchInvHeader2.FindFirst() then begin
                        OrderDateGvar := PurchInvHeader2."Order Date";
                        SubJectGvar := PurchInvHeader2.Subject;
                    end;

                    if PurchaseInvoiceHeader.Get("Document No.") then begin
                        GetGSTAmount(PurchaseInvoiceHeader);
                        GetTDSAmt(PurchaseInvoiceHeader);
                    end;

                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);
            end;

        }

    }
    /* 
    requestpage
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
        }
    
        actions
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
    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    local procedure GetGSTAmount(PurchInvHeader: Record "Purch. Inv. Header")
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(CessAmt);
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
        DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) And (PurchInvHeader."Currency Code" <> '') then
                    CGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchInvHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) then
                        CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");

                if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And (PurchInvHeader."Currency Code" <> '') then
                    SGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchInvHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) then
                        SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");

                if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) And (PurchInvHeader."Currency Code" <> '') then
                    IGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchInvHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) then
                        IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) And (PurchInvHeader."Currency Code" <> '') then
                    CessAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchInvHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) then
                        CessAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    local procedure GetTDSAmt(PurchInvHeader: Record "Purch. Inv. Header")
    var
        TDSEntry: Record "TDS Entry";
    begin
        Clear(TDSAmt);
        TDSEntry.Reset();
        TDSEntry.SetRange("Document No.", PurchInvHeader."No.");
        if TDSEntry.FindFirst() then
            if PurchInvHeader."Currency Code" <> '' then
                TDSAmt := (PurchInvHeader."Currency Factor" * TDSEntry."Total TDS Including SHE CESS")
            else
                TDSAmt := TDSEntry."Total TDS Including SHE CESS";
        TdsRate := TDSEntry."TDS %";


    end;

    var
        PurchaseInvoiceLine: Record "Purch. Inv. Line";
        PurchaseInvLine2: Record "Purch. Inv. Line";
        PurchInvHeader2: Record "Purch. Inv. Header";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        VendorLedgerEntryGrec: Record "Vendor Ledger Entry";
        CompanyInfo: Record "Company Information";
        TdsEntry: Record "TDS Entry";
        TdsRate: Decimal;
        TdsAmount: Decimal;
        BaseAmount: Decimal;
        VendorLedgReportCap: Label 'Vendor Ledger Report';
        CgstCap: Label 'CGST';
        SgstCap: Label 'SGST';
        IgstCap: Label 'IGST';
        VoucherTypeCap: Label 'Voucher Type';
        VoucherNumberCap: Label 'Voucher Number';
        VoucherDateCap: Label 'Voucher Date';
        InvoiceNumberCap: Label 'Invoice Number';
        InvoicedateCap: Label 'Invoice Date';
        BaseAmountCap: Label 'Base Amount';
        TaxAmountCap: Label 'Tax Amount';
        GrossAmountCap: Label 'Gross Amount';
        TDSRateCap: Label 'TDS rate';
        TDSAmountCap: Label 'TDS amount';
        NetpayableCap: Label 'Net payable/paid';
        PaymentRefDetailsCap: Label 'Payment reference details';
        TransactionNumberCap: Label 'Transaction No.';
        TransactionDateCap: Label 'Transaction Date';
        TransactionAmountCap: Label 'Transaction Amount';
        TransactionAmount: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTLbl: Label 'CGST';
        SGSTLbl: Label 'SGST';
        IGSTLbl: Label 'IGST';
        CessLbl: Label 'CESS';
        OrderDateGvar: Date;
        SubJectGvar: text;
        TDSAmt: Decimal;
        CessAmt: Decimal;
        Transactiondate: Date;
        TransactionNo: Text;
        PoNoCap: Label 'PO NO.';
        PoDateCap: Label 'PO Date';
        VendorNoCap: Label 'Vendor No';

        VendorNameCap: Label 'Vendor Name';
        SubjectCap: Label 'Subject';
        PoNo: Code[20];











}