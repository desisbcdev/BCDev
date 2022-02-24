page 50012 "Fixed Deposit List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Fixed Deposit";
    Editable = false;
    CardPageId = 50013;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
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

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Fixed Deposit Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fixed Deposit Report';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    FixedDeposit: Record "Fixed Deposit";
                begin
                    FixedDeposit.RESET;

                    REPORT.RUNMODAL(50027, TRUE, FALSE, FixedDeposit);
                end;
            }

        }
    }
}