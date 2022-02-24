pageextension 50011 PurchCredSubformExt extends "Purch. Cr. Memo Subform"
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
        }

        modify("Line Discount %")
        {
            Visible = false;
        }

        modify("Line Discount Amount")
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

    var
        myInt: Integer;
}