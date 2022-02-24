tableextension 50001 PurchaseLineExt extends "Purchase Line"
{

    fields
    {
        field(50001; "Cost Allocation Rule"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Cost Allocation Header"."Cost Allocation No." where(Locked = const(true));
            Caption = 'Cost Allocation Rule';

        }


        field(50005; "Line Description"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Description';

        }
        field(50006; Narration; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if Type = Type::Item then begin
                    if Item.Get("No.") then begin
                        if Item."Line Description" = '' then
                            "Line Description" := Description
                        else
                            "Line Description" := Item."Line Description";

                    end;
                end else begin
                    "Line Description" := Description;
                end;
            end;
        }

        modify("TDS Section Code")
        {

            trigger OnAfterValidate()
            begin

                CheckTDSLimitAmt();


            end;

        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var

            begin
                CheckTDSLimitAmt();

            end;
        }



    }

    trigger OnBeforeModify()
    var
    begin
        if "Document Type" = "Document Type"::Order then
            LineCheckStatusType();
    end;



    trigger OnBeforeDelete()
    var
    begin
        if "Document Type" = "Document Type"::Order then
            LineCheckStatusType();

    end;

    trigger OnBeforeInsert()
    var
    begin
        if "Document Type" = "Document Type"::Order then
            LineCheckStatusType();

        if "Document Type" = "Document Type"::Invoice then
            "GST Credit" := "GST Credit"::Availment;
    end;

    trigger OnAfterInsert()
    var
    begin

        if "Document Type" = "Document Type"::Invoice then
            "GST Credit" := "GST Credit"::Availment;
    end;

    procedure LineCheckStatusType()
    var
        PurchaseHeader: Record "Purchase Header";

    begin

        PurchaseHeader.reset;
        PurchaseHeader.setrange("Document Type", "Document Type");
        PurchaseHeader.setrange("No.", "Document No.");
        if PurchaseHeader.FindFirst then
            PurchaseHeader.CheckStatusType();

    end;


    Procedure CheckTDSLimitAmt()
    begin


        Clear(CurrAmt);
        Clear(PreviousInvAmount);

        PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
        Vendor.Get("Buy-from Vendor No.");
        if (PurchaseHeader."Posting Date" <> 0D) and ("TDS Section Code" <> '') and CheckTDSSectionCode194Q() then begin
            StDate := DMY2DATE(1, 4, DATE2DMY(PurchaseHeader."Posting Date", 3));
            IF DATE2DMY(PurchaseHeader."Posting Date", 2) IN [1 .. 3] THEN
                StDate := DMY2DATE(1, 4, DATE2DMY(PurchaseHeader."Posting Date", 3) - 1);
            EndDate := DMY2DATE(31, 3, DATE2DMY(StDate, 3) + 1);

            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code", Applied);

            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", "Buy-from Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee PAN No.", Vendor."P.A.N. No.");
            TDSEntry.SetRange("Posting Date", StDate, EndDate);
            TDSEntry.SETRANGE(Section, "TDS Section Code");
            TDSEntry.SETRANGE(Applied, FALSE);
            IF TDSEntry.FindSet() THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount");
                PreviousInvAmount := ABS(TDSEntry."Invoice Amount");
            END;

            PurchaseLine.reset;
            PurchaseLine.setrange("Document Type", "Document Type");
            PurchaseLine.setrange("Document No.", "Document No.");
            PurchaseLine.setfilter(Quantity, '<>%1', 0);
            PurchaseLine.SetFilter("Line No.", '<>%1', "Line No.");
            PurchaseLine.setrange("TDS Section Code", Rec."TDS Section Code");
            if PurchaseLine.FindSet then
                repeat
                    CurrAmt += PurchaseLine."Line Amount";
                until PurchaseLine.Next = 0;
            TaxTransactionValue.Reset;
            TaxTransactionValue.Setrange("Tax Record ID", Rec.RecordId);
            TaxTransactionValue.Setrange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.Setrange("Value ID", 1);
            TaxTransactionValue.setrange("Tax Type", 'TDS');
            if TaxTransactionValue.FindFirst() then
                TDSRateVar := TaxTransactionValue.Percent
            else
                TDSRateVar := 0;


            if (PreviousInvAmount + "Line Amount" + CurrAmt) > 5000000 then
                Message(TDS194QMsg, Vendor.Name, rec."TDS Section Code", TdsRateVar, 5000000);


        end;

    end;

    procedure CheckTDSSectionCode194Q(): Boolean
    begin

        if TDSSectionRec.Get("TDS Section Code") and (TDSSectionRec."Parent Code" = '194Q') then
            Exit(true)
        else
            Exit(false)


    end;









    var
        Item: Record Item;
        TDSEntry: record "TDS Entry";
        Vendor: Record Vendor;
        PreviousInvAmount: Decimal;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        TDSSectionRec: Record "TDS Section";
        TaxTransactionValue: Record "Tax Transaction Value";
        TdsRateVar: Decimal;


        StDate: Date;
        EndDate: Date;
        CurrAmt: Decimal;

        TDS194QMsg: Label 'Vendor: %1 has TDS Lower deduction certificate under %2 at %3 has exceeded the defined limit of %4';


}