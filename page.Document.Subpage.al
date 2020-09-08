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
                field(Quantity; Quantity)
                {


                }
                field("Unit code"; "Unit code")
                {


                }
                field(Price; Price)
                {


                }
                field("Unique ID"; "Unique ID")
                {


                }
            }
        }
    }


    var
        myInt: Integer;
}