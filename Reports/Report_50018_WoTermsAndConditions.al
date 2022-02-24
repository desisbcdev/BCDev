report 50018 "WorkOrderTerms&conditions"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './WorkOrderTermsAndConditions2.docx';
    Caption = 'Work OrderTermsAndConditions';
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
