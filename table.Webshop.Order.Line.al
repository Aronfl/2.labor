table 50101 "Webshop Order Line"
{
    Caption = 'Webshop Order Line';
    DataClassification = CustomerContent;
    LookupPageId = "Item List";
    DrillDownPageId = "Item List";


    fields
    {
        field(1; "Item No."; Code[20]) //cikkszám (legördülő)
        {
            Editable = true;
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = "Item";
        }

        field(2; "Quantity"; Decimal) // mennyiség
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }

        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Item"."Unit Price" where("No." = field("Item No.")));
        }

        field(4; "Base unit of measure"; Code[10]) // mértékegység kód
        {
            Caption = 'Unit code';
            FieldClass = FlowField;
            CalcFormula = lookup (Item."Base Unit of Measure" where("No." = field("Item No.")));
        }

        field(5; "Price"; Integer) //ár,de nem írjuk ide - 2. kérdés: Miért nem? válasz: Calculated field lesz
        {
            Caption = 'Price';
            Editable = false;
        }

        field(6; "Line No."; BigInteger) // Egyedi azonosító - 3. kérdés: Mi lesz a kulcs, és miért?
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }


        field(7; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
            TableRelation = "Webshop Order Header table"."Order No.";
        }
    }


    keys
    {
        key(PK; "Line No.", "Order No.")
        {

        }
    }

    /// <summary> 
    /// Description for CalcPrice.
    /// </summary>
    local procedure CalcPrice()
    begin
        Price := Quantity * "Unit Price";
    end;

    trigger OnModify()
    begin
        CalcPrice();
    end;

    trigger OnInsert()
    begin
        CalcPrice();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}