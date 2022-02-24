tableextension 50028 GenJnlBatchExt extends "Gen. Journal Batch"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Auto Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Auto Posting';
        }
    }

    var
        myInt: Integer;
}