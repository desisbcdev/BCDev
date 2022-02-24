pageextension 50019 TdsConcessionalCodeExt extends "TDS Concessional Codes"
{
    layout
    {
        addlast(General)
        {
            field("Concession Status"; Rec."Concession Status")
            {
                ApplicationArea = all;
            }
            field("Concession Validity Period"; Rec."Concession Validity Period")
            {
                ApplicationArea = all;
            }
            field("Concession Limit amount"; Rec."Concession Limit amount")
            {
                ApplicationArea = all;
            }
            field("Concession Percentage"; Rec."Concession Percentage")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Specified Vendor"; rec."Specified Vendor")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}