page 50124 "Webshop Order Document"
{
    Caption = 'Webshop Order Document';
    PageType = Document;
    UsageCategory = Documents;
    SourceTable = "Webshop Order Header table";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Webshop Order ID"; "Webshop Order ID")
                {
                    Editable = false;
                }

                field("Webshop User ID"; WebshopUserId)
                {
                    LookupPageId = "Customer Card";
                }

                field("BC Customer ID"; "BC Customer ID")
                {
                    DrillDownPageId = "Customer Card";
                }

                field("BC Order ID"; "BC Order ID")
                {
                    LookupPageId = "Sales Order";
                }

                field("Order Date"; "Order Date")
                {

                }

                field("Order Status"; "Order Status")
                {

                }

            }
            part(lines; "Webshop Order Line Subpage")
            {
                SubPageLink = "Webshop Order ID" = field("Webshop Order ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}