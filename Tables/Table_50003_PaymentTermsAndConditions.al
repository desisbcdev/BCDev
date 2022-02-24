table 50003 "Payment Terms And Conditions"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; DocumentType; Option)
        {
            OptionMembers = Order,Invoice,Receipt;
            OptionCaption = 'Order,Invoice,Receipt';
            DataClassification = ToBeClassified;

        }
        field(2; DocumentNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; LineType; Option)
        {
            OptionMembers = ,Payment,Taxes,"Terms & Conditions",Maintenance,"Billing & Installation Address","Delivery & Installation",Warranty,"Liquidated Damages","Delivery Address",Completion,"Completion Timelines",Others,"Shifting Date",Packing,"ManPower Requirement","Delivery&Completion",Delivery,"Billing Address","Shipping Address","Billing&DeliveryAddress","Support Period","Payment Terms","Nature Of Work","Total AMC Value Yearly","AMC Period","Total Contract Value","Contract Period","Contract Value";
            OptionCaption = ' ,Payment,Taxes,Terms & Conditions,Maintenance,Billing & Installation Address,Delivery & Installation,Warranty,Liquidated Damages,Delivery Address,Completion,Completion Timelines,Others,Shifting Date,Packing,ManPower Requirement,Delivery&Completion,Delivery,Billing Address,Shipping Address,Billing&DeliveryAddress,Support Period,Payment Terms,Nature Of Work,Total AMC Value Yearly,AMC Period,Total Contract Value,Contract Period,Contract Value';
        }
        Field(5; Description; Text[200])
        {

        }
        field(6; "Order Type"; Enum "OrderType")
        {
            DataClassification = ToBeClassified;
        }
        field(7; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; DocumentType, DocumentNo, LineNo)
        {
            Clustered = true;
        }

    }

    var
        myInt: Integer;



    trigger OnInsert()
    begin

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