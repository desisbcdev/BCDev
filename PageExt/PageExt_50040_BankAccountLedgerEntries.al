pageextension 50040 BankAccountLedgerEntryExt extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("U.T.R.No."; Rec."U.T.R.No.")
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