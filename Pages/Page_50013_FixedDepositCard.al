page 50013 "Fixed Deposit Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Bank; Rec.Bank)
                {
                    ApplicationArea = All;
                }
                field("FD Advice No"; Rec."FD Advice No")
                {
                    ApplicationArea = All;


                }
                field(Principal; Rec.Principal)
                {
                    ApplicationArea = all;
                }
                field("Rate of Interest Kotak"; Rec."Rate of Interest Kotak")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Rate of Interest Axis"; Rec."Rate of Interest Axis")
                {
                    ApplicationArea = all;
                }
                field("Rate of Interest Citi"; Rec."Rate of Interest Citi")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

                field("Rate of Interest HDFC"; Rec."Rate of Interest HDFC")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("FD Made On"; Rec."FD Made On")
                {
                    ApplicationArea = all;
                }
                field("FD Period"; Rec."FD Period")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Days; Rec.Days)
                {
                    ApplicationArea = all;
                }

                field("Fd Maturity Date"; Rec."Fd Maturity Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Intrest Earned"; Rec."Intrest Earned")
                {
                    ApplicationArea = all;
                }

                field(Posted; Rec.Posted)
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }







            }

            group(Posting)
            {
                Caption = 'Posting';

                field("Interest Acc A/C"; Rec."Interest Acc A/C")
                {
                    ApplicationArea = all;
                }

                field("Interest Rev A/C"; Rec."Interest Rev A/C")
                {
                    ApplicationArea = all;
                }
            }

        }
    }

    actions
    {

        area(Processing)
        {

            Group(Line)
            {
                action(CalculateDefferalMonthWise)
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Defferal Monthwise';
                    Image = Calculate;

                    trigger OnAction()
                    begin

                        InsertFDDefferal();

                    end;
                }

                action(ShowDefferalDoc)
                {
                    ApplicationArea = All;
                    Caption = 'Show Defferal Entries';
                    Image = Entries;

                    trigger OnAction()
                    begin

                        ShowDefferal();

                    end;
                }

                action(LedgerEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Ledger Entries';
                    Image = Ledger;

                    trigger OnAction()
                    begin
                        ShowLedgerEntries();


                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        rec.ShowDimensions();
                        CurrPage.SaveRecord;
                    end;
                }
            }

            group(Post)
            {
                Caption = 'Post';
                Image = Post;

                action(PostJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Post Journal';
                    Image = Post;

                    trigger OnAction()
                    begin
                        rec.CheckStatus();
                        Rec.DocumentPost();

                    end;
                }
            }
        }






    }






    local procedure InsertFDDefferal()
    begin

        Rec.TestField(Posted, false);
        Clear(DocInterstAmt);
        Rec.TestField(Rec."FD Made On");
        Rec.TestField(Rec."Fd Maturity Date");
        Rec.TestField(Rec.Principal);
        Rec.TestField(rec."Rate of Interest Axis");


        FDDefferalRec2.REset;
        FDDefferalRec2.setrange("Document No.", Rec."Document No.");
        if FDDefferalRec2.Findset() then
            FDDefferalRec2.DeleteAll();

        StDate := Rec."FD Made On";
        YearInterst := Round((Rec.Principal * rec."Rate of Interest Axis") / 100, 1);

        FirstEntry := true;


        for LoopDate := Rec."FD Made On" to calcdate('CM', rec."Fd Maturity Date") do begin

            FDDefferalRec.init;
            FDDefferalRec."Document No." := Rec."Document No.";
            FDDefferalRec."Line No." := GetLineNum();
            if not FirstEntry then begin



                if calcdate('-CM', rec."Fd Maturity Date") = StDate then begin
                    FDDefferalRec."Posting Date" := rec."Fd Maturity Date";
                    FDDefferalRec.PeriodDays := Rec."Fd Maturity Date" - StDate + 1;
                end else begin
                    FDDefferalRec."Posting Date" := StDate;
                    if calcdate('-CM', StDate) = StDate then
                        FDDefferalRec.PeriodDays := CalcDate('CM', StDate) - StDate + 1
                    else
                        FDDefferalRec.PeriodDays := CalcDate('CM', StDate) - StDate;

                end;
            end else begin
                firstEntry := false;
                if calcdate('-CM', rec."Fd Maturity Date") = StDate then begin
                    FDDefferalRec."Posting Date" := rec."Fd Maturity Date";
                    FDDefferalRec.PeriodDays := Rec."Fd Maturity Date" - StDate;
                end else begin
                    FDDefferalRec."Posting Date" := StDate;
                    FDDefferalRec.PeriodDays := CalcDate('CM', StDate) - StDate;

                end;



            end;
            FDDefferalRec.Amount := Round((YearInterst * FDDefferalRec.PeriodDays) / 365, 0.01);
            DocInterstAmt += FDDefferalRec.Amount;

            FDDefferalRec.Insert;

            LoopDate := calcdate('CM+1D', StDate);


            StDate := LoopDate;

        end;

        Message(DefferalMsg);

        Rec."Intrest Earned" := DocInterstAmt;
        REc.Modify()

    end;

    Local procedure GetLineNum(): Integer
    begin

        FDDefferalRec2.REset;
        FDDefferalRec2.setrange("Document No.", Rec."Document No.");
        if FDDefferalRec2.FindLast() then
            exit(FDDefferalRec2."Line No." + 1000)
        else
            exit(1000)
    end;


    procedure ShowDefferal()
    begin

        clear(FDDefferalEntries);
        FDDefferalRec2.REset;
        FDDefferalRec2.setrange("Document No.", Rec."Document No.");
        FDDefferalEntries.SetTableView(FDDefferalRec2);
        FDDefferalEntries.RunModal();

    end;



    procedure ShowLedgerEntries()
    begin


        Clear(GLEntries);
        GLEntryRec.REset;
        GLEntryRec.setrange("Fixed Deposit No.", Rec."Document No.");
        GLEntries.SetTableView(GLEntryRec);
        GLEntries.RunModal();


    end;


    var

        FDDefferalRec: Record "FD Defferal";
        FDDefferalRec2: Record "FD Defferal";
        FDDefferalEntries: page "FD Defferal";
        GLEntries: Page "General Ledger Entries";
        GLEntryRec: Record "G/L Entry";


        DefferalMsg: Label 'Defferal created successfully.';


        StDate: Date;
        LoopDate: Date;
        YearInterst: Decimal;
        DocInterstAmt: Decimal;
        FirstEntry: Boolean;



}