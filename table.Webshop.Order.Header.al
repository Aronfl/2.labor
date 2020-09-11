table 50100 "Webshop Order Header table"
{
    Caption = 'Webshop Order Header';
    DrillDownPageId = "Webshop Order List";
    LookupPageId = "Webshop Order List";

    fields
    {

        field(1; "Webshop Order ID"; Integer)
        {
            Caption = 'Webshop Order ID';
            AutoIncrement = true;
        }
        field(2; WebshopUserId; Integer)
        {
            Caption = 'Webshop User ID';
            trigger OnValidate()
            begin
                if WebshopUserId < 0 then begin
                    Message('Webshop ID cannot be negative number');
                    WebshopUserId := 0;
                end;
            end;
        }

        field(3; "BC Customer ID"; Code[20]) // BC vevő azonosító
        {
            Caption = 'Customer ID from BC';
            FieldClass = FlowField;
            CalcFormula = lookup (Customer."No." where(CustomercardWebshopUserId = field(WebshopUserId)));
            // TableRelation = Customer;
        }
        field(4; "BC Order ID"; Code[20]) // BC rendelés szám
        {
            Caption = 'Order No.';
            TableRelation = "Sales Header";
        }
        field(5; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(6; "Order Status"; Enum OrderStatusEnum)
        {
            Caption = 'Order Status';
        }

        field(7; UserName; Text[100])
        {
            Caption = 'User Name';
            FieldClass = FlowField;
            CalcFormula = lookup (Customer.Name where(CustomercardWebshopUserId = field(WebshopUserId)));
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