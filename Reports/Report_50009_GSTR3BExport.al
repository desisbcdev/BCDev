report 50009 "GSTR 3B Export"
{
    Caption = 'GSTR 3B Export';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    ProcessingOnly = true;


    dataset
    {

        dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
        {

            DataItemTableView = SORTING("Document No.", "Document Line No.") WHERE("Transaction Type" = CONST(Purchase));
            RequestFilterFields = "Posting Date";


            trigger OnAfterGetRecord();
            begin



                if (PrevDocNum <> "Document No.") or (PrevDocLineNum <> "Document Line No.") then begin
                    PrevDocNum := "Document No.";
                    PrevDocLineNum := "Document Line No.";



                end else
                    CurrReport.skip;

                ClearVariables();
                SNum += 1;
                GetLineValues();


                ExcelBuffer.NewRow();

                ExcelBuffer.AddColumn(SNum, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LineGLNum, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Vend.Name + Vend."Name 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Buyer/Seller Reg. No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("GST Jurisdiction Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("GST Vendor Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LineDescription, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LineNarration, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvoiceNumberBOEVal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("GST Base Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("GST Credit", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.AddColumn("GST Component Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


                if "GST Component Code" <> 'IGST' then begin
                    ExcelBuffer.AddColumn(("GST %" * 2), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("GST Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("GST Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                end else begin
                    ExcelBuffer.AddColumn("GST %", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("GST Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                end;

                ExcelBuffer.AddColumn(CessVal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(TotalVal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);




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
                SetFilter("GST Component Code", '%1|%2|%3', 'SGST', 'IGST', 'CGST');




                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GSTR - 3B', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn(SNoLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PINVLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EL1Label, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(NameoftheSupplierLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(GSTINLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(TypeofSupplyLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CategoryOfInwardSuppliesLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(DescriptionofServiceLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LineNarrationLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(HSNcodeLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvoiceNumberBOELabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvoiceDateLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(GrossValueLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EligibilityCriteriaLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CGSTIGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(RateLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(IGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CessLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(TotalInvoiceValueLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);








            end;
        }

    }





    var
        ExcelBuffer: Record "Excel Buffer";
        ColumnNo: Integer;
        RowNo: Integer;
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInVHeader: Record "Purch. Inv. Header";
        PurchCrLine: Record "Purch. Cr. Memo Line";
        PurchCrHeader: Record "Purch. Cr. Memo Hdr.";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        DetailedGSTLECess: REcord "Detailed GST Ledger Entry";
        Vend: record Vendor;
        Company: Record "Company Information";

        LineDescription: Text[250];
        LineNarration: Text[250];

        InvoiceNumberBOEVal: text[250];
        PrevDocNum: Text;
        PrevDocLineNum: Integer;
        TotalVal: Decimal;
        CessVal: Decimal;
        LineGLNum: code[20];



        SNoLabel: Label 'S.No';
        PINVLabel: Label 'PINV';
        EL1Label: Label 'EL1';
        NameoftheSupplierLabel: Label 'Name of the Supplier';
        GSTINLabel: Label 'GSTIN';
        TypeofSupplyLabel: Label 'Type of Supply';
        CategoryOfInwardSuppliesLabel: Label 'Category of inward Supplies';

        DescriptionofServiceLabel: Label 'Description of service';
        LineNarrationLabel: Label 'Line Narration';
        HSNcodeLabel: Label 'HSN code';
        InvoiceNumberBOELabel: Label 'Invoice number/ BOE';
        InvoiceDateLabel: Label 'Invoice date';
        GrossValueLabel: Label 'Gross value';
        EligibilityCriteriaLabel: Label 'Eligibility Criteria';
        CGSTIGSTLabel: Label 'CGST/IGST';
        RateLabel: Label 'Rate';
        CGSTLabel: Label 'CGST';
        SGSTLabel: Label 'SGST';
        IGSTLabel: Label 'IGST';
        CessLabel: Label 'Cess';
        TotalInvoiceValueLabel: Label 'Total invoice value';
        SNum: Integer;
        ReportFileName: Label 'GSTR3B';
        HSNSACRec: record "HSN/SAC";
        GenPostingSetup: record "General Posting Setup";
















    procedure ClearVariables()
    begin

        Clear(LineDescription);
        Clear(LineNarration);

        Clear(InvoiceNumberBOEVal);

        clear(TotalVal);
        clear(CessVal);

        Clear(LineGLNum);
    end;

    procedure GetLineValues()
    begin

        VendLedgerEntry.RESET;
        VendLedgerEntry.SETRANGE("Document No.", "Detailed GST Ledger Entry"."Document No.");
        IF VendLedgerEntry.FINDFIRST THEN BEGIN
            VendLedgerEntry.CALCFIELDS("Original Amt. (LCY)");
            TotalVal := (VendLedgerEntry."Original Amt. (LCY)") * (-1);
        end;

        if Not vend.get("Detailed GST Ledger Entry"."Source No.") then
            clear(Vend);

        if not HSNSACRec.get("Detailed GST Ledger Entry"."GST Group Code", "Detailed GST Ledger Entry"."HSN/SAC Code") then
            clear(HSNSACRec);
        LineDescription := HSNSACRec.Description;

        DetailedGSTLECess.Reset;
        DetailedGSTLECess.SetRange("Transaction Type", "Detailed GST Ledger Entry"."Transaction Type");
        DetailedGSTLECess.SetRange("Document No.", "Detailed GST Ledger Entry"."Document No.");
        DetailedGSTLECess.SetRange("Document Line No.", "Detailed GST Ledger Entry"."Document Line No.");
        DetailedGSTLECess.SetRange("Gst Component code", 'CESS');
        if DetailedGSTLECess.FindFirst then
            Cessval := DetailedGSTLECess."GST Amount";


        case "Detailed GST Ledger Entry"."Document Type" of

            "Detailed GST Ledger Entry"."Document Type"::Invoice:
                begin
                    if Not (PurchInvLine.Get("Detailed GST Ledger Entry"."Document No.", "Detailed GST Ledger Entry"."Document Line No.")) then
                        clear(PurchInvLine);

                    if Not PurchInVHeader.Get("Detailed GST Ledger Entry"."Document No.") then
                        clear(PurchInVHeader);

                    if PurchInvLine.Type = purchinvline.type::"G/L Account" then
                        LineGLNum := PurchInvLine."No."
                    else begin
                        if GenPostingSetup.get(PurchInvLine."Gen. Bus. Posting Group", PurchInvLine."Gen. Prod. Posting Group") then
                            LineGLNum := GenPostingSetup."Purch. Account";

                    end;



                    if StrLen(PurchInvLine.Narration) > 250 then
                        LineNarration := copystr(PurchInvLine.Narration, 1, 250)
                    else
                        LineNarration := PurchInvLine.Narration;


                    InvoiceNumberBOEVal := PurchInVHeader."Vendor Invoice No.";
                end;

            "Detailed GST Ledger Entry"."Document Type"::"Credit Memo":
                begin
                    if Not (PurchCrLine.Get("Detailed GST Ledger Entry"."Document No.", "Detailed GST Ledger Entry"."Document Line No.")) then
                        clear(PurchCrLine);

                    if Not PurchCrHeader.Get("Detailed GST Ledger Entry"."Document No.") then
                        clear(PurchCrHeader);

                    if PurchcrLine.Type = purchCrline.type::"G/L Account" then
                        LineGLNum := PurchCrLine."No."
                    else begin
                        if GenPostingSetup.get(PurchCrLine."Gen. Bus. Posting Group", PurchCrLine."Gen. Prod. Posting Group") then
                            LineGLNum := GenPostingSetup."Purch. Account";

                    end;




                    if StrLen(PurchCrLine.Narration) > 250 then
                        LineNarration := copystr(PurchCrLine.Narration, 1, 250)
                    else
                        LineNarration := PurchCrLine.Narration;



                    InvoiceNumberBOEVal := PurchCrHeader."Vendor Cr. Memo No.";
                end;


        end

    end;
}

