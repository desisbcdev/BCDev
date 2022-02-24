report 50038 "Employee Ledger Entries"
{
    Caption = 'Employee Ledger Entries';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './EmployeeLedgerEntries.rdl';

    dataset
    {


        dataitem("Employee Ledger Entry"; "Employee Ledger Entry")
        {

            RequestFilterFields = "Employee No.", "Posting Date";

            column("Employee_No_"; "Employee No.")
            {
                IncludeCaption = True;
            }
            column(Posting_Date; "Posting Date")
            {
                IncludeCaption = True;
            }
            column(Debit_Amount; "Debit Amount")
            {
                IncludeCaption = True;
            }
            column(Credit_Amount; "Credit Amount")
            {
                IncludeCaption = True;
            }
            column(Employee_Name; EmployeeName)
            {


            }
            column(GL_Account; GLAcctNum)
            {

            }
            column(Reason_Code; "Reason Code")
            {
                IncludeCaption = True;

            }
            column(EMPNameCap; EMPNameCap)
            {

            }
            column(GLAccCap; GLAccCap)
            {

            }
            column(Document_Type; "Document Type")
            {
                IncludeCaption = True;

            }
            column(G_L_Name; GLName)
            {

            }
            column(Remaining_Amount; "Remaining Amount")
            {

            }
            column(Narration; NarrationVar)
            {



            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
                IncludeCaption = True;

            }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
                IncludeCaption = True;

            }
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code")
            {
                IncludeCaption = True;

            }
            column(Shortcut_Dimension_4_Code; "Shortcut Dimension 4 Code")
            {
                IncludeCaption = True;

            }
            column(BalCap; BalCap)
            {

            }
            column(NarrCap; NarrCap)
            {

            }
            column(GLAccNameCap; GLAccNameCap)
            {

            }
            column(ReqFilters; ReqFilters)
            {

            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

                ReqFilters := "Employee Ledger Entry".GetFilters;

            end;

            trigger OnAfterGetRecord()
            var
                EmployeeRec: Record Employee;
                GLEntryRec: record "G/L Entry";
                PostedNarration: Record "Posted Narration";
            begin

                clear(EmployeeName);
                clear(GLAcctNum);
                CalcFields(Amount, "Remaining Amount", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code");
                Clear(GLName);
                clear(NarrationVar);
                if EmployeeRec.get("Employee No.") then
                    EmployeeName := EmployeeRec.FullName();

                GLEntryRec.Reset;
                GLEntryRec.Setrange("Document No.", "Document No.");
                GLEntryRec.Setfilter(Amount, '%1', (Amount * -1));
                if GLEntryRec.findfirst then begin
                    GLEntryRec.calcfields("G/L Account Name");
                    GLAcctNum := GLEntryRec."G/L Account No.";
                    GLName := GLEntryRec."G/L Account Name";

                end;
                PostedNarration.reset;
                PostedNarration.SetRange("Document No.", "Document No.");
                if PostedNarration.FindSet() then
                    repeat

                        NarrationVar += PostedNarration.Narration;
                    until PostedNarration.next = 0;


            end;

        }


    }



    var





        EmployeeName: text[250];
        GLAcctNum: Code[20];
        EMPNameCap: Label 'Employee Name';
        GLAccCap: Label 'GL Account';
        BalCap: Label 'Balance';
        NarrCap: Label 'Narration';
        GLAccNameCap: Label 'G/l Name';

        GLName: Text[100];
        ReqFilters: Text[250];



        NarrationVar: Text[250];







}