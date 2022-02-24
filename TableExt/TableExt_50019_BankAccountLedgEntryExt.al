tableextension 50019 BankAccountLedgerEntryExt extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50100; "U.T.R.No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'U.T.R.No.';
        }
    }

    var
        myInt: Integer;
}