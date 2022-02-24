pageextension 50043 PurchReturnOrderExt extends "Purchase Return Order"
{
    layout
    {
        // Add changes to page layout here

        modify("Buy-from Vendor No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
            begin
                Rec.VendorLookup()
            end;

        }

        modify("Buy-from Vendor Name")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
            begin

                Rec.VendorLookup();

            end;
        }
    }





}