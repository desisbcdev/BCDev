tableextension 50002 PurchInvLineExt extends "Purch. Inv. Line"
{
    fields
    {
        field(50001; "Cost Allocation Rule"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Cost Allocation Header"."Cost Allocation No." where(Locked = const(false));
            Caption = 'Cost Allocation Rule';
        }

        field(50005; "Line Description"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Description';

        }
        field(50006; Narration; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }

    }

    var

}