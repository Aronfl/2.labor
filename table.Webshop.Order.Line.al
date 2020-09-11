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
            trigger OnValidate()
            begin
                CalcPrice();
            end;
        }

        field(2; "Quantity"; Decimal) // mennyiség
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalcPrice();
            end;
        }

        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Item"."Unit Price" where("No." = field("Item No.")));
            trigger OnValidate()
            begin

                CalcPrice();
            end;
        }

        field(4; "Base unit of measure"; Code[10]) // mértékegység kód
        {
            Caption = 'Unit code';
            FieldClass = FlowField;
            CalcFormula = lookup (Item."Base Unit of Measure" where("No." = field("Item No.")));
        }

        field(5; "Price"; Decimal) //ár,de nem írjuk ide - 2. kérdés: Miért nem? válasz: Calculated field lesz
        {
            Caption = 'Price';
            Editable = false;
        }

        field(6; "Line No."; Integer) // Egyedi azonosító - 3. kérdés: Mi lesz a kulcs, és miért?
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }


        field(7; "Webshop Order ID"; Integer)
        {
            Caption = 'Order No.';
            Editable = false;
            TableRelation = "Webshop Order Header table"."Webshop Order ID";
        }

        field(8; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Description where("No." = field("Item No.")));
        }
    }


    keys
    {
        key(PK; "Webshop Order ID", "Line No.")
        {

        }
    }

    /// <summary> 
    /// Description for CalcPrice.
    /// </summary>
    local procedure CalcPrice()
    begin
        CalcFields("Unit Price");
        Price := Quantity * "Unit Price";
        // Message(
        //     'the calculated price is: ' + Format(Price) +
        //     ', where quantity was: ' + Format(Quantity) +
        //     ', and unit price was: ' + Format("Unit Price")
        // );
    end;

    trigger OnInsert()
    begin
        CalcPrice();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}