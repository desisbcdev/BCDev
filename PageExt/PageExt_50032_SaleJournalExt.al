pageextension 50032 SaleJournalExt extends "Sales Journal"
{
    layout
    {
        modify("Reason Code")
        {
            Visible = true;
        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                rec.TestField("Reason Code");
            end;
        }
    }

    var
        myInt: Integer;
}