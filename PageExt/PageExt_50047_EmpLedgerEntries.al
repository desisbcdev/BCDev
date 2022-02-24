pageextension 50047 EmpLedgerEntriesExt extends "Employee Ledger Entries"
{
    layout
    {
        addafter(Open)
        {

            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = all;
            }
        }
    }



    var

}