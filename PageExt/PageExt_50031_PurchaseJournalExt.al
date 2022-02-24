pageextension 50031 PurchaseJournalExt extends "Purchase Journal"
{
    layout
    {
        modify("Reason Code")
        {
            Visible = true;
        }
        modify("External Document No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."External Document No." <> '') and (rec."Account No." <> '') then begin
                    PurcHInvHdrGvar.Reset();
                    PurcHInvHdrGvar.SetRange("Buy-from Vendor No.", rec."Account No.");
                    PurcHInvHdrGvar.SetRange("Vendor Invoice No.", rec."External Document No.");
                    if PurcHInvHdrGvar.FindFirst() then begin
                        Message(StrSubstNo(Text001, PurcHInvHdrGvar."No."));
                    end;
                end;
            end;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."External Document No." <> '') and (rec."Account No." <> '') then begin
                    PurcHInvHdrGvar.Reset();
                    PurcHInvHdrGvar.SetRange("Buy-from Vendor No.", rec."Account No.");
                    PurcHInvHdrGvar.SetRange("Vendor Invoice No.", rec."External Document No.");
                    if PurcHInvHdrGvar.FindFirst() then begin
                        Message(StrSubstNo(Text001, PurcHInvHdrGvar."No."));
                    end;
                end;
            end;


        }


    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                rec.TestField("Reason Code");
            end;
        }
    }



    var
        PurcHInvHdrGvar: Record "Purch. Inv. Header";
        Text001: Label 'The External Document No Already Exist For %1 Posted Purhase Invoice';

}