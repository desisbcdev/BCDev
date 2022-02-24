tableextension 50009 BankAccountExt extends "Bank Account"
{
    fields
    {
        field(50000; "IFSC Code"; code[20])
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

    var

}