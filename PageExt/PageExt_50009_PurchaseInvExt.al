pageextension 50009 PurchinvExt extends "Purchase Invoice"
{
    layout
    {
        modify("Reason Code")
        {
            Visible = true;
        }
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

        modify("Purchaser Code")
        {
            Visible = false;
        }


        modify("Campaign No.")
        {
            Visible = false;
        }

        modify("Responsibility Center")
        {
            Visible = false;
        }

        addlast(General)
        {
            field("MSME Certificate No."; Rec."MSME Certificate No.")
            {
                ApplicationArea = all;
            }
            field("MSME Validity Date"; Rec."MSME Validity Date")
            {
                ApplicationArea = all;
            }

        }
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = All;

            }
        }

        addafter("Supply Finish Date")
        {
            field("Specified Vendor"; Rec."Specified Vendor")
            {
                ApplicationArea = all;
            }


        }
        addlast(factboxes)
        {
            part("Buy-From Vendor Hist."; "Vendor Hist. Buy-from FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No."),
                              "Date Filter" = field("Date Filter");
            }
            part(Transcationcount; TransactionCount)
            {
                ApplicationArea = all;
                SubPageView = WHERE("Document Type" = CONST(Invoice));
                SubPageLink = "Vendor No." = field("Buy-from Vendor No.");
                Visible = true;
            }
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
                PromotedCategory = Category6;
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                var
                    PurchPostYesNo: Codeunit "Purch.-Post Cost AllocationNew";
                begin
                    PurchPostYesNo.PurchasePostPreview(PurchPostYesNo, Rec);
                end;
            }
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                // rec.TestField("Reason Code");
                Rec.Testfield("Shortcut Dimension 1 Code");
                Rec.Testfield("Shortcut Dimension 2 Code");
                rec.Testfield("Vendor Posting Group");
            end;
        }



    }

    var
        myInt: Integer;
}