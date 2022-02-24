tableextension 50003 GenJnlLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Cost Allocation Rule"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Cost Allocation Header"."Cost Allocation No." where(Locked = const(true));
            Caption = 'Cost Allocation Rule';

            trigger OnValidate()
            var
                CostAllErr: Label 'Bal. Account No. field must be blank if Cost Allocation Rule is defined';
            begin
                if "Bal. Account No." <> '' then
                    Error(CostAllErr);
            end;
        }

        field(50015; "Fixed Deposit No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Deposit";
            Caption = 'Fixed Deposit No.';
            Editable = false;


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



    /* 

    Field 50010 used in Posted Gen. Journal Line donot used that field ID in this table.
    */


    var

}