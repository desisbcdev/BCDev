report 50027 FixedDeposit
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './FixedDeposit.rdl';
    Caption = 'Fixed Deposit';

    dataset
    {
        dataitem("Fixed Deposit"; "Fixed Deposit")
        {
            RequestFilterFields = Bank;
            column(Bank; Bank)
            { }
            column(FD_Advice_No; "FD Advice No")
            { }
            column(Principal; Principal)
            { }
            column(Rate_of_Interest_Kotak; "Rate of Interest Kotak")
            { }
            column(Rate_of_Interest_Axis; "Rate of Interest Axis")
            { }
            column(Rate_of_Interest_Citi; "Rate of Interest Citi")
            { }
            column(FD_Made_On; "FD Made On")
            { }
            column(Days; Days)
            { }
            column(Fd_Maturity_Date; "Fd Maturity Date")
            { }
            column(Status; Status)
            { }
            column(Intrest_Earned; "Intrest Earned")
            { }
            column(BankCap; BankCap)
            { }
            column(FDAdviceNoCap; FDAdviceNoCap)
            { }
            column(PrinCipalCap; PrinCipalCap)
            { }
            column(RoiKotakCap; RoiKotakCap)
            { }
            column(RoiAxisCap; RoiAxisCap)
            { }
            column(RoiCitiCap; RoiCitiCap)
            { }
            column(FdMadeOnCap; FdMadeOnCap)
            { }
            column(DaysCap; DaysCap)
            { }
            column(FdMaturityDateCap; FdMaturityDateCap)
            { }
            column(StatusCap; StatusCap)
            { }
            column(IntrestearnedCap; IntrestearnedCap)
            { }
            column(companyInfo_Picture; companyInfo.Picture)
            { }
            column(FixedDepositCap; FixedDepositCap)
            { }
            trigger OnPreDataItem()
            begin
                companyInfo.CalcFields(Picture);
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /* field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        BankCap: Label 'Bank';
        FDAdviceNoCap: Label 'FD Advice  No';
        PrinCipalCap: Label 'Principal';
        RoiKotakCap: Label 'Rate of Interest Kotak';
        RoiAxisCap: Label 'Rate of Interest';
        RoiCitiCap: Label 'Rate of Interest Citi';
        FdMadeOnCap: Label 'FD Made On"';
        DaysCap: Label 'Days';
        FdMaturityDateCap: Label 'FD Maturity Date';
        StatusCap: Label 'Status';
        IntrestearnedCap: Label 'Intrest Earned';
        FixedDepositCap: Label 'Fixed Deposit';
        CompanyInfo: Record "Company Information";


}