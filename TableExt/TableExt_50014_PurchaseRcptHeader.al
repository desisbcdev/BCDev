tableextension 50014 "Purch. Rcpt. HeaderExt" extends "Purch. Rcpt. Header"
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
        field(50009; Subject; text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Subject';
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
        field(50018; "Specified Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Specified Vendor';
            Editable = false;
        }

        field(50020; "PI Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'PI Date';
            Editable = false;
        }

        field(50022; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Invoice Date';
            Editable = false;
        }



    }

    var

}