page 50126 "Webshop Order List"
{

    Caption = 'Webshop Order List';
    PageType = List;
    SourceTable = "Webshop Order Header table";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Webshop Order ID"; "Webshop Order ID")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        WebshopDocumentTable: Record "Webshop Order Header table";
                        WebshopDocumentPage: Page "Webshop Order Document";
                    begin
                        WebshopDocumentTable.Reset();
                        WebshopDocumentTable.SetRange("Webshop Order ID", "Webshop Order ID");
                        Clear(WebshopDocumentPage);
                        WebshopDocumentPage.SetRecord(WebshopDocumentTable);
                        WebshopDocumentPage.SetTableView(WebshopDocumentTable);
                        WebshopDocumentPage.Run();
                    end;
                }

                field("BC Order No."; "BC Order ID")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesHeaderPage: Page "Sales Order";
                    begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("No.", "BC Order ID");
                        Clear(SalesHeaderPage);
                        SalesHeaderPage.SetRecord(SalesHeader);
                        SalesHeaderPage.SetTableView(SalesHeader);
                        SalesHeaderPage.Run();
                    end;
                }

                field(WebshopUserId; WebshopUserId)
                {
                    ApplicationArea = All;
                }

                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }

                field("Order Status"; "Order Status")
                {
                    ApplicationArea = All;
                }

                field("BC Customer ID"; "BC Customer ID")
                {
                    ApplicationArea = All;
                }


            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Process selected orders")
            {
                Caption = 'Process selected orders';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    AddRecordsToSalesOrders();
                end;
            }
        }
    }
    /// <summary> 
    /// Description for AddRecordsToSalesOrders.
    /// </summary>
    internal procedure AddRecordsToSalesOrders()
    var
        WebshopUtilities: Codeunit WebshopUtilities;

    begin
        //Message('Button was pressed pls help me die :(((');

        /*
            (*＾▽＾)／ <I can help you> ( ͡° ͜ʖ ͡°) 
                       [power loading...]

            (ノ・∀・)ノ SUDO DIE!
        ""-...                 .....-----""""
                   ヽ(^。^)丿
        */
        CurrPage.SetSelectionFilter(Rec);

        If (Rec.FindSet()) then
            repeat
                WebshopUtilities.GenerateSalesOrders(Rec);
            until Rec.Next() = 0;
        Rec.ClearMarks();
    end;

}
