page 50007 TransactionCount
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Vendor Ledger Entry";
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        ShowDetails;
                    end;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    begin

        vendorLedgerEntry.RESET;
        VendorLedgerEntry.setrange("Vendor No.", rec."Vendor No.");
        VendorLedgerEntry.setrange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        IF vendorLedgerEntry.FIND('+') THEN BEGIN
            REPEAT
                CountGvar := CountGvar + 1;
                // MESSAGE('Customer number : %1 and Name : %2 ', vendorLedgerEntry."Vendor No.", vendorLedgerEntry."Entry No.");
                vendorLedgerEntry.Mark(true);

            UNTIL (CountGvar = 5) or (vendorLedgerEntry.NEXT(-1) = 0);
            VendorLedgerEntry.MarkedOnly(true);
        END;
        rec.copy(VendorLedgerEntry);

    end;

    local procedure ShowDetails()
    begin
        PurchaseInvHeader.Reset();
        PurchaseInvHeader.SetRange("No.", Rec."Document No.");
        Page.RunModal(138, PurchaseInvHeader);
    end;

    var
        CountGvar: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchaseInvHeader: Record "Purch. Inv. Header";

}