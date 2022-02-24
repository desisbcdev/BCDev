report 50000 "Cost Centrewise Spent Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './CostCentreWiseSpentReport.rdl';
    Caption = 'Cost CentreWise Spent Report';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Posting Date", "G/L Account No.";
            column(VoucherTypeCap; VoucherTypeCap)
            { }
            column(VoucherNumberCap; VoucherNumberCap)
            { }
            column(VoucherDateCap; VoucherDateCap)
            { }
            column(VendorNameCap; VendorNameCap)
            { }
            column(NarrationCap; NarrationCap)
            { }
            column(LedgerCodeCap; LedgerCodeCap)
            { }
            column(BaseAmountCap; BaseAmountCap)
            { }
            column(TaxAmountCap; TaxAmountCap)
            { }
            column(CostCenter1Cap; CostCenter1Cap)
            { }
            column(Costcenter2Cap; Costcenter2Cap)
            { }
            column(Document_Type; "Document Type")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Document_No_; "Document No.")
            { }
            column(G_L_Account_No_; "G/L Account No.")
            { }
            column(Amount; Amount)
            { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Vendor_Name; Vendor.Name)
            { }
            column(CompanyInfo_picture; CompanyInfo.Picture)
            { }
            column(CostCenterWiseSpentReportCap; CostCenterWiseSpentReportCap)
            { }
            column(TaxAmountGvar; TaxAmountGvar)
            { }
            column(NarrationGvar; NarrationGvar)
            { }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                if "Source Type" = "Source Type"::Vendor then begin

                    if Vendor.Get("Source No.") then;
                end;
                Clear(TaxAmountGvar);
                DetailedGstLedgEntry.Reset();
                DetailedGstLedgEntry.SetRange("Document No.", "Document No.");
                if DetailedGstLedgEntry.FindSet then begin
                    repeat
                        TaxAmountGvar += DetailedGstLedgEntry."GST Amount";
                    until DetailedGstLedgEntry.Next = 0;
                end;
                clear(NarrationGvar);
                if "Document Type" = "Document Type"::Payment then begin
                    PostedNarration.Reset();
                    PostedNarration.SetRange("Document No.", "Document No.");
                    PostedNarration.SetFilter(Narration, '<>%1', '');
                    if PostedNarration.FindSet() then
                        repeat
                            NarrationGvar += PostedNarration.Narration;
                        until PostedNarration.Next = 0;
                end else begin
                    PurchInvLine.Reset();
                    PurchInvLine.SetRange("Document No.", "Document No.");
                    PurchInvLine.SetFilter(Narration, '<>%1', '');
                    if PurchInvLine.FindFirst() then
                        NarrationGvar := PurchInvLine.Narration;

                end;

            end;



        }
    }

    /*requestpage
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
    }
    */
    var
        CompanyInfo: Record "Company Information";
        DetailedGstLedgEntry: Record "Detailed GST Ledger Entry";
        PostedNarration: Record "Posted Narration";
        PurchInvLine: Record "Purch. Inv. Line";
        Vendor: Record Vendor;
        VoucherTypeCap: Label 'Voucher Type';
        VoucherNumberCap: Label 'Voucher Number';
        VoucherDateCap: Label 'Voucher Date';
        VendorNameCap: Label 'Vendor Name';
        NarrationCap: Label 'Narration';
        LedgerCodeCap: Label 'Ledger Code';
        BaseAmountCap: Label 'Base Amount';
        TaxAmountCap: Label 'TAX Amount';
        CostCenter1Cap: Label 'Cost Center1';
        Costcenter2Cap: Label 'Cost Center2';
        CostCenterWiseSpentReportCap: Label 'Cost CenterWise Spent Report';
        TaxAmountGvar: Decimal;
        NarrationGvar: Text;
}