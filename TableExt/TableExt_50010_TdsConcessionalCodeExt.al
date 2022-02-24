tableextension 50010 TdsConcessionalCodeExt extends "TDS Concessional Code"
{
    fields
    {
        modify("Concessional Code")
        {
            trigger OnAfterValidate()
            begin
                TdsRates.reset;
                //TdsRates.SetRange(s);
            end;
        }
        field(50000; "Concession Status"; Option)
        {
            OptionMembers = Open,Closed;
            OptionCaption = 'Open,Closed';
            DataClassification = ToBeClassified;

        }
        field(50001; "Concession Validity Period"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Concession Validity Period';
        }
        field(50002; "Concession Limit amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            caption = 'Concession Limit amount';
        }
        field(50003; "Concession Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            caption = 'Concession Percentage';

        }
        field(50004; "Specified Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Specified Vendor';

        }
    }

    var
        TdsRates: Record "Tax Rate";
        TaxRate: page "Tax Rates";
}