page 50125 "Webshop Order Line Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Webshop Order Line";
    AutoSplitKey = true;
    DelayedInsert = true;

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
            }
        }
    }


    var
        myInt: Integer;
}