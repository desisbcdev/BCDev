codeunit 50005 ApprovalsCodeunit
{
    trigger OnRun()
    begin

    end;

    //B2BJK Start
    //Vendor Approval Start >>

    [IntegrationEvent(false, false)]
    Procedure OnSendVendorForApproval(var Vendor: Record Vendor)
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelVendorForApproval(var Vendor: Record Vendor)
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendVendorforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendVendorforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::ApprovalsCodeunit, 'OnSendVendorForApproval', '', true, true)]
    local procedure RunworkflowonsendVendorForApproval(var Vendor: Record Vendor)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendVendorforApprovalCode(), Vendor);
    end;

    procedure RunworkflowOnCancelVendorforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelVendorForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::ApprovalsCodeunit, 'OncancelVendorForApproval', '', true, true)]

    local procedure RunworkflowonCancelVendorForApproval(var Vendor: Record Vendor)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelVendorforApprovalCode(), Vendor);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryVendor();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendVendorforApprovalCode(), DATABASE::Vendor,
          CopyStr(Vendorsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelVendorforApprovalCode(), DATABASE::Vendor,
          CopyStr(Vendorrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryVendor(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelVendorforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelVendorforApprovalCode(), RunworkflowOnSendVendorforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendVendorforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendVendorforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendVendorforApprovalCode());
        end;
    end;

    procedure ISVendorworkflowenabled(var Vendor: Record Vendor): Boolean
    begin
        if Vendor."Approval Status" <> Vendor."Approval Status"::Open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(Vendor, RunworkflowOnSendVendorforApprovalCode()));
    end;

    Procedure CheckVendorApprovalsWorkflowEnabled(var Vendor: Record Vendor): Boolean
    begin
        IF not ISVendorworkflowenabled(Vendor) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentVendor(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Vendor: Record Vendor;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    ApprovalEntryArgument."Document No." := FORMAT(Vendor."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentVendor(RecRef: RecordRef; var Handled: boolean)
    var
        Vendor: Record Vendor;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Vendor."Approval Status" := Vendor."Approval Status"::Open;
                    Vendor.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentVendor(RecRef: RecordRef; var Handled: boolean)
    var
        Vendor: Record Vendor;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Vendor."Approval Status" := Vendor."Approval Status"::Released;
                    Vendor.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalVendor(RecRef: RecordRef; var IsHandled: boolean)
    var
        Vendor: Record Vendor;
        LPage: Page 26;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Vendor."Approval Status" := Vendor."Approval Status"::"Pending for Approval";
                    Vendor.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelVendorApprovalRequest', '', true, true)]
    local procedure OnSetstatusOpen(var Vendor: Record Vendor)


    begin

        Vendor."Approval Status" := Vendor."Approval Status"::Open;
        vendor.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryVendor(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendVendorforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendVendorforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelVendorforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelVendorforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryVendor()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(VendorCategoryTxt, 1, 20), CopyStr(VendorCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsVendor()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::Vendor, 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateVendor()
    begin
        InsertVendorApprovalworkflowtemplate();
    end;



    local procedure InsertVendorApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(VendorDocOCRWorkflowCodeTxt, 1, 17), CopyStr(VendorApprWorkflowDescTxt, 1, 100), CopyStr(VendorCategoryTxt, 1, 20));
        InsertVendorApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertVendorApprovalworkflowDetails(var workflow: record Workflow);
    var
        Vendor: Record Vendor;
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildVendortypecondition(Vendor."Approval Status"::Open), RunworkflowOnSendVendorforApprovalCode(), BuildVendortypecondition(Vendor."Approval Status"::"Pending for Approval"), RunworkflowOnCancelVendorforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildVendortypecondition(status: integer): Text
    var
        Vendor: Record Vendor;
    Begin
        Vendor.SetRange("Approval Status", status);
        exit(StrSubstNo(VendorTypeCondnTxt, workflowsetup.Encode(Vendor.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidVendor(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidVendor(RecordRef)
    end;

    local procedure GetConditionalcardPageidVendor(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::Vendor:
                exit(page::"Vendor Card");
        end;
    end;

    //Vendor Approvals End  <<


    // Customer Approval start >>


    [IntegrationEvent(false, false)]
    Procedure OnSendCustomerForApproval(var Customer: Record Customer)
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelCustomerForApproval(var Customer: Record Customer)
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendCustomerforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendCustomerforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::ApprovalsCodeunit, 'OnSendCustomerForApproval', '', true, true)]
    local procedure RunworkflowonsendCustomerForApproval(var Customer: Record Customer)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendCustomerforApprovalCode(), Customer);
    end;

    procedure RunworkflowOnCancelCustomerforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelCustomerForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::ApprovalsCodeunit, 'OncancelCustomerForApproval', '', true, true)]

    local procedure RunworkflowonCancelCustomerForApproval(var Customer: Record Customer)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelCustomerForApprovalCode(), Customer);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsTolibraryCustomer();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendCustomerForApprovalCode(), DATABASE::Customer,
          CopyStr(Customersendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelCustomerForApprovalCode(), DATABASE::Customer,
          CopyStr(Customerrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryCustomer(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelCustomerForApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelCustomerForApprovalCode(), RunworkflowOnSendCustomerForApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendCustomerForApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendCustomerForApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendCustomerForApprovalCode());
        end;
    end;

    procedure ISCustomerworkflowenabled(var Customer: Record Customer): Boolean
    begin
        if Customer."Approval Status" <> Customer."Approval Status"::Open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(Customer, RunworkflowOnSendCustomerForApprovalCode()));
    end;

    Procedure CheckCustomerApprovalsWorkflowEnabled(var Customer: Record Customer): Boolean
    begin
        IF not ISCustomerworkflowenabled(Customer) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentCustomer(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Customer: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(Customer);
                    ApprovalEntryArgument."Document No." := FORMAT(Customer."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentCustomer(RecRef: RecordRef; var Handled: boolean)
    var
        Customer: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(Customer);
                    Customer."Approval Status" := Customer."Approval Status"::Open;
                    Customer.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentCustomer(RecRef: RecordRef; var Handled: boolean)
    var
        Customer: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(Customer);
                    Customer."Approval Status" := Customer."Approval Status"::Released;
                    Customer.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalCustomer(RecRef: RecordRef; var IsHandled: boolean)
    var
        Customer: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(Customer);
                    Customer."Approval Status" := Customer."Approval Status"::"Pending for Approval";
                    Customer.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryCustomer(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendCustomerForApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendCustomerForApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelCustomerForApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelCustomerForApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryCustomer()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(CustomerCategoryTxt, 1, 20), CopyStr(CustomerCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsCustomer()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::Customer, 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateCustomer()
    begin
        InsertCustomApprovalworkflowtemplate();
    end;



    local procedure InsertCustomApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(CustomerDocOCRWorkflowCodeTxt, 1, 17), CopyStr(CustomerApprWorkflowDescTxt, 1, 100), CopyStr(CustomerCategoryTxt, 1, 20));
        InsertCustomerApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertCustomerApprovalworkflowDetails(var workflow: record Workflow);
    var
        Customer: Record Customer;
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildCustomertypecondition(Customer."Approval Status"::Open), RunworkflowOnSendCustomerForApprovalCode(), BuildCustomertypecondition(Customer."Approval Status"::"Pending for Approval"), RunworkflowOnCancelCustomerForApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildCustomertypecondition(status: integer): Text
    var
        Customer: Record Customer;
    Begin
        Customer.SetRange("Approval Status", status);
        exit(StrSubstNo(CustomerTypeCondnTxt, workflowsetup.Encode(Customer.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidCustomer(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidCustomer(RecordRef)
    end;

    local procedure GetConditionalcardPageidCustomer(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::Customer:
                exit(page::"Customer Card");
        end;
    end;






    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";


        //B2BJK  Start Variables for Vendor Approvals
        VendorsendforapprovaleventdescTxt: Label 'Approval of a  Vendor Document is requested';
        VendorCategoryDescTxt: Label 'VendorDocuments';
        VendorTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=Vendor>%1</DataItem></DataItems></ReportParameters>';
        VendorrequestcanceleventdescTxt: Label 'Approval of a  Vendor Document is Cancelled';
        VendorCategoryTxt: Label 'VendorCustomer';
        VendorDocOCRWorkflowCodeTxt: Label ' Vendor';
        VendorApprWorkflowDescTxt: Label 'Vendor Approval Workflow';
        NoworkfloweableErr: Label 'No Approval workflow for this record type is enabled.';

        //B2BJK  End Variables for Vendor Approvals

        //B2BJK  Start Variables for Customer Approvals
        CustomersendforapprovaleventdescTxt: Label 'Approval of a Customer Document is requested';
        CustomerCategoryDescTxt: Label 'CustomerDocuments';
        CustomerTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=Customer>%1</DataItem></DataItems></ReportParameters>';
        CustomerrequestcanceleventdescTxt: Label 'Approval of a Customer Document is Cancelled';
        CustomerCategoryTxt: Label 'Customer';
        CustomerDocOCRWorkflowCodeTxt: Label 'Customer';
        CustomerApprWorkflowDescTxt: Label 'Customer Approval Workflow';

    //B2BJK  End Variables for Customer Approvals
}