table 50101 "Webshop Order Line"
{
    Caption = 'Webshop Order Line';
    DataClassification = CustomerContent;
    LookupPageId = "Customer List";
    DrillDownPageId = "Item List";

    fields
    {
        field(1; "Item No."; Code[20]) //cikkszám (legördülő)
        {
            Editable = true;
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";

        }
        field(2; "Quantity"; Decimal) // mennyiség
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

        }
        field(3; "Unit code"; Code[10]) // mértékegység kód
        {
            Caption = 'Unit code';
            DataClassification = CustomerContent;

        }
        field(4; "Price"; Integer) //ár,de nem írjuk ide - 2. kérdés: Miért nem? válasz: Calculated field lesz
        {
            Caption = 'Price';
            DataClassification = CustomerContent;

        }
        field(5; "Unique ID"; Code[20]) // Egyedi azonosító - 3. kérdés: Mi lesz a kulcs, és miért?
        {
            Caption = 'Unique ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin

            end;

        }
    }

    keys
    {
        key(PK; "Unique ID")
        {
            Clustered = true;
        }
    }
}