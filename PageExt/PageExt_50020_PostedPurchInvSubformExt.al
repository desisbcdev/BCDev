pageextension 50020 PostedPurchInvSubformExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Cost Allocation Rule"; Rec."Cost Allocation Rule")
            {
                ApplicationArea = all;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
            /*    field("Line Description"; Rec."Line Description")
               {
                   ApplicationArea = all;
               } */
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}