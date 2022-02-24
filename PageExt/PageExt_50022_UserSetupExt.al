pageextension 50022 UserSetupExt extends "User Setup"
{

    layout
    {

        addlast(Control1)
        {

            field(Signature; Rec.Signature)
            {
                ApplicationArea = All;

            }
        }

    }



    actions
    {
        addlast(Processing)
        {
            action("Import Signature")
            {
                ApplicationArea = All;
                Caption = 'Import Signature';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UserSetup.Reset();
                    UserSetup.setrange("User ID", rec."User ID");
                    if usersetup.FindFirst() then
                        page.RunModal(50005, UserSetup);
                end;
            }

        }
    }

    var
        UserSetupCard: Page "User Setup Card";
        UserSetup: Record "User Setup";
}