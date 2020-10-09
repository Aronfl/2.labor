page 50125 "Webshop Order Line Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Webshop Order Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; "Item No.")
                {
                    TableRelation = Item;
                }

                field("Item Name"; Description)
                {
                }

                field("Quantity"; "Quantity")
                {
                }

                field("Unit code"; "Base unit of measure")
                {
                }

                field("Line No."; "Line No.")
                {
                }

                field("Webshop Order ID"; "Webshop Order ID")
                {
                }

                field("Unit Price"; "Unit Price")
                {
                }
                field(Price; Price)
                {
                }
                field("ext. warranty price"; "ext. warranty price")
                {
                    ApplicationArea = All;
                }
                field("Price with warranty"; "Price with warranty")
                {
                    ApplicationArea = All;
                }
                field("Reference for Date Calculation"; "Reference for Date Calculation")
                {
                    ApplicationArea = All;
                }
                field("enumWarrantee"; "enumWarranty")
                {
                    ApplicationArea = All;
                }
                field("Date Result"; Rec."Date Result")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}