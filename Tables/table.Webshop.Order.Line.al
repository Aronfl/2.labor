table 50101 "Webshop Order Line"
{
    Caption = 'Webshop Order Line';
    DataClassification = CustomerContent;
    LookupPageId = "Item List";
    DrillDownPageId = "Item List";


    fields
    {
        field(1; "Item No."; Code[20])
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

        field(2; "Quantity"; Decimal)
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
            CalcFormula = lookup("Item"."Unit Price" where("No." = field("Item No.")));
            trigger OnValidate()
            begin

                CalcPrice();
            end;
        }

        field(4; "Base unit of measure"; Code[10])
        {
            Caption = 'Unit code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }

        field(5; Price; Decimal)
        {
            Caption = 'Price';
            Editable = false;
        }
        field(6; "ext. warranty price"; Decimal)
        {
            Caption = 'ext. warranty price';
            Editable = false;
        }
        field(7; "Price with warranty"; Decimal)
        {
            Caption = 'Price with warranty';
            Editable = false;
        }
        field(8; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }


        field(9; "Webshop Order ID"; Integer)
        {
            Caption = 'Order No.';
            Editable = false;
            TableRelation = "Webshop Order Header table"."Webshop Order ID";
        }

        field(10; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(11; "Reference for Date Calculation"; Date)
        {
            InitValue = 20201115D;

            Caption = 'Target shipping date';
            trigger OnValidate()
            var

            begin
                CalculateNewDate();
            end;
        }

        field(12; "enumWarranty"; Enum enumWarranty)
        {
            InitValue = "<1Y>";
            Caption = 'Warranty';

            trigger OnValidate()
            begin
                CalculateNewDate();
                CalcPrice();
            end;
        }
        field(13; "Date Result"; Date)
        {
            Caption = 'Expiration';
            Editable = false;

        }
    }


    keys
    {
        key(PK; "Webshop Order ID", "Line No.")
        {

        }
    }
    var

        Initvalue: Enum enumWarranty;

    /// <summary> 
    /// Description for CalculateNewDate.
    /// </summary>
    local procedure CalculateNewDate()
    var
        DateFormulaToUse: DateFormula;
        EnumText: Text[10];
        EnumIndex: Integer;
    begin
        EnumIndex := "enumWarranty".AsInteger();
        "enumWarranty".Names().Get(EnumIndex, EnumText);
        if (System.Evaluate(DateFormulaToUse, EnumText)) then begin
            "Date Result" := CalcDate(DateFormulaToUse, "Reference for Date Calculation");
        end;

    end;

    /// <summary> 
    /// Description for CalcPrice.
    /// </summary>
    procedure CalcPrice()
    var
        EnumText: Text[5];
        EnumIndex: Integer;
        extendedWarPrice: Decimal;
    begin
        CalcFields("Unit Price");
        extendedWarPrice := "Unit Price" * 0.15;
        EnumIndex := "enumWarranty".AsInteger();
        "enumWarranty".Names().Get(EnumIndex, EnumText);

        if (EnumText = '<5Y>') then begin
            "ext. warranty price" := Quantity * extendedWarPrice;
        end
        else begin
            "ext. warranty price" := 0;
        end;
        Price := Quantity * "Unit Price";
        "Price with warranty" := Price + "ext. warranty price";

    end;

    trigger OnInsert()
    begin
        CalcPrice();
    end;
}
enum 50131 enumWarranty
{

    value(1; "<1Y>")
    {
        Caption = '1 Year';
    }
    value(2; "<5Y>")
    {
        Caption = '5 Year (extended)';
    }

}
