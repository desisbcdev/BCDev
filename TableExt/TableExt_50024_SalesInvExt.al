tableextension 50024 SalesInvExt extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Sales Invoice No."; COde[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Invoice No.';
        }
    }

    var

}