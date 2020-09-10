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

                // A soron pedig a cikkek Megnevezése is szerepeljen.

                field("Item Name"; Description)
                {

                }

                field("Quantity"; "Quantity")
                {


                }

                field("Unit code"; "Base unit of measure")
                {


                }

                field(Price; Price)
                {


                }

                field("Line No."; "Line No.")
                {

                }

                field("Order No."; "Order No.")
                {

                }

                field("Unit Price"; "Unit Price")
                {

                }
            }
        }
    }

    local procedure SetOrderNo()
    begin

    end;
}