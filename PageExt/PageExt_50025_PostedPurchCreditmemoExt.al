pageextension 50025 PostedPurchaseCreditMemoExt extends "Posted Purchase Credit Memo"
{

    layout
    {
        addlast(General)
        {
            field("Vendor Quote No"; Rec."Vendor Quote No")
            {
                ApplicationArea = all;
            }
            field("Vendor Quote Date"; Rec."Vendor Quote Date")
            {
                ApplicationArea = all;
            }
        }
        addbefore("No.")
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    OrderTypeErr: Label 'You donot change Order Type Value in Document No. %1';

                begin

                    if Rec."No." <> '' then
                        Error(OrderTypeErr, Rec."No.");

                end;
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