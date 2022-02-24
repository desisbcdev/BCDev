report 50019 "PurchaseOrderTerms&conditions"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './PurchaseOrderTermsAndConditions.docx';
    Caption = 'Purchase OrderTermsAndConditions';
    // PreviewMode = PrintLayout;
    //ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }

        }



    }


}
