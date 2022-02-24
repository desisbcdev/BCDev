tableextension 50017 CustomerTableExt extends Customer
{
    fields
    {
        field(50000; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Pending for Approval",Released;
            OptionCaption = 'Open,Pending for Approval,Released';
        }
    }

    var

}