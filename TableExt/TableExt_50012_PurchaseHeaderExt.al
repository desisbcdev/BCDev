tableextension 50012 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50000; "Vendor Quote No"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Quote No';
        }
        field(50001; "Vendor Quote Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Quote Date';
        }

        field(50005; "Order Type"; Enum "OrderType")
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Type';
        }

        field(50008; "Status Type"; Enum StatusType)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Status Type';

        }
        field(50009; Subject; text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Subject';
        }
        field(50010; "Report View"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Report View';
            OptionMembers = " ",Po,"Po GstNo.","Po Product","Po Service","Po Report","Work Order","Work Order1","Work Order2","Work Order3","Work Order4","Work Order5","Work Order6","AMC Order1","AMC Order2","AMC Order3","AMC Order4","AMC Order5","AMC Order6";
            OptionCaption = ' ,Po,Po GstNo.,Po Product,Po Service,Po Report,Work Order1,Work Order2,Work Order3,Work Order4,Work Order5,Work Order6,AMC Order1,AMC Order2,AMC Order3,AMC Order4,AMC Order5,AMC Order6';
        }
        field(50011; "MSME Certificate No."; Code[20])
        {
            Caption = 'MSME Certificate No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

            end;
        }
        field(50012; "MSME Validity Date"; Date)
        {
            Caption = 'MSME Validity Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

            end;
        }

        field(50014; "Cancel ShortClose Appr. Status"; Enum "Approval Type Status")
        {
            Caption = 'Cancel ShortClose Appr. Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50016; "Cancel ShortClose Type"; Enum CancelShortCloseType)
        {

            Caption = 'Cancel ShortClose Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestField("Cancel Shortclose Appr. Status", "Cancel Shortclose Appr. Status"::Open);
            end;

        }

        field(50018; "Specified Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Specified Vendor';
            Editable = false;
        }

        modify("Buy-from Vendor No.")
        {


            trigger OnAfterValidate()
            var
                VendLE: Record "Vendor Ledger Entry";
                Vend: Record Vendor;
                PendingAmt: Decimal;
                AdvanceAmount: Decimal;
                CreditMemoAmt: Decimal;
                PrepaymentMsg: Label 'Vendor: %1 has unadjusted advance of %2';
                CreditMemoMsg: Label 'Vendor: %1 has unadjusted debit balance/credit memo of %2';
            begin
                Clear(PendingAmt);
                Clear(CreditMemoAmt);
                If Vend.get("Buy-from Vendor No.") then begin

                    "MSME Certificate No." := Vend."MSME Certificate No.";
                    "MSME Validity Date" := Vend."MSME Validity Date";
                    "Specified Vendor" := Vend."Specified Vendor";
                    Vend.TestField("Approval Status", Vend."Approval Status"::Released);

                end;
                if ("Buy-from Vendor No." <> '') then begin
                    if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Invoice) then begin

                        VendLE.Reset;
                        VendLE.setrange("Vendor No.", "Buy-from Vendor No.");
                        VendLE.setrange("Document Type", VendLE."Document Type"::Invoice);
                        VendLE.setrange(Open, true);
                        VendLE.setrange(Prepayment, true);
                        if VendLE.FindSet() then
                            repeat
                                VendLE.CalcFields("Remaining Amount");
                                PendingAmt += abs(VendLE."Remaining Amount");
                            until VendLE.Next = 0;

                        VendLE.Reset;
                        VendLE.setrange("Vendor No.", "Buy-from Vendor No.");

                        VendLE.setrange(Open, true);
                        VendLE.SetFilter("Reason Code", 'ADVANCE');

                        if VendLE.FindSet() then
                            repeat
                                VendLE.CalcFields("Remaining Amount");
                                PendingAmt += abs(VendLE."Remaining Amount");
                            until VendLE.Next = 0;
                        if PendingAmt <> 0 then
                            Message(PrepaymentMsg, vend.Name, PendingAmt);
                    end;

                    VendLE.Reset;
                    VendLE.setrange("Vendor No.", "Buy-from Vendor No.");
                    VendLE.setrange("Document Type", VendLE."Document Type"::"Credit Memo");
                    VendLE.setrange(Open, true);
                    if VendLE.FindSet() then
                        repeat
                            VendLE.CalcFields("Remaining Amount");
                            CreditMemoAmt += VendLE."Remaining Amount";
                        until VendLE.Next = 0;
                    if CreditMemoAmt <> 0 then
                        Message(CreditMemoMsg, Vend.Name, CreditMemoAmt);
                end;

            end;

        }

        field(50020; "PI Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'PI Date';
        }

        field(50022; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Invoice Date';
        }



    }


    trigger OnBeforeInsert()
    var
        OrderTypeInsertErr: Label 'Document Order type must not be empty';
    begin
        if "Document Type" = "Document Type"::Order then begin

            if "Order Type" = "Order Type"::" " then
                Error(OrderTypeInsertErr);
        end;
    end;




    trigger OnBeforeModify()
    var
    begin

        CheckStatusType();
    end;

    trigger OnBeforeDelete()
    var
    begin
        CheckStatusType();

    end;



    procedure CheckStatusType()
    var
        StatusTypeErr: Label 'Approval Type Status %1 becuase of modification not allowed';
    begin

        if ("Document Type" = "Document Type"::Order) and (("Cancel Shortclose Appr. Status" = "Cancel Shortclose Appr. Status"::Cancelled)
           or ("Cancel Shortclose Appr. Status" = "Cancel Shortclose Appr. Status"::"Short Closed") or ("Cancel Shortclose Appr. Status" = "Cancel Shortclose Appr. Status"::"Pending Approval")) then
            Error(strsubstno(StatusTypeErr, "Cancel Shortclose Appr. Status"));

    end;

    Procedure VendorLookup()
     VendRec: Record Vendor;
    begin

        VendRec.Reset();
        VendRec.Setrange("Approval Status", VendRec."Approval Status"::Released);
        VendRec.Setrange(Blocked, VendRec.Blocked::" ");
        if Page.RunModal(Page::"vendor List", VendRec) = Action::LookupOK then
            Rec.Validate("Buy-from Vendor No.", VendRec."No.");


    end;

    procedure CheckDocQtyReceiveLineExist()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset;
        PurchaseLine.Setrange("Document Type", Rec."Document Type");
        PurchaseLine.setrange("Document No.", Rec."No.");
        PurchaseLine.setfilter(Quantity, '<>%1', 0);
        PurchaseLine.setfilter("Quantity Received", '<>%1', 0);
        if PurchaseLine.findfirst then
            Error(QtyReceivedLineExist);


    end;

    procedure CheckDocLineReceivedInvoicedEqual()
    var
        PurchaseLine: Record "Purchase Line";
        QtyNotEqualLineExist: Boolean;
    begin
        Clear(QtyNotEqualLineExist);
        PurchaseLine.Reset;
        PurchaseLine.Setrange("Document Type", Rec."Document Type");
        PurchaseLine.Setrange("Document No.", Rec."No.");
        PurchaseLine.Setfilter(Quantity, '<>%1', 0);
        if PurchaseLine.Findset then
            repeat
                if PurchaseLine."Quantity Received" <> PurchaseLine."Quantity Invoiced" then
                    QtyNotEqualLineExist := true;
            until (PurchaseLine.Next = 0) or (QtyNotEqualLineExist);
        if QtyNotEqualLineExist then
            Error(ShortCloseApprovalErr);


    end;

    procedure ImportSpecificationLines()
    var
        PurchaseSpecification: report "Purchase Specification Excel";

    begin
        clear(PurchaseSpecification);
        PurchaseSpecification.SetValues(Rec);
        PurchaseSpecification.RunModal();


    end;


    Var
        QtyReceivedLineExist: Label 'Document Line have Qty.Received value exist beacuse of Cancel process not done';
        ShortCloseApprovalErr: Label 'Document Line Qty Received and Invoiced are not same beacuse of shortclose process not done ';

}