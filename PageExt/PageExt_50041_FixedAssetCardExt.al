pageextension 50041 FixedAssetCardExt extends "Fixed Asset Card"
{
    layout
    {
        addlast(General)
        {
            field("Purchase Type"; Rec."Purchase Type")
            {
                ApplicationArea = all;
            }
            field("Part Number"; Rec."Part Number")
            {
                ApplicationArea = all;
            }
            field("Desis Asset No."; Rec."Desis Asset No.")
            {
                ApplicationArea = all;
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