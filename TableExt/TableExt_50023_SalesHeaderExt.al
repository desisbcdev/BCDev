tableextension 50023 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50000; "Sales Invoice No."; COde[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Invoice No.';
        }
    }

    trigger OnInsert()
    begin
        if Rec."Document Type" = Rec."Document Type"::Invoice then begin
            IF "Sales Invoice No." = '' THEN BEGIN
                SalesReceivableSetup.GET();
                SalesReceivableSetup.TESTFIELD("Sales Invoice No. Series");
                "Sales Invoice No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."Sales Invoice No. Series", WorkDate(), true)
            END;
        end;
    end;

    Var
        SalesReceivableSetup: record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;



}

