pageextension 50016 VendorBankAccountListExt extends "Vendor Bank Account List"
{
    layout
    {
        addlast(Control1)
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