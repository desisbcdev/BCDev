pageextension 50014 VendorCardPageExt extends "Vendor Card"
{
    layout
    {
        addlast("Tax Information")
        {
            group("MSME")
            {
                field("MSME Applicable"; rec."MSME Applicable")
                {
                    ApplicationArea = all;
                }
                field("MSME Certificate No."; rec."MSME Certificate No.")
                {
                    ApplicationArea = all;

                }
                field("MSME Validity Date"; rec."MSME Validity Date")
                {
                    ApplicationArea = all;

                }
                field("MSMEownedbySC/STEnterpreneur"; rec."MSMEownedbySC/STEnterpreneur")
                {
                    ApplicationArea = all;
                    Visible = false;

                }
                field(MSMEownedbyWomenEnterpreneur; rec.MSMEownedbyWomenEnterpreneur)
                {
                    ApplicationArea = all;
                    Visible = false;


                }
                field("Specified Vendor"; Rec."Specified Vendor")
                {
                    ApplicationArea = all;
                }

            }
        }
        addlast("PAN Details")
        {
            field("PAN Linked with Aadhar"; rec."PAN Linked with Aadhar")
            {
                ApplicationArea = all;
            }

        }
        addlast(General)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("VAT Registration No.")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }
        modify(Subcontractor)
        {
            Visible = false;
        }

    }

    actions
    {
        modify(SendApprovalRequest)
        {
            Visible = false;
            // trigger OnBeforeAction()
            // BEGIN
            //     TestField("Approval Status", "Approval Status"::Open);
            // END;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
            // trigger OnBeforeAction()
            // begin
            //     TestField("Approval Status", "Approval Status"::"Pending for Approval");
            // end;
        }
        modify(Approve)
        {
            Visible = false;
        }

        addlast("Request Approval")
        {

            // +B2Bjk
            action(ApproveNew)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Action;
                //Visible = openapp;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    approvalmngmt.ApproveRecordApprovalRequest(Rec.RecordId());
                end;
            }
            action("Re&lease")
            {
                ApplicationArea = all;
                Caption = 'Re&lease';
                ShortCutKey = 'Ctrl+F11';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    WorkflowManagement: Codeunit "Workflow Management";
                begin
                    IF WorkflowManagement.CanExecuteWorkflow(Rec, ApprovalsCodeunit.RunworkflowOnSendVendorforApprovalCode()) then
                        error('Workflow is enabled. You can not release manually.');

                    IF Rec."Approval Status" <> Rec."Approval Status"::Released then BEGIN
                        Rec."Approval Status" := Rec."Approval Status"::Released;

                        Rec.Modify();
                        Message('Document has been Released.');
                    end;
                end;
            }
            action("Re&open")
            {
                ApplicationArea = all;
                Caption = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction();
                var
                    RecordRest: Record "Restricted Record";
                begin
                    RecordRest.Reset();
                    RecordRest.SetRange(ID, 23);
                    RecordRest.SetRange("Record ID", Rec.RecordId());
                    IF RecordRest.FindFirst() THEN
                        error('This record is under in workflow process. Please cancel approval request if not required.');
                    IF Rec."Approval Status" <> Rec."Approval Status"::Open then BEGIN
                        Rec."Approval Status" := Rec."Approval Status"::Open;

                        Rec.Modify();
                        Message('Document has been Reopened.');
                    end;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                Var
                    PreferredBankConfirm: Label 'Do you want send for approval preferred bank account code empty?';
                begin
                    IF ApprovalsCodeunit.CheckVendorApprovalsWorkflowEnabled(Rec) then begin
                        if Rec."Preferred Bank Account Code" = '' then
                            if not confirm(PreferredBankConfirm, false) then
                                exit;
                        ApprovalsCodeunit.OnSendVendorForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    ApprovalsCodeunit.OnCancelVendorForApproval(rec);
                end;
            }
            action("Approval Entries")
            {
                ApplicationArea = All;
                Image = Entries;
                //Visible = openapp;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", DATABASE::Vendor);
                    ApprovalEntry.SetRange("Document No.", Rec."No.");
                    ApprovalEntries.SetTableView(ApprovalEntry);
                    ApprovalEntries.RUN;
                end;

            }
            action("Block")
            {
                Image = Close;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    IF Rec.Blocked = Rec.Blocked::" " then BEGIN
                        IF Confirm('Do you want to block the Vendor?', True, False) then BEGIN
                            Rec.Blocked := Rec.blocked::All;
                            Rec.Modify();
                        end;
                    end;
                end;
            }
            action("UnBlock")
            {
                Image = Open;
                ApplicationArea = all;
                trigger OnAction()

                begin
                    IF Rec.Blocked <> Rec.Blocked::" " then BEGIN
                        IF Confirm('Do you want to Unblock the Vendor?', True, False) then BEGIN
                            Rec.Blocked := Rec.blocked::" ";
                            Rec.Modify();
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if rec."MSME Applicable" then begin
            rec.TestField("MSME Certificate No.");
            rec.TestField("MSME Validity Date");
        end;
        rec.TestField("Partner Type");
    end;

    var
        WorkflowManagement: codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        RecordRest: Record "Restricted Record";
        Approvalmngmt: Codeunit "Approvals Mgmt.";
        ApprovalsCodeunit: Codeunit ApprovalsCodeunit;
        OpenApprEntrEsists: Boolean;
        CanrequestApprovForFlow: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        OpenAppEntrExistsForCurrUser: Boolean;
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";

}