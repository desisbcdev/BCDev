table 50001 "Cost Allocation Header"
{
    DataClassification = CustomerContent;
    LookupPageId = "Cost Allocation Rules";
    DrillDownPageId = "Cost Allocation Rules";

    fields
    {
        field(1; "Cost Allocation No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Allocation Code';

        }
        field(2; Locked; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Cost Allocation No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        CheckTableLoked();
    end;

    trigger OnModify()
    begin
        CheckTableLoked();
    end;

    trigger OnDelete()
    begin
        CheckTableLoked();
    end;

    trigger OnRename()
    begin
        CheckTableLoked();
    end;

    procedure CheckTableLoked()
    begin
        TestField(Locked, false);
    end;

}