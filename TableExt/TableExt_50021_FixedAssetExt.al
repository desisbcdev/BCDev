tableextension 50021 FixedAssetExt extends "Fixed Asset"
{
    fields
    {
        field(50000; "Purchase Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Domestic,Foriegn;
            OptionCaption = ' ,Domestic,Foriegn';
        }
        field(50001; "Part Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Part Number';
        }

        field(50005; "Desis Asset No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Desis Asset No.';
        }

    }

    var
        myInt: Integer;
}