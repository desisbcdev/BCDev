tableextension 50026 SalesCreditMemoExt extends "Sales Cr.Memo Header"
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