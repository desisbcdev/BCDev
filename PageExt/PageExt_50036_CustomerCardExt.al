pageextension 50036 CustomerCardPageExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = all;
            }
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Service Zone Code")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("Customer Price Group")
        {
            Visible = false;
        }
        modify("Customer Disc. Group")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }
        modify("Tax Area Code")
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
        modify("TDS Customer Allowed Sections")
        {
            Visible = false;
        }
        modify("TDS Customer Concessional Codes")
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
                    IF WorkflowManagement.CanExecuteWorkflow(Rec, ApprovalsCodeunit.RunworkflowOnSendCustomerforApprovalCode()) then
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
                    RecordRest.SetRange(ID, 18);
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
                begin
                    IF ApprovalsCodeunit.CheckCustomerApprovalsWorkflowEnabled(Rec) then
                        ApprovalsCodeunit.OnSendCustomerForApproval(Rec);
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
                    ApprovalsCodeunit.OnCancelCustomerForApproval(rec);
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
                    ApprovalEntry.SetRange("Table ID", DATABASE::Customer);
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
                        IF Confirm('Do you want to block the Customer?', True, False) then BEGIN
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
                        IF Confirm('Do you want to Unblock the Customer?', True, False) then BEGIN
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


    var
        WorkflowManagement: codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        RecordRest: Record "Restricted Record";
        approvalmngmt: Codeunit "Approvals Mgmt.";
        ApprovalsCodeunit: Codeunit ApprovalsCodeunit;
        OpenApprEntrEsists: Boolean;
        CanrequestApprovForFlow: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        OpenAppEntrExistsForCurrUser: Boolean;
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
}