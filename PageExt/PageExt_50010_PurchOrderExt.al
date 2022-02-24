pageextension 50010 PurchOrderExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("Vendor Quote No"; Rec."Vendor Quote No")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Vendor Quote Date"; Rec."Vendor Quote Date")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }

            field("Status Type"; Rec."Status Type")
            {
                ApplicationArea = all;
            }
            field(Subject; rec.Subject)
            {
                ApplicationArea = ALL;
                ShowMandatory = true;
            }
            field("Report View"; rec."Report View")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Cancel ShortClose Type"; Rec."Cancel ShortClose Type")
            {
                ApplicationArea = all;
            }

            field("Cancel Shortclose Appr. Status"; Rec."Cancel Shortclose Appr. Status")
            {
                ApplicationArea = All;
            }

            field("PI Date"; Rec."PI Date")
            {
                ApplicationArea = All;

            }





        }
        modify("Buy-from Vendor No.")
        {
            ShowMandatory = true;
            trigger OnLookup(var Text: Text): Boolean
            var

            begin
                Rec.VendorLookup()
            end;
        }
        modify("Buy-from Vendor Name")
        {

            trigger OnLookup(var Text: Text): Boolean
            var
            begin

                Rec.VendorLookup();

            end;
        }

        modify("Buy-from Contact No.")
        {
            Visible = false;
        }

        modify("Document Date")
        {
            Visible = false;

        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        /*
        modify("Vendor Invoice No.")
        {
            Visible = false;
        }
          modify(Rec."Reason Code")
         {
             visible = false;
         } */
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Editable = false;
        }
        modify("Buy-from Address")
        {
            Editable = false;
        }
        modify("Buy-from Address 2")
        {
            Editable = false;
        }
        modify("Buy-from City")
        {
            Editable = false;
        }
        modify("Buy-from Post Code")
        {
            Editable = false;
        }
        modify("Buy-from Country/Region Code")
        {
            Editable = false;
        }

        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("On Hold")
        {
            Visible = false;
        }
        modify("Inbound Whse. Handling Time")
        {
            Visible = false;

        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Editable = false;
        }






        addbefore("No.")
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
                ShowMandatory = true;
                trigger OnValidate()
                var
                    OrderTypeErr: Label 'You donot change Order Type Value in Document No. %1';

                begin

                    if Rec."No." <> '' then
                        Error(OrderTypeErr, Rec."No.");

                end;
            }
        }
        addafter("Payment Date")
        {
            field("Specified Vendor"; Rec."Specified Vendor")
            {
                ApplicationArea = all;
            }
        }
        addafter(PurchLines)
        {
            part(PaymentConditions; "Payment Terms and Condition")
            {
                ApplicationArea = all;
                SubPageLink = DocumentNo = field("No.");
                UpdatePropagation = Both;
            }

            part(Specifications; Specifications)
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No."), DocumentType = const(Order);
                UpdatePropagation = Both;
            }




        }
        addlast(factboxes)
        {
            part(Transcationcount; TransactionCount)
            {
                ApplicationArea = all;
                SubPageView = WHERE("Document Type" = CONST(Invoice));
                SubPageLink = "Vendor No." = field("Buy-from Vendor No.");
                Visible = true;
            }


        }
        modify(Subcontracting)
        {
            Visible = false;
        }


    }

    actions
    {
        /* modify(Preview)
        {
            Visible = false;
        } */
        /*  modify(post)
         {
             Visible = false;
         } */
        modify("Post and &Print")
        {
            Visible = false;
        }
        modify(PostAndNew)
        {
            Visible = false;
        }
        modify("Post &Batch")
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }
        addafter("Post and &Print")
        {
            action("Preview Cost Allocation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                Promoted = true;
                Visible = false; //b2bjk
                PromotedCategory = Category6;
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                var
                    PurchPostYesNo: Codeunit "Purch.-Post Cost AllocationNew";
                begin
                    PurchPostYesNo.PurchasePostPreview(PurchPostYesNo, Rec);
                end;
            }
            /*  action("Print Purchase Order")
             {
                 ApplicationArea = Basic, Suite;
                 Caption = 'Print Purchase Order';
                 Image = Print;
                 Promoted = true;
                 PromotedCategory = Category6;
                 trigger OnAction()
                 var
                     PurchaseHeader: Record "Purchase Header";
                 begin
                     rec.TestField("Order Type", rec."Order Type"::"Purchase Order");
                     PurchaseHeader.RESET;
                     PurchaseHeader.SETRANGE("No.", "No.");
                     REPORT.RUNMODAL(50013, TRUE, FALSE, PurchaseHeader);
                 end;
             }
             action("Print Work Order")
             {
                 ApplicationArea = Basic, Suite;
                 Caption = 'Print Work Order';
                 Image = Print;
                 Promoted = true;
                 PromotedCategory = Category6;
                 trigger OnAction()
                 var
                     PurchaseHeader: Record "Purchase Header";
                 begin
                     rec.TestField("Order Type", rec."Order Type"::"Work Order");
                     PurchaseHeader.RESET;
                     PurchaseHeader.SETRANGE("No.", "No.");
                     REPORT.RUNMODAL(50015, TRUE, FALSE, PurchaseHeader);
                 end;
             } */
            action("Print&")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    ReportNovar: Integer;
                begin
                    case rec."Report View" of
                        rec."Report View"::"Work Order":
                            ReportNovar := 50015;
                        rec."Report View"::"Work Order1":
                            ReportNovar := 50021;
                        rec."Report View"::"Work Order2":
                            ReportNovar := 50022;
                        rec."Report View"::"Work Order3":
                            ReportNovar := 50023;
                        rec."Report View"::"Work Order4":
                            ReportNovar := 50024;
                        rec."Report View"::"Work Order5":
                            ReportNovar := 50025;
                        rec."Report View"::"Work Order6":
                            ReportNovar := 50026;
                        rec."Report View"::"AMC Order1":
                            ReportNovar := 50001;
                        rec."Report View"::"AMC Order2":
                            ReportNovar := 50002;
                        rec."Report View"::"AMC Order3":
                            ReportNovar := 50003;
                        rec."Report View"::"AMC Order4":
                            ReportNovar := 50004;
                        rec."Report View"::"AMC Order5":
                            ReportNovar := 50005;
                        rec."Report View"::"AMC Order6":
                            ReportNovar := 50006;

                    end;
                    if rec."Order Type" = rec."Order Type"::"Purchase Order" then begin
                        if rec."Report View" = rec."Report View"::"Po Service" then begin
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(50020, TRUE, FALSE, PurchaseHeader);
                        end else begin
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(50013, TRUE, FALSE, PurchaseHeader);
                        end;
                    end;
                    if rec."Order Type" = Rec."Order Type"::"Work Order" then begin

                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("No.", rec."No.");
                        REPORT.RUNMODAL(ReportNovar, TRUE, FALSE, PurchaseHeader);

                    end;
                    if rec."Order Type" = Rec."Order Type"::"AMC Order" then begin

                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("No.", rec."No.");
                        REPORT.RUNMODAL(ReportNovar, TRUE, FALSE, PurchaseHeader);
                    end;
                end;
            }
            action("Print Payment Terms")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Payment Terms';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    if rec."Order Type" = rec."Order Type"::"Purchase Order" then begin
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("No.", rec."No.");
                        REPORT.RUNMODAL(50019, TRUE, FALSE, PurchaseHeader);
                    end;
                    if rec."Order Type" = Rec."Order Type"::"Work Order" then begin
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("No.", rec."No.");
                        REPORT.RUNMODAL(50018, TRUE, FALSE, PurchaseHeader);

                    end;
                end;

            }
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Report View" = Rec."Report View"::" " then
                    Error(ReportViewError);
                Rec.TestField(Status, Rec.Status::Open);
                Rec.Testfield("Shortcut Dimension 1 Code");
                Rec.Testfield("Shortcut Dimension 2 Code");
                rec.Testfield("Vendor Posting Group");
            end;
        }

        addafter(CalculateInvoiceDiscount)
        {
            action("Cancel")
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Image = Cancel;
                Visible = false;// Approval process developed for cancel

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    if not confirm(Strsubstno(CancelConfirm, Rec."No.")) then
                        exit;
                    if (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::Cancelled) or
                         (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::"Short Closed") then
                        Error(DocCancelledErr);
                    PurchaseHeader.Reset;
                    PurchaseHeader.setrange("Document Type", Rec."Document Type");
                    PurchaseHeader.setrange("No.", Rec."No.");
                    if PurchaseHeader.FindFirst() then begin
                        PurchaseHeader."Cancel Shortclose Appr. Status" := PurchaseHeader."Cancel Shortclose Appr. Status"::Cancelled;
                        PurchaseHeader.modify;
                    end;

                end;
            }


            action("Short Close")
            {
                ApplicationArea = All;
                Caption = 'Short Close';
                Image = CloseDocument;
                Visible = false;// Approval process developed for Shortclose

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    if not confirm(Strsubstno(ShortCloseConfirm, Rec."No.")) then
                        exit;
                    if (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::Cancelled) or
                         (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::"Short Closed") then
                        Error(DocCancelledErr);
                    PurchaseHeader.Reset;
                    PurchaseHeader.setrange("Document Type", Rec."Document Type");
                    PurchaseHeader.setrange("No.", Rec."No.");
                    if PurchaseHeader.FindFirst() then begin
                        PurchaseHeader."Cancel Shortclose Appr. Status" := PurchaseHeader."Cancel Shortclose Appr. Status"::"Short Closed";
                        PurchaseHeader.modify;
                    end;

                end;
            }

            action(CancelApproval)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel ShortClose Document';
                Enabled = (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::Open) and (Rec.Status = Rec.Status::Released);
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ToolTip = 'Cancel ShortClose Document';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    PurchaseApproval: Codeunit PurchaseApproval;
                begin

                    Rec.TestField("Cancel ShortClose Type");


                    if Rec."Cancel ShortClose Type" = Rec."Cancel ShortClose Type"::Cancel then begin

                        if Not Confirm(Strsubstno(CancelConfirm, Rec."No.")) then
                            exit;
                        Rec.CheckDocQtyReceiveLineExist();
                    end else
                        if Rec."Cancel ShortClose Type" = Rec."Cancel ShortClose Type"::"Short Close" then begin
                            if Not confirm(Strsubstno(ShortCloseConfirm, Rec."No.")) then
                                exit;
                            Rec.CheckDocLineReceivedInvoicedEqual();
                        end;

                    if (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::Cancelled) or
                         (Rec."Cancel Shortclose Appr. Status" = Rec."Cancel Shortclose Appr. Status"::"Short Closed") then
                        Error(DocCancelledErr);

                    if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then begin
                        ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                        PurchaseApproval.OnSetstatusToPendingApprovalPurchaseCust(rec);
                    end;

                end;
            }





        }

        addafter("Update Reference Invoice No.")
        {
            action(ImportSpecification)
            {
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                begin
                    ImportSpecificationLines

                end;
            }
        }

    }

    var

        CancelConfirm: Label 'Do you want cancel the Purchase Document %1';
        DocCancelledErr: Label 'Document already Either Cancelled or ShortClosed';
        ShortCloseConfirm: Label 'Do you want ShortClose the Purchase Document %1';
        ReportViewError: Label 'The Field Report View Is Empty Please Select An Option In The ReportView';

}