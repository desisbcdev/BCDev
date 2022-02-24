pageextension 50045 SalesReceivableSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here

        addlast(General)
        {
            field("Sales Invoice No. Series"; Rec."Sales Invoice No. Series")
            {

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