pageextension 50046 GenJnlBatchExt extends "General Journal Batches"
{
    layout
    {
        // Add changes to page layout here

        addafter("Reason Code")
        {
            field("Auto Posting"; Rec."Auto Posting")
            {

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