pageextension 50017 VendorBankAccountCardExt extends "Vendor Bank Account Card"
{
    layout
    {
        addlast(Transfer)
        {
            field("IFSC Code"; Rec."IFSC Code")
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