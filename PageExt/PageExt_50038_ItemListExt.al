pageextension 50038 ItemListExt extends "Item List"
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
}