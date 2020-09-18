codeunit 50126 WebshopUtilities
{
    trigger OnRun()
    begin

    end;

    procedure GenerateSalesOrders(
        WebshopOrderHeaderRecord: Record "Webshop Order Header table"
    )
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        WebshopOrderLine: Record "Webshop Order Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNoSeries: Code[20];
        Customer: Record "Customer";
    begin
        Message('processing order with id: ' + Format(WebshopOrderHeaderRecord."Webshop Order ID"));
        Customer.Get(WebshopOrderHeaderRecord."BC Customer ID");
        SalesHeader.Init();
        WebshopOrderHeaderRecord.CalcFields("BC Customer ID");
        SalesHeader."Bill-to Customer No." := WebshopOrderHeaderRecord."BC Customer ID";
        SalesHeader."Sell-to Customer No." := WebshopOrderHeaderRecord."BC Customer ID";
        SalesHeader."Document Date" := Today();
        SalesHeader."Document Type" := "Sales Document Type"::Order;
        WebshopOrderHeaderRecord.SetRange("Webshop Order ID", WebshopOrderHeaderRecord."Webshop Order ID");
        WebshopOrderHeaderRecord.FindFirst();
        NoSeriesMgt.InitSeries(
            "SalesHeader".GetNoSeriesCode,
            SalesHeader."No. Series",
            SalesHeader."Posting Date",
            SalesHeader."No.",
            NewNoSeries
        );
        SalesHeader."No." := NoSeriesMgt.GetNextNo(NewNoSeries, Today(), true);
        SalesHeader."Sell-to Customer Name" := Customer.Name;
        SalesHeader."Bill-to Name" := Customer.Name;
        SalesHeader."Sell-to Address" := Customer.Address;
        SalesHeader."Bill-to Customer No." := Customer."No.";
        SalesHeader."Bill-to Address" := Customer.Address;
        SalesHeader."Order Date" := WebshopOrderHeaderRecord."Order Date";
        SalesHeader.Insert();
        WebshopOrderLine.SetRange("Webshop Order ID", WebshopOrderHeaderRecord."Webshop Order ID");
        repeat
            if (WebshopOrderLine."Item No." <> '') then begin
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := WebshopOrderLine."Line No.";
                SalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine.Validate("No.", WebshopOrderLine."Item No.");
                SalesLine.Validate(Quantity, WebshopOrderLine.Quantity);
                SalesLine.Insert();
            end;
        until WebshopOrderLine.Next() = 0;
        WebshopOrderHeaderRecord."Order Status" := OrderStatusEnum::processed;
        WebshopOrderHeaderRecord."BC Order ID" := SalesHeader."No.";
        WebshopOrderHeaderRecord.Modify();
    end;

}

