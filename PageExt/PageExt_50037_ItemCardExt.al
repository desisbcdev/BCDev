pageextension 50037 ItemCardExt extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Line Description"; Rec."Line Description")
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