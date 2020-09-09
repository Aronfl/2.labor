page 50126 "Webshop Order List"
{

    Caption = 'Webshop Order List';
    PageType = List;
    SourceTable = "Webshop Order Header table";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Webshop Order ID"; "Webshop Order ID")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Webshop Order Document";
                }

                field("Order No."; "Order No.")
                {
                    ApplicationArea = All;
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
            action("Add new order")
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
    begin
        Message('please add your order!');
        CurrPage.SetSelectionFilter(Rec);
        If (Rec.FindSet()) then begin
            repeat
                Message('processing order with id: ' + Format(Rec."Webshop Order ID"));

                SalesHeader.Init();
                WebshopOrderLine.SetRange("Order No.", Rec."Order No.");
                WebshopOrderLine.FindFirst();
                //TODO: fill it up with data
                repeat
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine.Type := SalesLine.Type::Item;
                    //TODO: No. increment by 10000
                    // SalesLine.Quantity := Quantity;
                    // SalesLine."Quantity (Base)" := Quantity;
                    // SalesLine."Qty. to Invoice" := Quantity;
                    // SalesLine."Qty. to Invoice (Base)" := Quantity;
                    // SalesLine."Qty. to Ship" := Quantity;
                    // SalesLine."Qty. to Ship (Base)" := Quantity;
                    // SalesLine."Gen. Prod. Posting Group" := 'RETAIL';
                    // SalesLine."Gen. Bus. Posting Group" := 'EU';
                    // SalesLine."VAT Bus. Posting Group" := 'EU';
                    SalesLine.INSERT;
                until WebshopOrderLine.Next() = 0;
                SalesHeader.Insert();
            until Rec.Next() = 0;
            Rec.ClearMarks();
        end;
    end;

}
