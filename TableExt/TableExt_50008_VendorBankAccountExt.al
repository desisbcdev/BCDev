tableextension 50008 VendorBankAccountExt extends "Vendor Bank Account"
{
    fields
    {
        field(50000; "IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'IFSC Code';
        }
        field(50005; KotakBank; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'KotakBank';
        }
    }


}