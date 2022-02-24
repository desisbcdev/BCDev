tableextension 50007 "Purchase & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "MSME - Payment Days"; DateFormula)
        {
            Caption = 'MSME - Payment Days';
            DataClassification = CustomerContent;
        }

        field(50005; "Work Order No. Series"; Code[10])
        {
            Caption = 'Work Order No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50006; "AMC Order No. Series"; Code[10])
        {
            Caption = 'AMC Order No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50007; "Maintenancecontract No. Series"; Code[10])
        {
            Caption = 'Maintenancecontract No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

        field(50010; "Payment Journal Template Name"; Code[10])
        {
            Caption = 'Payment Journal Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }

        field(50012; "Payment Journal Batch Name"; Code[10])
        {
            Caption = 'Payment Journal Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Journal Template Name"));
        }
        field(50013; "FD No Series"; code[20])
        {
            Caption = 'FD No Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

        field(50015; "Fixed Deposit Jnl. Tem. Name"; Code[10])
        {
            Caption = 'Fixed Deposit Jnl. Tem. Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }

        field(50020; "Fixed Deposit Jnl. Batch Name"; Code[10])
        {
            Caption = 'Fixed Deposit Jnl. Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Fixed Deposit Jnl. Tem. Name"));
        }
    }

    var

}