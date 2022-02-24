tableextension 50011 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; Signature; Blob)
        {

            DataClassification = CustomerContent;
            Caption = 'Signature';
            SubType = Bitmap;
        }
    }

    var




}