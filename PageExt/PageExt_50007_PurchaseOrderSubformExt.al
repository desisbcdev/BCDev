pageextension 50007 PurchOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Cost Allocation Rule"; Rec."Cost Allocation Rule")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter(Description)
        {
            field("Line Description"; Rec."Line Description")
            {
                ApplicationArea = all;
            }
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;
        }
        modify("Over-Receipt Code")
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
        modify(AmountBeforeDiscount)
        {
            CaptionClass = PurchaseEvent.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalPurchaseHeader."Prices Including VAT");
            // Caption = 'Subtotal Excl. GST';
        }
        modify("Total Amount Excl. VAT")
        {
            CaptionClass = PurchaseEvent.GetTotalExclVATCaption(Currency.Code);
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Incl. VAT")
        {
            //Caption = 'Total Amount Incl. GST';
            CaptionClass = PurchaseEvent.GetTotalInclVATCaption(Currency.Code);
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }



    }

    actions
    {
        /*
         // Add changes to page actions here
         addafter(OrderTracking)
         {
             action(ImportLines)
             {
                 ApplicationArea = All;
                 Image = Import;
                 PromotedCategory = Process;
                 Promoted = true;

                 trigger OnAction()
                 begin

                     Report.RunModal(50014, true, false);

                 end;
             }
         }
         */

    }

    var

        PurchaseEvent: Codeunit "Purchase Event";
        Currency: Record Currency;
        TotalPurchaseHeader: Record "Purchase Header";

}