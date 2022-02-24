tableextension 50027 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {

        field(50006; "Sales Invoice No. Series"; Code[10])
        {
            Caption = 'Sales Invoice No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }






    }

    var

}