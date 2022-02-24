report 50028 "Prepaid Expensive"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PrepaidExpensive.rdl';
    ApplicationArea = Suite;
    Caption = 'PrepaidExpensive';
    UsageCategory = ReportsAndAnalysis;



    dataset
    {
        dataitem("Posted Deferral Header"; "Posted Deferral Header")
        {
            DataItemTableView = SORTING("Deferral Doc. Type", CustVendorNo, "Posting Date", "Gen. Jnl. Document No.", "Account No.", "Document Type", "Document No.", "Line No.") ORDER(Ascending);
            RequestFilterFields = "Document No.";
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(GLAccTableCaption; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }
            column(VendNo; CustVendorNo)
            {
            }
            column(No_GLAcc; "Account No.")
            {
            }
            column(Document_No; DocNum)
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(DocumentTypeString; DocumentTypeString)
            {
            }
            column(Line_No; "Line No.")
            {
            }
            column(DeferralSummaryPurchCaption; DeferralSummaryPurchCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(GLBalCaption; GLBalCaptionLbl)
            {
            }
            column(RemAmtDefCaption; RemAmtDefCaptionLbl)
            {
            }
            column(TotAmtDefCaption; TotAmtDefCaptionLbl)
            {
            }
            column(BalanceAsOfDateCaption; BalanceAsOfDateCaptionLbl + Format(BalanceAsOfDateFilter))
            {
            }
            column(BalanceAsOfDateFilter; BalanceAsOfDateFilter)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl + Format(DocumentFilter))
            {
            }
            column(DocumentFilter; DocumentFilter)
            {
            }
            column(VendorCaption; VendorCaptionLbl + Format(VendorFilter))
            {
            }
            column(AccountNoCaption; AccountNoLbl)
            {
            }
            column(AmtRecognizedCaption; AmtRecognizedLbl)
            {
            }
            column(AccountName; AccountName)
            {
            }
            column(VendorName; VendorName)
            {
            }
            column(TotalAmtDeferred; "Amount to Defer (LCY)")
            {
            }
            column(NumOfPeriods; "No. of Periods")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DeferralStartDate; Format("Start Date"))
            {
            }
            column(AmtRecognized; AmtRecognized)
            {
            }
            column(RemainingAmtDeferred; RemainingAmtDeferred)
            {
            }
            column(PostingDate; Format(PostingDate))
            {
            }
            column(DeferralAccount; DeferralAccount)
            {
            }
            column(Amount; "Amount to Defer (LCY)")
            {
            }
            column(LineDescription; LineDescription)
            {
            }
            column(LineType; LineType)
            {
            }
            column(MonthName_1; MonthName[1])
            { }
            column(MonthName_2; MonthName[2])
            { }
            column(MonthName_3; MonthName[3])
            { }
            column(MonthName_4; MonthName[4])
            { }
            column(MonthName_5; MonthName[5])
            { }
            column(MonthName_6; MonthName[6])
            { }
            column(MonthName_7; MonthName[7])
            { }
            column(MonthName_8; MonthName[8])
            { }
            column(MonthName_9; MonthName[9])
            { }
            column(MonthName_10; MonthName[10])
            { }
            column(MonthName_11; MonthName[11])
            { }
            column(MonthName_12; MonthName[12])
            { }
            column(EndDate_1; EndDate[1])
            { }
            column(EndDate_2; EndDate[2])
            { }
            column(EndDate_3; EndDate[3])
            { }
            column(EndDate_4; EndDate[4])
            { }
            column(EndDate_5; EndDate[5])
            { }
            column(EndDate_6; EndDate[6])
            { }
            column(EndDate_7; EndDate[7])
            { }
            column(EndDate_8; EndDate[8])
            { }
            column(EndDate_9; EndDate[9])
            { }
            column(EndDate_10; EndDate[10])
            { }
            column(EndDate_11; EndDate[11])
            { }
            column(EndDate_12; EndDate[12])
            { }
            column(SnoCap; SnoCap)
            { }
            column(El1Cap; El1Cap)
            { }
            column(VoucherDateCap; VoucherDateCap)
            { }
            column(VendorNameCap; VendorNameCap)
            { }
            column(VoucherNoCap; VoucherNoCap)
            { }
            column(LinenarrationCap; LinenarrationCap)
            { }
            column(FromCap; FromCap)
            { }
            column(ToCap; ToCap)
            { }
            column(PeriodInMonthCap; PeriodInMonthCap)
            { }
            column(PrepaidExpensesCap; PrepaidExpensesCap)
            { }
            column(ChangePerMonth; ChangePerMonthCap)
            { }
            column(ClosingBalanceCap; ClosingBalanceCap)
            {

            }


            column(FromDateVar; FromDateVar)
            { }

            column(TODateVar; TODateVar)
            { }

            column(LineNarrVar; LineNarrVar)
            { }
            column(ChargePerMonth; ChargePerMonth)
            { }
            column(StartDateBefore; StartDateBefore)
            { }
            column(GLAcctNum; GLAcctNum)
            { }

            column(LineAmtArr_1; LineAmtArr[1])
            {

            }
            column(LineAmtArr_2; LineAmtArr[2])
            {

            }

            column(LineAmtArr_3; LineAmtArr[3])
            {

            }

            column(LineAmtArr_4; LineAmtArr[4])
            {

            }


            column(LineAmtArr_5; LineAmtArr[5])
            {

            }

            column(LineAmtArr_6; LineAmtArr[6])
            {

            }


            column(LineAmtArr_7; LineAmtArr[7])
            {

            }

            column(LineAmtArr_8; LineAmtArr[8])
            {

            }


            column(LineAmtArr_9; LineAmtArr[9])
            {

            }

            column(LineAmtArr_10; LineAmtArr[10])
            {

            }


            column(LineAmtArr_11; LineAmtArr[11])
            {

            }

            column(LineAmtArr_12; LineAmtArr[12])
            {

            }

            Column(ClosingAmtArr_1; ClosingAmtArr[1])
            {

            }

            Column(ClosingAmtArr_2; ClosingAmtArr[2])
            {

            }


            Column(ClosingAmtArr_3; ClosingAmtArr[3])
            {

            }


            Column(ClosingAmtArr_4; ClosingAmtArr[4])
            {

            }


            Column(ClosingAmtArr_5; ClosingAmtArr[5])
            {

            }


            Column(ClosingAmtArr_6; ClosingAmtArr[6])
            {

            }

            Column(ClosingAmtArr_7; ClosingAmtArr[7])
            {

            }


            Column(ClosingAmtArr_8; ClosingAmtArr[8])
            {

            }

            Column(ClosingAmtArr_9; ClosingAmtArr[9])
            {

            }


            Column(ClosingAmtArr_10; ClosingAmtArr[10])
            {

            }

            Column(ClosingAmtArr_11; ClosingAmtArr[11])
            {

            }


            Column(ClosingAmtArr_12; ClosingAmtArr[12])
            {

            }
            column(companyInfo_Picture; companyInfo.Picture)
            { }

            column(StartDateBeforeAmt; StartDateBeforeAmt)
            {

            }







            trigger OnAfterGetRecord()
            var
                PostedDeferralLine: Record "Posted Deferral Line";
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                PurchInvHeader: Record "Purch. Inv. Header";
                PurchInvLine: Record "Purch. Inv. Line";
                PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                ReverseAmounts: Boolean;
                PostedDeferralLineRec2: Record "Posted Deferral Line";


            begin
                Clear(FromDateVar);
                Clear(TODateVar);
                Clear(LineNarrVar);
                Clear(ChargePerMonth);
                Clear(GLAcctNum);
                clear(LineAmtArr);
                clear(VendorName);
                Clear(DocNum);
                Clear(DocAmt);
                Clear(StartDateBeforeAmt);


                PreviousVendor := WorkingVendor;
                ReverseAmounts := false;

                if Vendor.Get(CustVendorNo) then begin
                    VendorName := Vendor.Name;
                    WorkingVendor := CustVendorNo;
                end;




                if PrintOnlyOnePerPage and (PreviousVendor <> WorkingVendor) then begin
                    PostedDeferralHeaderPage.Reset();
                    PostedDeferralHeaderPage.SetRange(CustVendorNo, CustVendorNo);
                    if PostedDeferralHeaderPage.FindFirst then
                        PageGroupNo := PageGroupNo + 1;
                end;

                LineDescription := '';
                if "Deferral Doc. Type" = "Deferral Doc. Type"::Purchase then begin
                    DocNum := "Document No.";
                    case "Document Type" of
                        7: // Posted Invoice
                            if PurchInvLine.Get("Document No.", "Line No.") then begin
                                LineDescription := PurchInvLine.Description;
                                LineType := PurchInvLine.Type.AsInteger();
                                LineNarrVar := PurchInvLine.Narration;
                                if PurchInvHeader.Get("Document No.") then
                                    PostingDate := PurchInvHeader."Posting Date";
                                if PurchInvLine.Type = purchinvline.type::"G/L Account" then
                                    GLAcctNum := PurchInvLine."No."
                                else begin
                                    if GenPostingSetup.get(PurchInvLine."Gen. Bus. Posting Group", PurchInvLine."Gen. Prod. Posting Group") then
                                        GLAcctNum := GenPostingSetup."Purch. Account";

                                end;
                            end;
                        8: // Posted Credit Memo
                            if PurchCrMemoLine.Get("Document No.", "Line No.") then begin
                                LineDescription := PurchCrMemoLine.Description;
                                LineType := PurchCrMemoLine.Type.AsInteger();
                                if PurchCrMemoHdr.Get("Document No.") then
                                    PostingDate := PurchCrMemoHdr."Posting Date";
                                ReverseAmounts := true;
                            end;
                        9: // Posted Return Receipt
                            if PurchaseLine.Get("Document Type", "Document No.", "Line No.") then begin
                                LineDescription := PurchaseLine.Description;
                                LineType := PurchaseLine.Type.AsInteger();
                                if PurchaseHeader.Get("Document Type", "Document No.") then
                                    PostingDate := PurchaseHeader."Posting Date";
                                ReverseAmounts := true;
                            end;
                    end;
                end else
                    if "Deferral Doc. Type" = "Deferral Doc. Type"::"G/L" then begin
                        DocNum := "Gen. Jnl. Document No.";
                        PostedNarration.Reset();
                        PostedNarration.SetRange("Document No.", "Document No.");
                        PostedNarration.SetFilter(Narration, '<>%1', '');
                        if PostedNarration.FindSet() then
                            repeat
                                LineNarrVar += PostedNarration.Narration;
                            until PostedNarration.Next = 0;

                    end;

                AmtRecognized := 0;
                RemainingAmtDeferred := 0;

                PostedDeferralLine.SetRange("Deferral Doc. Type", "Deferral Doc. Type");
                PostedDeferralLine.SetRange("Gen. Jnl. Document No.", "Gen. Jnl. Document No.");
                PostedDeferralLine.SetRange("Account No.", "Account No.");
                PostedDeferralLine.SetRange("Document Type", "Document Type");
                PostedDeferralLine.SetRange("Document No.", "Document No.");
                PostedDeferralLine.SetRange("Line No.", "Line No.");
                if PostedDeferralLine.Find('-') then
                    FromDateVar := PostedDeferralLine."Posting Date";
                repeat
                    DeferralAccount := PostedDeferralLine."Deferral Account";
                    if PostedDeferralLine."Posting Date" <= BalanceAsOfDateFilter then
                        AmtRecognized := AmtRecognized + PostedDeferralLine."Amount (LCY)"
                    else
                        RemainingAmtDeferred := RemainingAmtDeferred + PostedDeferralLine."Amount (LCY)";
                    if ChargePerMonth < PostedDeferralLine.Amount then
                        ChargePerMonth := PostedDeferralLine.Amount;
                until PostedDeferralLine.Next() = 0;
                TODateVar := PostedDeferralLine."Posting Date";


                if "Deferral Doc. Type" = "Deferral Doc. Type"::"G/L" then begin
                    GLAcctNum := PostedDeferralLine."Deferral Account";
                    if GLAcctRec.Get(GLAcctNum) then
                        VendorName := GLAcctRec.Name;
                end;

                DocumentTypeString := ReturnPurchDocTypeString("Document Type");
                if ReverseAmounts then begin
                    AmtRecognized := -AmtRecognized;
                    RemainingAmtDeferred := -RemainingAmtDeferred;
                    "Amount to Defer (LCY)" := -"Amount to Defer (LCY)";
                end;

                DocAmt := "Amount to Defer";
                // Getting the value before financial year >>
                PostedDeferralLineRec2.reset;
                PostedDeferralLineRec2.SetRange("Deferral Doc. Type", "Deferral Doc. Type");
                PostedDeferralLineRec2.SetRange("Gen. Jnl. Document No.", "Gen. Jnl. Document No.");
                PostedDeferralLineRec2.SetRange("Account No.", "Account No.");
                PostedDeferralLineRec2.SetRange("Document Type", "Document Type");
                PostedDeferralLineRec2.SetRange("Document No.", "Document No.");
                PostedDeferralLineRec2.SetRange("Line No.", "Line No.");
                PostedDeferralLineRec2.Setfilter("Posting Date", '<=%1', StartDateBefore);
                if PostedDeferralLineRec2.Find('-') then begin
                    repeat
                        DocAmt -= PostedDeferralLineRec2.Amount;
                        StartDateBeforeAmt += PostedDeferralLineRec2.Amount;

                    until PostedDeferralLineRec2.Next = 0;
                end;


                // Getting the value before financial year <<

                For I := 1 to 12 do begin
                    PostedDeferralLineRec2.reset;
                    PostedDeferralLineRec2.SetRange("Deferral Doc. Type", "Deferral Doc. Type");
                    PostedDeferralLineRec2.SetRange("Gen. Jnl. Document No.", "Gen. Jnl. Document No.");
                    PostedDeferralLineRec2.SetRange("Account No.", "Account No.");
                    PostedDeferralLineRec2.SetRange("Document Type", "Document Type");
                    PostedDeferralLineRec2.SetRange("Document No.", "Document No.");
                    PostedDeferralLineRec2.SetRange("Line No.", "Line No.");
                    PostedDeferralLineRec2.SetRange("Posting Date", Calcdate('<-CM>', EndDate[I]), EndDate[I]);
                    if PostedDeferralLineRec2.Find('-') then begin

                        if PostedDeferralLineRec2."Posting Date" <= BalanceAsOfDateFilter then begin
                            LineAmtArr[i] := PostedDeferralLineRec2.Amount;
                            ClosingAmtArr[i] := DocAmt - LineAmtArr[i];
                            DocAmt := DocAmt - LineAmtArr[i];
                        end else begin
                            LineAmtArr[i] := 0;
                            ClosingAmtArr[i] := 0;
                        end;


                    end else begin
                        LineAmtArr[i] := 0;

                        ClosingAmtArr[i] := 0;
                    end;


                end;
            end;


            trigger OnPreDataItem()
            begin
                SetFilter("Deferral Doc. Type", '%1|%2', "Deferral Doc. Type"::Purchase, "Deferral Doc. Type"::"G/L");
                PageGroupNo := 1;
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPageperVendor; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                        Visible = false;
                    }
                    field(BalanceAsOfDateFilter; BalanceAsOfDateFilter)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Balance as of:';
                        ToolTip = 'Specifies the date up to which you want to see deferred expenses.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if BalanceAsOfDateFilter = 0D then
                BalanceAsOfDateFilter := WorkDate;
            StartDate := DMY2DATE(1, 4, DATE2DMY(BalanceAsOfDateFilter, 3));
            IF DATE2DMY(Today, 2) IN [1 .. 3] THEN
                StartDate := DMY2DATE(1, 4, DATE2DMY(BalanceAsOfDateFilter, 3) - 1);
            StartDateBefore := StartDate - 1;
            LoopDate := StartDate;
            for I := 1 to 12 do begin
                MonthName[I] := FORMAT(LoopDate, 0, '<Month Text,3>-<Year>');
                EndDate[I] := CALCDATE('<CM>', LoopDate);
                LoopDate := CalcDate('<CM+1D>', loopdate);

            end;

        end;
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        PrepaidExpenseRepCap = 'Prepaid Expense Report';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        EntryNoCaption = 'Entry No.';
        NoOfPeriodsCaption = 'No. of Periods';
        DeferralAccountCaption = 'Deferral Account';
        DocTypeCaption = 'Document Type';
        DefStartDateCaption = 'Deferral Start Date';
        AcctNameCaption = 'Account Name';
        LineNoCaption = 'Line No.';
        VendNoCaption = 'Vendor No.';
        VendNameCaption = 'Vendor Name';
        LineDescCaption = 'Line Description';
        LineTypeCaption = 'Line Type';




    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";

    begin
        VendorFilter := FormatDocument.GetRecordFiltersWithCaptions(Vendor);


    end;

    var
        DateText: array[12] of Text;
        StartDate: Date;
        MonthName: array[12] of text[50];
        EndDate: array[12] of Date;
        ClosingBalanceText: array[20] of Text;
        LineAmtArr: array[12] of Decimal;

        ClosingAmtArr: array[12] of Decimal;
        DocAmt: Decimal;
        Vendor: Record Vendor;
        PostedDeferralHeaderPage: Record "Posted Deferral Header";
        GenPostingSetup: record "General Posting Setup";
        PostedNarration: record "Posted Narration";
        GLAcctRec: Record "G/L Account";
        CompanyInfo: Record "Company Information";
        DocNum: code[20];
        GLFilter: Text;
        VendorFilter: Text;
        DocumentFilter: Text;
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        PageCaptionLbl: Label 'Page';
        BalanceCaptionLbl: Label 'This also includes general ledger accounts that only have a balance.';
        PeriodCaptionLbl: Label 'This report also includes closing entries within the period.';
        GLBalCaptionLbl: Label 'Balance';
        DeferralSummaryPurchCaptionLbl: Label 'Deferral Summary - Purchasing';
        RemAmtDefCaptionLbl: Label 'Remaining Amt. Deferred';
        TotAmtDefCaptionLbl: Label 'Total Amt. Deferred';
        BalanceAsOfDateFilter: Date;
        PostingDate: Date;
        AmtRecognized: Decimal;
        RemainingAmtDeferred: Decimal;
        BalanceAsOfDateCaptionLbl: Label 'Balance as of: ';
        AccountNoLbl: Label 'Account No.';
        AmtRecognizedLbl: Label 'Amt. Recognized';
        AccountName: Text[100];
        VendorName: Text[100];
        WorkingVendor: Code[20];
        PreviousVendor: Code[20];
        DeferralAccount: Code[20];
        DocumentTypeString: Text;
        QuoteLbl: Label 'Quote';
        OrderLbl: Label 'Order';
        InvoiceLbl: Label 'Invoice';
        CreditMemoLbl: Label 'Credit Memo';
        BlanketOrderLbl: Label 'Blanket Order';
        ReturnOrderLbl: Label 'Return Order';
        ShipmentLbl: Label 'Shipment';
        PostedInvoiceLbl: Label 'Posted Invoice';
        PostedCreditMemoLbl: Label 'Posted Credit Memo';
        PostedReturnReceiptLbl: Label 'Posted Return Receipt';
        LineDescription: Text[100];
        LineType: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        DocumentCaptionLbl: Label 'Document:';
        VendorCaptionLbl: Label 'Vendor:';
        SnoCap: Label 'S.No';
        El1Cap: Label 'EL 1';
        VoucherDateCap: Label 'Voucher Date';
        VendorNameCap: label 'Vendor Name';
        VoucherNoCap: Label 'Voucher No';
        LinenarrationCap: Label 'Line narration';
        FromCap: Label 'From';
        ToCap: Label 'To';
        PeriodInMonthCap: Label 'Period in months';
        PrepaidExpensesCap: Label 'Prepaid Expenditure';
        ChangePerMonthCap: Label 'Charge per month';
        ClosingBalanceCap: Label 'Closing Balance';
        LoopDate: Date;
        I: Integer;
        FromDateVar: Date;
        TODateVar: Date;
        LineNarrVar: Text;
        ChargePerMonth: Decimal;
        GLAcctNum: Code[20];
        StartDateBefore: Date;
        StartDateBeforeAmt: Decimal;



    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewBalanceAsOfDateFilter: Date; NewDocumentNoFilter: Text; NewVendorNoFilter: Text)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        BalanceAsOfDateFilter := NewBalanceAsOfDateFilter;
        VendorFilter := NewVendorNoFilter;
        DocumentFilter := NewDocumentNoFilter;

    end;

    local procedure ReturnPurchDocTypeString(PurchDocType: Integer): Text
    begin
        case PurchDocType of
            0:
                exit(QuoteLbl);
            1:
                exit(OrderLbl);
            2:
                exit(InvoiceLbl);
            3:
                exit(CreditMemoLbl);
            4:
                exit(BlanketOrderLbl);
            5:
                exit(ReturnOrderLbl);
            6:
                exit(ShipmentLbl);
            7:
                exit(PostedInvoiceLbl);
            8:
                exit(PostedCreditMemoLbl);
            9:
                exit(PostedReturnReceiptLbl);
            else
                exit('');
        end;
    end;
}

