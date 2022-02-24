tableextension 50004 GLEntryExt extends "G/L Entry"
{
    fields
    {
        field(50000; "Cost Allocation Rule"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Cost Allocation Header"."Cost Allocation No." where(Locked = const(true));
            Caption = 'Cost Allocation Rule';

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

    var

}