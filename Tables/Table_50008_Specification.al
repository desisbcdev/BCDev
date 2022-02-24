table 50008 Specification
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; DocumentType; Option)
        {
            OptionMembers = Order,Invoice,Receipt;
            OptionCaption = 'Order,Invoice,Receipt';
            DataClassification = ToBeClassified;

        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }

        field(7; "Serial No./Product Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Serial No./Product Code';
        }


        field(9; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        field(11; Qty; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            Caption = 'Qty';
            trigger OnValidate()
            var

            begin

                CalculateAmt();

            end;
        }

        field(15; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'UOM';

        }
        field(17; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Cost';
            DecimalPlaces = 0 : 2;
            trigger OnValidate()
            var

            begin

                CalculateAmt();

            end;

        }
        field(19; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            Caption = 'Amount';
        }









    }

    keys
    {
        key(PK; DocumentType, "Document No.", "Line No.")
        {
            Clustered = true;
        }

    }

    var




    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure CalculateAmt()
    begin
        Amount := Round(Qty * "Unit Cost", 0.01)
    end;

}