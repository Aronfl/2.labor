table 50100 "Webshop Order Header"
{
    Caption = 'Webshop Order Header';
    LookupPageId = "Customer List";
    DrillDownPageId = "Item List";

    fields
    {

        field(1; "Webshop Order ID"; Integer)
        {
            Caption = 'Webshop Order ID';
        }
        field(2; WebshopUserId; Integer)
        {
            Caption = 'Webshop User ID';
        }

        field(3; "BC Customer ID"; Code[20]) // BC vevő azonosító
        {
            Caption = 'Customer ID from BC';
            FieldClass = FlowField;
            //CalcFormula = lookup (Customer."No." where("No." = field("BC Customer ID")));
            // sztem így helyes:
            CalcFormula = lookup (Customer."No." where(CustomercardWebshopUserId = field(WebshopUserId)));
        }
        field(4; "Order No."; Code[20]) // BC rendelés szám
        {
            Caption = 'Order No.';
        }
        field(5; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(6; "Order Status"; Enum OrderStatusEnum)
        {
            Caption = 'Order Status';
        }

    }

    keys
    {
        key(PK; "Webshop Order ID")
        {
            Clustered = true;
        }
    }
}
enum 50110 OrderStatusEnum
{
    Extensible = true;

    value(0; received)
    {
    }
    value(1; processed)
    {
    }
    value(2; shipped)
    {
    }
}