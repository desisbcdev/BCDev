pageextension 50012 PurchCreditExt extends "Purchase Credit Memo"
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

    actions
    {
        modify(Preview)
        {
            Visible = false;
        }


        addafter(PostAndPrint)
        {
            action("Preview Cost Allocation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                var
                    PurchPostYesNo: Codeunit "Purch.-Post Cost AllocationNew";
                begin
                    PurchPostYesNo.PurchasePostPreview(PurchPostYesNo, Rec);
                end;
            }
        }
    }

    var

}