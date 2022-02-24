tableextension 50016 PurchaseRcptLineEXt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50006; Narration; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }

    }

    var

}