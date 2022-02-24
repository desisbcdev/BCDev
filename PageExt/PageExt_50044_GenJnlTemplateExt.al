pageextension 50044 GenJnlTemplateExt extends "General Journal Templates"
{
    layout
    {
        // Add changes to page layout here

        modify("Force Doc. Balance")
        {
            Visible = false;
        }

        modify("Copy VAT Setup to Jnl. Lines")
        {
            Visible = false;
        }
        modify("Allow VAT Difference")
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var

}