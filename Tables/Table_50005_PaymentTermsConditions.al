table 50005 "Payment Terms Conditions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line Type"; Option)
        {
            OptionMembers = ,Payment,Taxes,"Terms & Conditions",Maintenance,"Billing & Installation Address","Delivery & Installation",Warranty,"Liquidated Damages","Delivery Address",Completion,"Completion Timelines",Others,"Shifting Date",Packing,"ManPower Requirement","Delivery&Completion",Delivery,"Billing Address","Shipping Address","Billing&DeliveryAddress","Support Period","Payment Terms","Nature Of Work","Total AMC Value Yearly","AMC Period","Total Contract Value","Contract Period","Contract Value";
            OptionCaption = ' ,Payment,Taxes,Terms & Conditions,Maintenance,Billing & Installation Address,Delivery & Installation,Warranty,Liquidated Damages,Delivery Address,Completion,Completion Timelines,Others,Shifting Date,Packing,ManPower Requirement,Delivery&Completion,Delivery,Billing Address,Shipping Address,Billing&DeliveryAddress,Support Period,Payment Terms,Nature Of Work,Total AMC Value Yearly,AMC Period,Total Contract Value,Contract Period,Contract Value';
        }
        field(3; Description; Text[200])
        {

        }
        field(4; "Order Type"; Enum "OrderType")
        {
            DataClassification = ToBeClassified;
        }
        field(5; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Pk; "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        PaymentTerms: Record "Payment Terms Conditions";

    trigger OnInsert()
    begin
        PaymentTerms.Reset();
        if PaymentTerms.FindLast() then
            "Line No." := PaymentTerms."Line No." + 1
        else
            "Line No." := 1;

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