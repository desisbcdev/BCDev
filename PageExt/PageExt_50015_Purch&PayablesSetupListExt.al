pageextension 50015 "Purch & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("MSME - Payment Days"; Rec."MSME - Payment Days")
            {
                ApplicationArea = all;
            }

            field("Work Order No. Series"; Rec."Work Order No. Series")
            {
                ApplicationArea = all;

            }
            field("AMC Order No. Series"; rec."AMC Order No. Series")
            {
                ApplicationArea = All;
            }
            field("Maintenancecontract No. Series"; rec."Maintenancecontract No. Series")
            {
                ApplicationArea = all;
            }
            field("Payment Journal Template Name"; Rec."Payment Journal Template Name")
            {
                ApplicationArea = all;
            }
            field("Payment Journal Batch Name"; Rec."Payment Journal Batch Name")
            {
                ApplicationArea = all;
            }
            field("FD No Series"; Rec."FD No Series")
            {
                ApplicationArea = all;
            }

            field("Fixed Deposit Jnl. Tem. Name"; Rec."Fixed Deposit Jnl. Tem. Name")
            {
                ApplicationArea = all;

            }

            field("Fixed Deposit Jnl. Batch Name"; Rec."Fixed Deposit Jnl. Batch Name")
            {
                ApplicationArea = all;

            }
        }
    }


}