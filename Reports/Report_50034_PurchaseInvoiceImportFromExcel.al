report 50034 "Purchase Inv Import From Excel"
{


    Caption = 'Purchase Inv Import From Excel';

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
        Message(ImportMsg, FromNum, ToNum);
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        TotalRows: Integer;
        ExcelBuffer1: Record "Excel Buffer";
        PurchaseLineGRec: Record "Purchase Line";

        SheetName: Text;


        ImportMsg: Label 'Invoice are From %1 To %2 Created';
        ExcelRowColErr: Label 'Importing Data check Row %1 and Column No. %2';
        VendApprovalErr: Label 'Vendor approval status must be Released';
        VendInvoiceErr: Label 'Vendor Invoice number %1 already exist in Posted Document %2';
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        LineNo: Integer;
        DocNumGVar: Code[20];
        TotalColumns: Integer;
        ItemNum: code[20];
        LocationCode: Code[20];
        Qty: Decimal;
        DirectUnitCostVar: Decimal;
        VendorNum: Code[20];
        VendorName: Text[100];

        VendorInvNum: Code[35];
        VendorInvDate: Date;
        OrderTypeVar: Enum OrderType;
        InvoiceFound: Boolean;
        GstGroupCode: Code[20];
        HSNCode: Code[20];
        GSTCreditVal: Enum "GST Credit";
        PurchaseHeader: Record "Purchase Header";

        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec2: Record "Purchase Line";
        AllowedSections: Record "Allowed Sections";
        Vend: Record Vendor;
        FromNum: Code[20];
        ToNum: Code[20];
        GD1: Code[20];
        LineDesc: Text[1024];
        TDSSectionCode: code[10];
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

        Clear(VendorNum);
        Clear(VendorInvNum);
        Clear(VendorName);
        Clear(VendorInvDate);
        Clear(LineDesc);


        Clear(OrderTypeVar);
        Clear(InvoiceFound);
        Clear(GstGroupCode);
        Clear(GSTCreditVal);
        Clear(HSNCode);
        Clear(DocNumGVar);
        Clear(LineNo);
        Clear(GD1);
        Clear(TDSSectionCode);

        VendorNum := GetValueAtCell(RowNo, 2);   // Vendor No.
        if VendorNum = '' then begin
            VendorName := GetValueAtCell(RowNo, 3);   // Vendor Name
            Vend.Reset;
            Vend.SetFilter(Name, VendorName);
            if Vend.FindFirst then
                VendorNum := Vend."No.";


        end;
        VendorInvNum := GetValueAtCell(RowNo, 4);   // Vendor Invoice No.
        if GetValueAtCell(RowNo, 5) <> '' then
            if Evaluate(VendorInvDate, GetValueAtCell(RowNo, 5)) then;   // Vendor Invoice Date.

        // Checking Vendor Invoice number document already exist or not >>
        PurchaseHeaderRec.Reset;
        PurchaseHeaderRec.Setrange("Document Type", PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.setrange("Buy-from Vendor No.", VendorNum);
        PurchaseHeaderRec.setrange("Vendor Invoice No.", VendorInvNum);
        PurchaseHeaderRec.setrange("Document Date", Today);
        if PurchaseHeaderRec.findfirst then begin

            DocNumGVar := PurchaseHeaderRec."No.";
            InvoiceFound := true;
            PurchaseLineRec2.Reset;
            PurchaseLineRec2.SetRange("Document Type", PurchaseLineRec2."Document Type"::Invoice);
            PurchaseLineRec2.SetRange("Document No.", DocNumGVar);
            if PurchaseLineRec2.FindLast() then
                LineNo := PurchaseLineRec2."Line No." + 10000
            else
                LineNo := 10000;


        end;


        // Checking Vendor Invoice number document already exist or not <<




        if Evaluate(OrderTypeVar, GetValueAtCell(RowNo, 1)) then; // Order Type


        ItemNum := GetValueAtCell(RowNo, 7);   // No.
        LineDesc := GetValueAtCell(RowNo, 8);   // Line Description
        LocationCode := GetValueAtCell(RowNo, 9);  // Location code
        EVALUATE(Qty, GetValueAtCell(RowNo, 10));  // Quantity
        if EVALUATE(DirectUnitCostVar, GetValueAtCell(RowNo, 11)) then;  // DIRECT UNIT COST
        if EVALUATE(GstGroupCode, GetValueAtCell(RowNo, 12)) then;  // GST Group Code
        if EVALUATE(HSNCode, GetValueAtCell(RowNo, 13)) then;  // HSN CODE
        GD1 := GetValueAtCell(RowNo, 14);   // Line Global dimension 1.


        AllowedSections.Reset;
        AllowedSections.Setrange("Vendor No", VendorNum);
        AllowedSections.setrange("Default Section", true);
        if AllowedSections.FindFirst() then
            TDSSectionCode := AllowedSections."TDS Section";






        // Insert Purchase Invoice >>
        if Not InvoiceFound then begin
            LineNo := 10000;
            clear(PurchaseHeader);

            PurchaseHeader.INIT;
            PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Invoice);
            PurchaseHeader.validate("Order Type", OrderTypeVar);


            PurchaseHeader.INSERT(TRUE);
            PurchaseHeader.Validate("Buy-from Vendor No.", VendorNum);
            PurchaseHeader."Vendor Invoice No." := VendorInvNum;
            PurchaseHeader."Vendor Invoice Date" := VendorInvDate;


            PurchaseHeader.Modify();

            DocNumGVar := PurchaseHeader."No.";
            if FromNum = '' then
                FromNum := PurchaseHeader."No.";
            ToNum := PurchaseHeader."No."

        end;

        // Insert Purchase Invoice <<








        PurchaseLineGRec.INIT;
        PurchaseLineGRec.validate("Document Type", PurchaseLineGRec."Document Type"::Invoice);
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
        if LineDesc <> '' then
            PurchaseLineGRec.Validate("Line Description", LineDesc);
        if GD1 <> '' then
            PurchaseLineGRec.Validate("Shortcut Dimension 1 Code", GD1);
        PurchaseLineGRec.Validate(Quantity, Qty);
        PurchaseLineGRec.Validate("Direct Unit Cost", DirectUnitCostVar);

        if GstGroupCode <> '' then begin
            PurchaseLineGRec.validate("GST Group Code", GstGroupCode);
            if HSNCode <> '' then
                PurchaseLineGRec.Validate("HSN/SAC Code", HSNCode);
        end;
        PurchaseLineGRec.Validate("GST Credit", PurchaseLineGRec."GST Credit"::Availment);
        if TDSSectionCode <> '' then
            PurchaseLineGRec.validate("TDS Section Code", TDSSectionCode);


        PurchaseLineGRec.MODIFY;

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


        GSTGrpCode: Code[20];
        HSNCodeLvar: Code[20];
        GSTGroupRec: Record "GST Group";
        HSNSACRec: Record "HSN/SAC";
        PostedPurchInvRec: Record "Purch. Inv. Header";
        VendorInvNumLvar: code[35];


    begin


        VendorNum := GetValueAtCell(RowNo, 2);   // Vendor No.
        if VendorNum = '' then begin
            VendorName := GetValueAtCell(RowNo, 3);   // Vendor Name
            if VendorName = '' then
                Error(ExcelRowColErr, RowNo, 3);
            Vend.Reset;
            Vend.SetFilter(Name, VendorName);
            if not Vend.FindFirst then
                Error(ExcelRowColErr, RowNo, 3)
            else
                VendorNum := Vend."No.";


        end;

        if Not Vend.Get(VendorNum) then
            Error(ExcelRowColErr, RowNo, 2);
        if Vend."Approval Status" <> Vend."Approval Status"::Released then
            Error(VendApprovalErr);

        VendorInvNumLvar := GetValueAtCell(RowNo, 4);
        if VendorInvNumLvar = '' then  // Vendor Invoice No.
            Error(ExcelRowColErr, RowNo, 4);

        PostedPurchInvRec.Reset;
        PostedPurchInvRec.Setrange("Vendor Invoice No.", VendorInvNumLvar);
        if PostedPurchInvRec.FindFirst() then
            Error(VendInvoiceErr, VendorInvNumLvar, PostedPurchInvRec."No.");





        EVALUATE(TypeVar, GetValueAtCell(RowNo, 6));
        Case Typevar of
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

        LocationCode := GetValueAtCell(RowNo, 9);
        if LocationCode <> '' then
            if Not Location.Get(LocationCode) then
                Error(ExcelRowColErr, RowNo, 9);

        GSTGrpCode := GetValueAtCell(RowNo, 12);
        if GSTGrpCode <> '' then begin
            if Not GSTGroupRec.Get(GSTGrpCode) then
                Error(ExcelRowColErr, RowNo, 12);
        end;


        HSNCodeLvar := GetValueAtCell(RowNo, 13);
        if (HSNCodeLvar <> '') and (GSTGrpCode <> '') then begin
            if Not HSNSACRec.Get(GSTGrpCode, HSNCodeLvar) then
                Error(ExcelRowColErr, RowNo, 13);
        end;


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

