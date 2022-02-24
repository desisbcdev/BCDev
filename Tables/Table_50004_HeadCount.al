table 50004 "Head Count"
{
    DataClassification = ToBeClassified;
    Caption = 'Head Count';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;


        }
        field(2; "Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Date <> 0D then begin
                    Month := Date2DMY("Date", 2);
                    Year := Date2DMY("Date", 3);
                end;
            end;
        }
        field(3; Month; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Year; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "No. Of Employees Joined"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No. Of Employees Present"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Total Employees Present"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        HeadCount: Record "Head Count";

    trigger OnInsert()
    begin
        HeadCount.Reset();
        if HeadCount.FindLast() then
            "Entry No." := HeadCount."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}