report 50014 "Purchase Import From Excel"
{


    Caption = 'Purchase Import From Excel';

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


        FOR X := 2 TO TotalRows DO
            CheckValidations(X);

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        ExcelBuffer.DELETEALL;
        Message(ImportMsg, DocNumGVar);
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        TotalRows: Integer;
        ExcelBuffer1: Record "Excel Buffer";
        PurchaseLineGRec: Record "Purchase Line";

        SheetName: Text;



        ImportMsg: Label 'Order %1 Created.';
        ExcelRowColErr: Label 'Importing Data check Row %1 and Column No. %2';
        VendApprovalErr: Label 'Vendor approval status must be Released';
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        LineNo: Integer;
        DocNumGVar: Code[20];
        TotalColumns: Integer;
        ItemNum: code[20];
        LocationCode: Code[20];
        Qty: Decimal;
        DirectUnitCostVar: Decimal;
        LineDiscVar: Decimal;

        VendorNum: Code[20];

        VendorQuoteNum: Code[20];
        VendorQuoteDate: Date;
        Subject: Text[500];
        OrderTypeVar: Enum OrderType;
        HeaderCreated: Boolean;
        PurchaseHeader: Record "Purchase Header";
        PrevVendorNum: Code[20];
        FileName: Text;



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
        Item2: Record Item;
    begin

        clear(ItemNum);
        clear(LocationCode);
        clear(Qty);
        clear(DirectUnitCostVar);
        clear(LineDiscVar);
        Clear(VendorNum);
        Clear(VendorQuoteNum);
        Clear(VendorQuoteDate);
        Clear(Subject);
        Clear(OrderTypeVar);



        if Evaluate(OrderTypeVar, GetValueAtCell(RowNo, 1)) then; // Order Type
        VendorNum := GetValueAtCell(RowNo, 2);   // Vendor No.
        VendorQuoteNum := GetValueAtCell(RowNo, 3);   // Vendor Quote No.

        if GetValueAtCell(RowNo, 4) <> '' then
            if Evaluate(VendorQuoteDate, GetValueAtCell(RowNo, 4)) then;   // Vendor Quote Date 

        Subject := GetValueAtCell(RowNo, 5);   // Subject  

        ItemNum := GetValueAtCell(RowNo, 7);   // No.
        LocationCode := GetValueAtCell(RowNo, 8);  // Location code
        EVALUATE(Qty, GetValueAtCell(RowNo, 9));  // Quantity
        if EVALUATE(DirectUnitCostVar, GetValueAtCell(RowNo, 10)) then;  // DIRECT UNIT COST
        if EVALUATE(LineDiscVar, GetValueAtCell(RowNo, 11)) then;  // LINE DISCOUNT


        // Insert Purchase Header >>
        if Not HeaderCreated then begin
            LineNo := 10000;
            PurchaseHeader.INIT;
            PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
            PurchaseHeader.validate("Order Type", OrderTypeVar);


            PurchaseHeader.INSERT(TRUE);
            PurchaseHeader.Validate("Buy-from Vendor No.", VendorNum);
            PurchaseHeader."Vendor Quote No" := VendorQuoteNum;
            PurchaseHeader."Vendor Quote Date" := VendorQuoteDate;
            PurchaseHeader.Subject := Subject;

            PurchaseHeader.Modify();
            HeaderCreated := true;
            DocNumGVar := PurchaseHeader."No.";

        end;

        // Insert Purchase Header <<








        PurchaseLineGRec.INIT;
        PurchaseLineGRec.validate("Document Type", PurchaseLineGRec."Document Type"::Order);
        PurchaseLineGRec.validate("Document No.", DocNumGVar);
        PurchaseLineGRec."Line No." := LineNo;
        PurchaseLineGRec.INSERT(TRUE);
        EVALUATE(PurchaseLineGRec.Type, GetValueAtCell(RowNo, 6));   // Type
        PurchaseLineGRec.validate(Type);
        PurchaseLineGRec.validate("No.", ItemNum);
        if PurchaseLineGRec.type = PurchaseLineGRec.type::Item then begin
            if Item2.Get(ItemNum) and (Item2.Type <> Item2.Type::Service) then
                PurchaseLineGRec.Validate("Location Code", LocationCode);
        end else
            PurchaseLineGRec.Validate("Location Code", LocationCode);
        PurchaseLineGRec.Validate(Quantity, Qty);
        PurchaseLineGRec.Validate("Direct Unit Cost", DirectUnitCostVar);
        if LineDiscVar <> 0 then
            PurchaseLineGRec.validate("Line Discount %", LineDiscVar);

        PurchaseLineGRec.MODIFY;
        LineNo += 10000;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    begin
        IF ExcelBuffer1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuffer1."Cell Value as Text");
        EXIT('');
    end;

    procedure CheckValidations(RowNo: Integer)
    var
        Item: Record Item;
        GLAcct: Record "G/L Account";

        Location: Record Location;
        TypeVar: Enum "Purchase Line Type";

        Vend: Record Vendor;


    begin


        if PrevVendorNum = '' then begin
            PrevVendorNum := GetValueAtCell(RowNo, 2);   // Vendor No.
            if Not Vend.Get(PrevVendorNum) then
                Error(ExcelRowColErr, RowNo, 2);
            if Vend."Approval Status" <> Vend."Approval Status"::Released then
                Error(VendApprovalErr);
        end;

        if PrevVendorNum <> GetValueAtCell(RowNo, 2) then
            Error(ExcelRowColErr, RowNo, 2);



        EVALUATE(TypeVar, GetValueAtCell(RowNo, 6));
        case Typevar of
            Typevar::Item:
                begin
                    if Not Item.Get(GetValueAtCell(RowNo, 7)) then
                        Error(ExcelRowColErr, RowNo, 7);
                end;

            Typevar::"G/L Account":
                begin
                    if Not GLAcct.Get(GetValueAtCell(RowNo, 7)) then
                        Error(ExcelRowColErr, RowNo, 7);
                end;
        end;

        LocationCode := GetValueAtCell(RowNo, 8);
        if LocationCode <> '' then
            if Not Location.Get(LocationCode) then
                Error(ExcelRowColErr, RowNo, 8);


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

