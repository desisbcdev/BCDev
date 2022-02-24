pageextension 50021 PostedPurchCrMemoSubformExt extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Cost Allocation Rule"; Rec."Cost Allocation Rule")
            {
                ApplicationArea = all;
            }
            field("Line Description"; Rec."Line Description")
            {
                ApplicationArea = all;
            }
            field(Narration; Rec.Narration)
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