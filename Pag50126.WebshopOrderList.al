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
                    DrillDownPageId = "Sales Order";
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
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        WebshopOrderDocument: Record "Webshop Order Header table";
        WebshopOrderLine: Record "Webshop Order Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNoSeries: Code[20];
    begin
        CurrPage.SetSelectionFilter(Rec);
        If (Rec.FindSet()) then begin
            repeat
                Message('processing order with id: ' + Format(Rec."Webshop Order ID"));

                SalesHeader.Init();
                SalesHeader."Bill-to Customer No." := WebshopOrderDocument."BC Customer ID";
                SalesHeader."Sell-to Customer No." := WebshopOrderDocument."BC Customer ID";
                SalesHeader."Document Date" := Today();
                SalesHeader."Document Type" := "Sales Document Type"::Order;
                WebshopOrderLine.SetRange("Webshop Order ID", Rec."Webshop Order ID");
                WebshopOrderLine.FindFirst();
                NoSeriesMgt.InitSeries(
                    "SalesHeader".GetNoSeriesCode,
                    SalesHeader."No. Series",
                    SalesHeader."Posting Date",
                    SalesHeader."No.",
                    NewNoSeries
                );
                SalesHeader."No." := NoSeriesMgt.GetNextNo(NewNoSeries, Today(), true);
                SalesHeader.Insert();
                //TODO: fill it up with data
                repeat
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."No." := WebshopOrderLine."Item No.";
                    SalesLine.Type := SalesLine.Type::Item;
                    SalesLine."Line No." := WebshopOrderLine."Line No.";

                    //TODO: No. increment by 10000
                    SalesLine.Quantity := WebshopOrderLine.Quantity;
                    SalesLine."Quantity (Base)" := WebshopOrderLine.Quantity;
                    SalesLine."Qty. to Invoice" := WebshopOrderLine.Quantity;
                    SalesLine."Qty. to Invoice (Base)" := WebshopOrderLine.Quantity;
                    SalesLine."Qty. to Ship" := WebshopOrderLine.Quantity;
                    SalesLine."Qty. to Ship (Base)" := WebshopOrderLine.Quantity;
                    SalesLine."Gen. Prod. Posting Group" := 'RETAIL';
                    SalesLine."Gen. Bus. Posting Group" := 'EU';
                    SalesLine."VAT Bus. Posting Group" := 'EU';
                    SalesLine.INSERT;
                until WebshopOrderLine.Next() = 0;
                Rec."Order Status" := OrderStatusEnum::processed;
                Rec."BC Order ID" := SalesHeader."No.";
                Rec.Modify();

            until Rec.Next() = 0;
            Rec.ClearMarks();
        end;
    end;

}
