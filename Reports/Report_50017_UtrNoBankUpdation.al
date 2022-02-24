report 50017 "Utr No Updation"
{
    Caption = 'Update Utr No_50017';
    ApplicationArea = all;

    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    Permissions = TableData "Vendor Ledger Entry" = rm, TableData "Bank Account Ledger Entry" = rm;


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
            ModifyData(X);

        ExcelBuffer.DELETEALL;
        Message(ImportMsg);
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        TotalRows: Integer;
        ExcelBuffer1: Record "Excel Buffer";


        SheetName: Text;
        ImportMsg: Label 'Import Completed';

        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';

        DocNumGVar: Code[20];
        UTrNoGvar: Text[50];
        TotalColumns: Integer;
        FileName: Text;

        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";

    procedure GetLastRow();
    begin
        ExcelBuffer.SetRange("Row No.", 1);
        TotalColumns := ExcelBuffer.Count;
        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    procedure ModifyData(RowNo: Integer);
    var

    begin
        clear(DocNumGVar);
        Clear(UTrNoGvar);
        DocNumGVar := GetValueAtCell(RowNo, 1); // Document No.
        UTrNoGvar := GetValueAtCell(RowNo, 2); //  UtrNo.

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SETRANGE("Document No.", DocNumGVar);
        IF VendorLedgerEntry.FindFirst THEN begin
            VendorLedgerEntry."U.T.R.No." := UTrNoGvar;

            VendorLedgerEntry.MODIFY;
        end;

        BankAccountLedgerEntry.Reset();
        BankAccountLedgerEntry.SETRANGE("Document No.", DocNumGVar);
        IF BankAccountLedgerEntry.FindFirst THEN begin
            BankAccountLedgerEntry."U.T.R.No." := UTrNoGvar;

            BankAccountLedgerEntry.MODIFY;
        end;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    begin
        IF ExcelBuffer1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuffer1."Cell Value as Text");
        EXIT('');
    end;

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