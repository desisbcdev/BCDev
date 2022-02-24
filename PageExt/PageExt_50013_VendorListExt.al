pageextension 50013 VendorListExt extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("MSME Applicable"; rec."MSME Applicable")
            {
                ApplicationArea = all;


            }
            field("MSME Certificate No."; rec."MSME Certificate No.")
            {
                ApplicationArea = all;

            }
            field("MSME Validity Date"; rec."MSME Validity Date")
            {
                ApplicationArea = all;

            }
            field("MSMEownedbySC/STEnterpreneur"; rec."MSMEownedbySC/STEnterpreneur")
            {
                ApplicationArea = all;
                Visible = false;

            }
            field(MSMEownedbyWomenEnterpreneur; rec.MSMEownedbyWomenEnterpreneur)
            {
                ApplicationArea = all;
                Visible = false;

            }
            field("PAN Linked with Aadhar"; rec."PAN Linked with Aadhar")
            {
                ApplicationArea = all;
            }
            field("Specified Vendor"; Rec."Specified Vendor")
            {
                ApplicationArea = all;
            }
        }
    }



}