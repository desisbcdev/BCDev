page 50002 "Cost Allocation Rule"
{
    PageType = Document;
    SourceTable = "Cost Allocation Header";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Cost Allocation No."; Rec."Cost Allocation No.")
                {
                    ApplicationArea = All;
                }
                field(Locked; Rec.Locked)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(page; "Cost Allocation Subform")
            {
                Caption = 'Allocation Lines';
                SubPageLink = "Cost Allocation No." = field("Cost Allocation No.");
                ApplicationArea = All;
            }


        }
    }

    actions
    {
        area(Processing)
        {
            action("Lock")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CostAllocLine: Record "Cost Allocation Line";
                    AllocationPerErr: Label 'Cost Allocation sum % should be equal to 100%';
                begin
                    Rec.TestField(Locked, false);
                    CostAllocLine.Reset();
                    CostAllocLine.SetRange("Cost Allocation No.", Rec."Cost Allocation No.");
                    if CostAllocLine.FindSet() then begin
                        CostAllocLine.CalcSums("Allocation %");
                        if CostAllocLine."Allocation %" <> 100 then
                            Error(AllocationPerErr);
                    end;
                    Rec.Locked := true;
                    Rec.Modify();
                end;
            }
            action("Un-Lock")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Rec.TestField(Locked, true);
                    Rec.Locked := false;
                    Rec.Modify();
                end;
            }
        }
    }

    var


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ConfirmLbl: Label 'Do you want to close the Rule without locking ?';
    begin
        if not Rec.Locked then
            if not Confirm(ConfirmLbl, true) then
                Error('');
    end;
}