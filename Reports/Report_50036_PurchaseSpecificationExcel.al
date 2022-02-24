report 50036 "Purchase Specification Excel"
{


    Caption = 'Purchase Specification Excel';

    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


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

        actions
        {
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




        SpecificationRec2.Reset;
        SpecificationRec2.Setrange("Document No.", PurchaseHeaderGRec."No.");
        if SpecificationRec2.FindLast() then
            LineNum := SpecificationRec2."Line No." + 10000
        else
            LineNum := 10000;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        Message(ImportMsg, PurchaseHeaderGRec."No.");

        ExcelBuffer.DELETEALL;

    end;










    procedure GetLastRow();
    begin
        ExcelBuffer.SetRange("Row No.", 1);
        TotalColumns := ExcelBuffer.Count;
        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    procedure InsertData(RowNo: Integer);
    var

    begin

        Clear(ProductCode);
        Clear(Description);
        Clear(QtyVar);
        Clear(UOMCode);
        Clear(UnitCost);


        ProductCode := GetValueAtCell(RowNo, 1);   // product code

        Description := GetValueAtCell(RowNo, 2);   // Description

        If Evaluate(QtyVar, GetValueAtCell(RowNo, 3)) then;   // Quantity

        UOMCode := GetValueAtCell(RowNo, 4);   // UOM code

        If Evaluate(UnitCost, GetValueAtCell(RowNo, 5)) then;   // UnitCost












        SpecificationRec.INIT;
        SpecificationRec."Document No." := PurchaseHeaderGRec."No.";
        SpecificationRec.DocumentType := SpecificationRec.DocumentType::Order;
        SpecificationRec.VALIDATE("Serial No./Product Code", ProductCode);
        SpecificationRec.VALIDATE(Description, Description);
        SpecificationRec."Line No." := LineNum;


        SpecificationRec.VALIDATE(Qty, QtyVar);
        SpecificationRec.UOM := UOMCode;
        SpecificationRec.Validate("Unit Cost", UnitCost);

        SpecificationRec.INSERT(TRUE);
        LineNum += 10000;





    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    begin
        IF ExcelBuffer1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuffer1."Cell Value as Text");
        EXIT('');
    end;




    var
        SpecificationRec: Record Specification;
        SpecificationRec2: Record Specification;

        QtyVar: Decimal;
        ProductCode: Code[20];
        Description: text[100];
        UOMCode: Code[10];
        UnitCost: Decimal;



        ExcelBuffer: Record "Excel Buffer";
        TotalRows: Integer;
        ExcelBuffer1: Record "Excel Buffer";


        SheetName: Text;




        ImportMsg: Label 'Imported Lines successfully %1';


        LineNum: Integer;

        TotalColumns: Integer;

        PurchaseHeaderGRec: Record "Purchase Header";
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        FileName: Text;

    procedure SetValues(PurchaseHeaderPar: Record "Purchase Header")
    var


    begin

        PurchaseHeaderGRec := PurchaseHeaderPar;

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

