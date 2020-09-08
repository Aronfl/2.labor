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
            trigger OnValidate();
            begin
                CalcPrice();
            end;

        }

        field(2; "Quantity"; Decimal) // mennyiség
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                CalcPrice();
            end;
        }

        field(3; UnitPrice; Decimal)
        {
            Caption = 'Unit Price';
            FieldClass = FlowField;
            CalcFormula = lookup (Item."Unit List Price" where("No." = field("Item No.")));

        }

        field(4; "Unit code"; Code[10]) // mértékegység kód
        {
            Caption = 'Unit code';
            DataClassification = CustomerContent;

        }

        field(5; "Price"; Integer) //ár,de nem írjuk ide - 2. kérdés: Miért nem? válasz: Calculated field lesz
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
            // Price := Quantity * Item.unitPrice <== how to get this out of db?

        }

        field(6; "Unique ID"; Code[20]) // Egyedi azonosító - 3. kérdés: Mi lesz a kulcs, és miért?
        {
            Caption = 'Unique ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin

            end;
            // TODO add unique id
            // Use No. series design pattern here

        }
    }

    keys
    {
        key(PK; "Unique ID")
        {
            Clustered = true;
        }
    }

    /// <summary> 
    /// Description for CalcPrice.
    /// </summary>
    local procedure CalcPrice()
    var

    begin
        // UnitPrice := item.Get('123');

    end;
}