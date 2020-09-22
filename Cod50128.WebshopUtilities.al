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

    procedure GetItemsBughtByCustomer(
        CustomerNo: Code[20]
    ) ItemsBought: array[999999] of Text //max size of an array in bc
    var
        TempItem: Record Item;
        TempWebshopOrderLine: Record "Webshop Order Line";
        TempWebshopOrderHeader: Record "Webshop Order Header table";
        ArrayCount: Integer;
    begin
        ArrayCount := 0;
        TempWebshopOrderHeader.SetFilter(
            "BC Customer ID", CustomerNo
        );
        TempWebshopOrderHeader.FindFirst();
        repeat

            TempWebshopOrderLine.SetRange(
                "Webshop Order ID", TempWebshopOrderHeader."Webshop Order ID"
            );
            TempWebshopOrderLine.FindFirst();
            repeat
                TempWebshopOrderLine.CalcFields(Description);
                ItemsBought[ArrayCount] := TempWebshopOrderLine.Description;
                ArrayCount += 1;
            until TempWebshopOrderLine.Next() = 0;
        until TempWebshopOrderHeader.Next() = 0;
    end;

    procedure JoinText(
        TextArray: array[999999] of Text
    ) JoinedText: Text
    var
        ArrayCount: Integer;
    begin
        ArrayCount := 0;
        while TextArray[ArrayCount] <> '' do begin
            JoinedText += ', ' + TextArray[ArrayCount];
            JoinedText := JoinedText.TrimEnd(', ');
        end;
    end;

}

