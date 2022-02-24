table 50002 "Cost Allocation Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Cost Allocation No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Dimension.Code where(Blocked = const(false));
        }
        field(3; "Dimension Value Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"
            ), Blocked = const(false));
        }
        field(4; "Allocation %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Cost Allocation No.", "Dimension Code", "Dimension Value Code")
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
    var
        CostAllocation: Record "Cost Allocation Header";
    begin
        CostAllocation.get("Cost Allocation No.");
        CostAllocation.TestField(Locked, false);
    end;

}