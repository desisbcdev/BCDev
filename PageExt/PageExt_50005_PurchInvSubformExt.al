pageextension 50005 PurchInvSubformExt extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Cost Allocation Rule"; Rec."Cost Allocation Rule")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Line Description"; Rec."Line Description")
            {
                ApplicationArea = all;
            }
        }

        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }

        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            CaptionClass = PurchaseEvent.GetTotalExclVATCaption(Currency.Code);
        }

        modify("Total Amount Incl. VAT")
        {

            CaptionClass = PurchaseEvent.GetTotalInclVATCaption(Currency.Code);
        }

        modify(AmountBeforeDiscount)
        {
            CaptionClass = PurchaseEvent.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, PurchaseHeader."Prices Including VAT");


            // Caption = 'Subtotal Excl. GST';
        }

        modify("Line Discount %")
        {
            Visible = false;
        }

        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify(Exempted)
        {
            Visible = false;
        }

        modify("GST Assessable Value")
        {
            Visible = false;
        }

        modify("Custom Duty Amount")
        {
            Visible = false;
        }

        modify("Qty. Assigned")
        {
            Visible = false;
        }









    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetCurrRecord()
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            if not Currency.Get(PurchaseHeader."Currency Code") then
                clear(Currency);
    end;







    var
        PurchaseEvent: Codeunit "Purchase Event";
        Currency: Record Currency;
        PurchaseHeader: record "Purchase Header";
}