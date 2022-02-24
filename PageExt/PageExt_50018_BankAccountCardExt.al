pageextension 50018 BankAccountCardExt extends "Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field("IFSC Code"; rec."IFSC Code")
            {
                ApplicationArea = all;
            }
            field(KotakBank; Rec.KotakBank)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}