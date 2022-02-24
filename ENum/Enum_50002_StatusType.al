enum 50002 StatusType
{
    Extensible = true;
    value(0; "Not Yet Invoiced")


    { Caption = 'Not Yet Invoiced'; }



    value(1; "Partially Invoiced")
    {
        Caption = 'Partially Invoiced';
    }
    value(2; "Completely Invoiced")
    {
        Caption = 'Completely Invoiced';
    }
    value(3; "Cancelled")
    {
        Caption = 'Cancelled';
    }

    value(4; "Short Closed")
    {
        Caption = 'Short Closed';
    }

    value(5; "Partially Received")
    {
        Caption = 'Partially Received';
    }

    value(6; "Fully Received Not Invoiced")
    {
        Caption = 'Fully Received Not Invoiced';
    }





}