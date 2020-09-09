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

        field(4; "Base unit of measure"; Code[10]) // mértékegység kód
        {
            Caption = 'Unit code';
            FieldClass = FlowField;
            CalcFormula = lookup (Item."Base Unit of Measure" where("No." = field("Item No.")));
        }

        field(5; "Price"; Integer) //ár,de nem írjuk ide - 2. kérdés: Miért nem? válasz: Calculated field lesz
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }

        field(6; "Unique ID"; Code[20]) // Egyedi azonosító - 3. kérdés: Mi lesz a kulcs, és miért?
        {
            Caption = 'Unique ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Unique ID" <> xRec."Unique ID" then begin
                    SalesSetup.Get();
                    NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
                    "No. Series" := '';
                end;
            end;
        }

        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }

        field(8; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
            TableRelation = "Webshop Order Header table"."Order No.";
        }
    }


    keys
    {
        key(PK; "Unique ID")
        {

        }
    }

    /// <summary> 
    /// Description for CalcPrice.
    /// </summary>
    local procedure CalcPrice()
    begin
        Price := Quantity * UnitPrice;
    end;

    trigger OnInsert()
    begin
        if "Unique ID" = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Customer Nos.");
            NoSeriesMgt.InitSeries(
                SalesSetup."Customer Nos.",
                xRec."No. Series",
                0D, "Unique ID",
                "No. Series"
            );
        end;
    end;

    trigger OnModify()
    begin
        CalcPrice();
    end;
    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldLine">Parameter of type Record "Webshop Order Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure AssistEdit(OldLine: Record "Webshop Order Line"): Boolean
    var
        Line: Record "Webshop Order Line";
    begin
        with Line do begin
            Line := Rec;
            SalesSetup.Get();
            SalesSetup.TestField("Customer Nos.");
            if NoSeriesMgt.SelectSeries(
                SalesSetup."Customer Nos.",
                OldLine."No. Series",
                "No. Series"
            ) then begin
                NoSeriesMgt.SetSeries("Unique ID");
                Rec := Line;
                exit(true);
            end;
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}