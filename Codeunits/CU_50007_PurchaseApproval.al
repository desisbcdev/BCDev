codeunit 50007 PurchaseApproval
{
    trigger OnRun()
    begin

    end;


    //Purchase Cancel/Shortclosed Approval Start >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnBeforeReleaseDocument', '', true, true)]
    local procedure OnReleasedocumentPurchaseCust(var Variant: Variant)
    var
        PurchaseHeader: Record "Purchase Header";

        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    if (PurchaseHeader.Status = PurchaseHeader.Status::Released) and (purchaseheader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
                        if PurchaseHeader."Cancel ShortClose Type" = PurchaseHeader."Cancel ShortClose Type"::Cancel then begin
                            PurchaseHeader."Cancel Shortclose Appr. Status" := PurchaseHeader."Cancel Shortclose Appr. Status"::Cancelled;
                            PurchaseHeader."Status Type" := Purchaseheader."Status Type"::Cancelled;
                        end else
                            if PurchaseHeader."Cancel ShortClose Type" = PurchaseHeader."Cancel ShortClose Type"::"Short Close" then begin
                                PurchaseHeader."Cancel Shortclose Appr. Status" := PurchaseHeader."Cancel Shortclose Appr. Status"::"Short Closed";
                                PurchaseHeader."Status Type" := Purchaseheader."Status Type"::"Short Closed";
                            end;
                        PurchaseHeader.Modify();




                    end;
                end;
        end;

    end;



    procedure OnSetstatusToPendingApprovalPurchaseCust(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseHeaderRec2: record "Purchase Header";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

    begin

        if (PurchaseHeader.Status = PurchaseHeader.Status::Released) and
           (PurchaseHeader."Cancel Shortclose Appr. Status" = PurchaseHeader."Cancel Shortclose Appr. Status"::Open) then begin
            PurchaseHeaderRec2.Reset;
            PurchaseHeaderRec2.Setrange("Document Type", PurchaseHeader."Document Type");
            PurchaseHeaderRec2.Setrange("No.", PurchaseHeader."No.");
            if PurchaseHeaderRec2.Findfirst then begin

                if ApprovalsMgmt.HasOpenOrPendingApprovalEntries(PurchaseHeaderRec2.RecordId) then
                    PurchaseHeaderRec2."Cancel Shortclose Appr. Status" := PurchaseHeaderRec2."Cancel Shortclose Appr. Status"::"Pending Approval"
                else begin
                    if PurchaseHeaderRec2."Cancel ShortClose Type" = PurchaseHeaderRec2."Cancel ShortClose Type"::Cancel then begin
                        PurchaseHeaderRec2."Cancel Shortclose Appr. Status" := PurchaseHeaderRec2."Cancel Shortclose Appr. Status"::Cancelled;
                        PurchaseHeaderREc2."Status Type" := PurchaseheaderRec2."Status Type"::Cancelled;
                    end else
                        if PurchaseHeaderRec2."Cancel ShortClose Type" = PurchaseHeaderRec2."Cancel ShortClose Type"::"Short Close" then begin
                            PurchaseHeaderRec2."Cancel Shortclose Appr. Status" := PurchaseHeaderRec2."Cancel Shortclose Appr. Status"::"Short Closed";
                            PurchaseHeaderREc2."Status Type" := PurchaseheaderRec2."Status Type"::"Short Closed";
                        end;

                end;
                PurchaseHeaderRec2.Modify();
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
    local procedure OnopendocumentPurchCust(var Rec: Record "Purchase Header")
    var
        PurchaseHeader: Record "Purchase Header";
    begin

        PurchaseHeader.Reset;
        PurchaseHeader.Setrange("Document Type", Rec."Document Type");
        PurchaseHeader.setrange("No.", Rec."No.");
        if PurchaseHeader.findfirst then begin
            if (PurchaseHeader.Status = PurchaseHeader.Status::Released) then begin
                PurchaseHeader."Cancel Shortclose Appr. Status" := PurchaseHeader."Cancel Shortclose Appr. Status"::Open;
                PurchaseHeader.Modify();
            end;


        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', 'Reject', false, false)]
    procedure RejectCancelApprovalPurchase(var Rec: Record "Purchase Header")
    Var
        PurchaseHeader: Record "Purchase Header";
    begin

        PurchaseHeader.Reset;
        PurchaseHeader.Setrange("Document Type", Rec."Document Type");
        PurchaseHeader.setrange("No.", Rec."No.");
        if PurchaseHeader.findfirst then begin
            if PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
                PurchaseHeader."Cancel Shortclose Appr. Status" := PurchaseHeader."Cancel Shortclose Appr. Status"::Open;
                PurchaseHeader.Modify();
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeShowPurchApprovalStatus', '', false, false)]
    local procedure CancelSendforApprovalMsg(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        PendingApprovalMsg: Label 'An approval request has been sent.';

    begin

        if (PurchaseHeader.Status = PurchaseHeader.Status::released) and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
            if ApprovalsMgmt.HasOpenOrPendingApprovalEntries(PurchaseHeader.RecordId) then
                Message(PendingApprovalMsg);
            IsHandled := true;
        end;
    end;
    //Purchase Cust Cancel Shortclosed Approvals End  <<




    var












}