tableextension 50025 SalesShipmentExt extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Sales Invoice No."; COde[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Invoice No.';
        }
    }

    var

}