tableextension 50006 VendorExtTable extends Vendor
{
    fields
    {
        field(50000; "MSME Applicable"; Boolean)
        {
            Caption = 'MSME Applicable';
            DataClassification = CustomerContent;
        }
        field(50001; "MSME Certificate No."; Code[20])
        {
            Caption = 'MSME Certificate No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("MSME Applicable", true);
                if "MSME Applicable" then
                    TestField("MSME Certificate No.");
            end;
        }
        field(50002; "MSME Validity Date"; Date)
        {
            Caption = 'MSME Validity Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("MSME Applicable", true);
            end;
        }
        field(50004; "MSMEownedbySC/STEnterpreneur"; Boolean)
        {
            Caption = 'MSME owned by SC/ST Enterpreneur';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("MSME Applicable", true);
            end;
        }
        field(50005; "MSMEownedbyWomenEnterpreneur"; Boolean)
        {
            Caption = 'MSME owned by Women Enterpreneur';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("MSME Applicable", true);
            end;
        }
        field(50006; "PAN Linked with Aadhar"; Option)
        {
            OptionMembers = Yes,No,NotApplicable;
            OptionCaption = 'Yes,No,NotApplicable';
            trigger OnValidate()
            begin

                if "Partner Type" = "Partner Type"::Company then
                    if "PAN Linked with Aadhar" <> "PAN Linked with Aadhar"::NotApplicable then
                        Error(CompanyErr);
                if "Partner Type" = "Partner Type"::Person then
                    if "PAN Linked with Aadhar" = "PAN Linked with Aadhar"::NotApplicable then
                        Error(PersonError);


                if "PAN Linked with Aadhar" = "PAN Linked with Aadhar"::No then begin
                    //Validate("P.A.N. Status", "P.A.N. Status"::PANNOTAVBL);
                    "P.A.N. Status" := "P.A.N. Status"::PANNOTAVBL;
                    "P.A.N. Reference No." := Format("P.A.N. Status"::PANNOTAVBL);
                    //"P.A.N. Reference No." := DelStr("GST Registration No.", 1, 2);


                end;
                if "PAN Linked with Aadhar" = "PAN Linked with Aadhar"::Yes then begin
                    "P.A.N. Status" := "P.A.N. Status"::" ";
                    "P.A.N. Reference No." := format("P.A.N. Status"::" ");
                end;

            end;

        }
        modify("Partner Type")
        {
            trigger OnAfterValidate()
            begin
                if "Partner Type" = "Partner Type"::Company then begin
                    "PAN Linked with Aadhar" := "PAN Linked with Aadhar"::NotApplicable;

                end;
                if "Partner Type" = "Partner Type"::Person then begin
                    "PAN Linked with Aadhar" := "PAN Linked with Aadhar"::Yes;

                end;
            end;
        }
        field(50007; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Pending for Approval",Released;
            OptionCaption = 'Open,Pending for Approval,Released';
            Editable = false;
        }
        field(50008; "Specified Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Specified Vendor';
            trigger OnValidate()
            begin

                TDSConcessionalCode.Reset;
                TDSConcessionalCode.Setrange("Vendor No.", Rec."No.");
                if TDSConcessionalCode.Findset then
                    repeat
                        TDSConcessionalCode."Specified Vendor" := "Specified Vendor";
                        if not "Specified Vendor" then
                            TDSConcessionalCode."Concession Status" := TDSConcessionalCode."Concession Status"::Closed
                        else begin
                            if TDSConcessionalCode."Concession Validity Period" > Today then
                                TDSConcessionalCode."Concession Status" := TDSConcessionalCode."Concession Status"::Open

                        end;
                        TDSConcessionalCode.modify;
                    until TDSConcessionalCode.Next = 0;


            end;

        }








    }
    var
        Text001: Label 'Not Applicable Should Not Be an option When Partner Type Is person,Please Select Yes/No';
        CompanyErr: Label 'Vendor Partner Type is company Not Applicable Should be selected';
        PersonError: Label 'Vendor Partner Type Is company Not Applicable Should Not Be Selected';
        TDSConcessionalCode: Record "TDS Concessional Code";


}