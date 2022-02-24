report 50008 "GSTR-1"
{
    Caption = 'GSTR-1';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    ProcessingOnly = true;


    dataset
    {

        dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
        {

            DataItemTableView = SORTING("Document No.", "Document Line No.") WHERE("Transaction Type" = CONST(Sales));
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
                ExcelBuffer.AddColumn("Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(CustRec.Name + CustRec."Name 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Buyer/Seller Reg. No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("GST Place of Supply", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(USDVal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(INRVal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("GST Jurisdiction Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LineDescription, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("GST %", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                if "GST Component Code" <> 'IGST' then begin
                    ExcelBuffer.AddColumn("GST Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("GST Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                end else begin
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("GST Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                end;

                ExcelBuffer.AddColumn(TotalVal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);




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
                Company.Reset();
                Company.get;
                Company.CalcFields(Picture);
                ExcelBuffer.DELETEALL;
                CLEAR(ExcelBuffer);
                //Company.calcfields(Picture);
                /*  FilePathName := 'C:\Users\jayanth\Downloads';
                 IF Company.Picture.HASVALUE THEN BEGIN
                     Company.Picture.EXPORT(FilePathName); //or your fileextension
                     xlSheet.Shapes.AddPicture(FilePathName, 1, 1, 20, 20, 100, 100);
                 end; */

                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GSTR - 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();


                ExcelBuffer.AddColumn(SNoLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvoiceNOLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvoiceDateLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


                ExcelBuffer.AddColumn(PartyRecipientNameLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(GSTINLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(placeofSupplyLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ValueofSuppliesUSDLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ValueofSuppliesINRLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(TypeofSupplyLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(HSNcodeLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(DescriptionLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.AddColumn(RateLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(IGSTLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.AddColumn(TotalInvoiceValueLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(QtyLabel, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);








            end;
        }

    }





    var
        ExcelBuffer: Record "Excel Buffer";

        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";

        SalesCrLine: Record "Sales Cr.Memo Line";
        SalesCrHeader: Record "Sales Cr.Memo Header";

        CustLedgerEntry: Record "Cust. Ledger Entry";

        LineDescription: Text[250];
        ReportFileName: Label 'GSTR-1';
        Company: Record "Company Information";
        FilePathName: Text;
        // xlSheet: Automation ;

        PrevDocNum: Text;
        PrevDocLineNum: Integer;
        TotalVal: Decimal;
        CustRec: Record Customer;
        USDVal: Decimal;
        INRVal: Decimal;



        SNoLabel: Label 'S.No';
        InvoiceNOLabel: Label 'Invoice No.';
        InvoiceDateLabel: Label 'Invoice Date';

        PartyRecipientNameLabel: Label 'Party/Recipient name';
        GSTINLabel: Label 'GSTIN';
        PlaceofSupplyLabel: Label 'Place of Supply';

        TypeofSupplyLabel: Label 'Type of Supply';


        DescriptionLabel: Label 'Description';
        ValueofSuppliesUSDLabel: Label 'Value of Supplies(USD)';
        ValueofSuppliesINRLabel: Label 'Value of Supplies(INR)';
        HSNcodeLabel: Label 'HSN code';
        RateLabel: Label 'GST Rate';
        CGSTLabel: Label 'CGST';
        SGSTLabel: Label 'SGST';
        IGSTLabel: Label 'IGST';

        TotalInvoiceValueLabel: Label 'Total invoice value';
        QtyLabel: Label 'Qty';
        SNum: Integer;

    procedure ClearVariables()
    begin

        Clear(LineDescription);
        Clear(TotalVal);
        Clear(USDVal);
        Clear(INRVal);



    end;

    procedure GetLineValues()
    begin

        if Not CustRec.Get("Detailed GST Ledger Entry"."Source No.") then
            clear(CustRec);

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", "Detailed GST Ledger Entry"."Document No.");
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            CustLedgerEntry.CALCFIELDS("Original Amt. (LCY)");
            TotalVal := CustLedgerEntry."Original Amt. (LCY)";
        end;

        case "Detailed GST Ledger Entry"."Document Type" of

            "Detailed GST Ledger Entry"."Document Type"::Invoice:
                begin
                    if Not (SalesInvLine.Get("Detailed GST Ledger Entry"."Document No.", "Detailed GST Ledger Entry"."Document Line No.")) then
                        Clear(SalesInvLine);

                    if not SalesInvHeader.Get("Detailed GST Ledger Entry"."Document No.") then
                        Clear(SalesInvHeader);

                    LineDescription := SalesInvLine.Description + SalesInvLine."Description 2";

                    if SalesInvHeader."Currency Code" <> '' then begin
                        USDVal := SalesInvLine."Line Amount";

                        INRVal := Round((SalesInvLine."Line Amount" / SalesInvHeader."Currency Factor"), 0.01);
                    end else
                        InRVal := SalesInvLine."Line Amount";

                end;

            "Detailed GST Ledger Entry"."Document Type"::"Credit Memo":
                begin
                    if Not (SalesCrLine.Get("Detailed GST Ledger Entry"."Document No.", "Detailed GST Ledger Entry"."Document Line No.")) then
                        clear(SalesCrLine);

                    if Not SalesCrHeader.Get("Detailed GST Ledger Entry"."Document No.") then
                        Clear(SalescrHeader);

                    LineDescription := SalesCrLine.Description + SalesCrLine."Description 2";

                    if SalesCrHeader."Currency Code" <> '' then begin
                        USDVal := SalesCrLine."Line Amount";
                        INRVal := Round((SalescrLine."Line Amount" / SalescrHeader."Currency Factor"), 0.01);
                    end else
                        INRVal := SalesCrLine."Line Amount";




                end;


        end

    end;
}

