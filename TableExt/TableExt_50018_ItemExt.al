tableextension 50018 ItemExt extends Item
{
    fields
    {
        field(50000; "Line Description"; Text[1024])
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Description';
        }
    }

    var
        myInt: Integer;
}