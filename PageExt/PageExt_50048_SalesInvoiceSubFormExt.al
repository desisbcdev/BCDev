pageextension 50048 SaleInvoiceSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }

        modify("Line Discount %")
        {
            Visible = false;
        }

        modify("GST Assessable Value (LCY)")
        {
            Visible = false;
        }

        modify("GST on Assessable Value")
        {
            Visible = false;
        }

        modify("GST Place Of Supply")
        {
            Visible = false;
        }

        modify(Exempted)
        {
            Visible = false;
        }

















    }




}