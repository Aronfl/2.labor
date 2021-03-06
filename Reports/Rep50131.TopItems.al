report 50131 "Top Webshop Items"
{
    Caption = 'Top Webshop Items';
    WordLayout = 'Layouts/TopItems.docx';
    RDLCLayout = 'Layouts/TopItems.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    
    dataset
    {

        dataitem(PleaseWork; ExcelItem)
        {
            DataItemTableView = sorting(ValueSold) order(descending);
            UseTemporary = true;

            column(Description; Description) { }
            column(ValueSold; ValueSold) { }
            column(DescriptionLabel; DescriptionLabel) { }
            column(ValueSoldLabel; ValueSoldLabel) { }
            column(Quantity; Quantity) { }
            column(Quantity_Label; Quantity_Label) { }
            column("UnitCode"; "UnitCode") { }
            column(CompanyName; CompanyName) { }
            column(CaptionForHeader; CaptionForHeader) { }
            column(Currency; CurrencySymbol) { }
            column(DateString; DateString) { }
            column(TotalPrice; TotalValue) { }
            column(CurrReportPageNo; CurrReport.PageNo()) { }
            column(ReportId; Format(This, 20)) { }
            column(Sumline; Sumline) { }
            column(ReportIdLabel; ReportIdLabel) { }
            column(totalAmountOfWarranty; totalAmountOfWarranty) { }
            column(totalAmountOfWarranty_Label; totalAmountOfWarranty_Label) { }
            column(FullTotalPrice; FullTotalPrice) { }
            column(FullTotalPrice_Label; FullTotalPrice_Label) { }

            trigger OnAfterGetRecord()
            begin

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(ExcelOutputRequested; ExcelOutputRequested)
                    {
                        Caption = 'Do you want to download a happy little excel gift?';
                    }

                    field(ExcelMaxRowCount; ExcelMaxRowCount)
                    {
                        Caption = 'How many rows you wish for, master?';
                    }
                }
            }
        }

        actions
        {
            area(Creation)
            {
                action("Export Excel file")
                {
                    Caption = 'Export Excel file';
                    Promoted = true;
                    PromotedCategory = Report;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        TempExcelBuffer: Record "Excel Buffer" temporary;
                    begin
                        ExcelOutputRequested := true;
                    end;
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        // Default value of rows
        ExcelMaxRowCount := 10;
    end;

    trigger OnPreReport()
    var
        ItemRecord: Record Item;
    begin
        ExcelLineCount := 2;
        SetUpExcelBufferHEader();
        GLSetup.get();
        CurrencySymbol := GLSetup.GetCurrencySymbol();
        if (GlobalLanguage() = 1038) then begin //HUN
            DateString := Format(Today(), 0, '<Year4>. <Month Text> <Day>.')
        end else begin
            DateString := Format(Today(), 0, '<Month Text> <Day>. <Year4>.')
        end;

        ItemRecord.SetCurrentKey("No.");
        ItemRecord.FindFirst();
        TempExcelRecord.Reset();
        TempExcelRecord.DeleteAll();
        TempValueSold := 0;
        TempQuantity := 0;
        TempWarrantySold := 0;
        FullTotalPrice := 0;
        repeat
            TempValueSold := WebshopUtils.GetTotalSalesForItem(ItemRecord."No.");
            TempWarrantySold := WebshopUtils.GetTotalWarrantyForItem(ItemRecord."No.");
            TempQuantity := WebshopUtils.GetTotalQuatityForItem(ItemRecord."No.");
            if (TempValueSold <> 0) then begin
                TempExcelRecord.Init();
                TempExcelRecord.CaptionForHeader := CaptionForHeader;
                TempExcelRecord.CompanyName := CompanyName();
                TempExcelRecord.CurrencySymbol := CurrencySymbol;
                TempExcelRecord.DateString := DateString;
                if (ItemRecord.Description <> '') then
                    TempExcelRecord.Description := ItemRecord.Description
                else
                    TempExcelRecord.Description := ItemRecord."Description 2";

                TempExcelRecord.Description := ItemRecord.Description;
                TempExcelRecord."UnitCode" := Itemrecord."Base Unit of Measure";
                TempExcelRecord.DescriptionLabel := DescriptionLabel;
                TempExcelRecord.SumLine := Sumline;
                TempExcelRecord.ValueSold := TempValueSold;
                TempExcelRecord.Quantity := TempQuantity;
                TempExcelRecord.TempWarrantySold := TempWarrantySold;
                TempExcelRecord.Insert();
                PleaseWork := TempExcelRecord;
                PleaseWork.Insert();
                //calculating total sales value
                TotalValue += TempValueSold;
                totalAmountOfWarranty += TempWarrantySold;
                FullTotalPrice := TotalValue + totalAmountOfWarranty;
                ReportLineCount += 1;
            end

        until ((ItemRecord.Next() = 0) or (ReportLineCount >= ExcelMaxRowCount));




    end;

    trigger OnPostReport()
    begin
        TempExcelRecord.SetCurrentKey(ValueSold);
        TempExcelRecord.SetAscending(ValueSold, false);
        if (ExcelOutputRequested) then begin
            if (TempExcelRecord.FindSet()) then
                repeat
                    TempExcelBuf.EnterCell(TempExcelBuf, ExcelLineCount, 1, TempExcelRecord.Description, false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, ExcelLineCount, 2, TempExcelRecord.ValueSold, false, false, false);
                    ExcelLineCount += 1;
                until (TempExcelRecord.Next() = 0) or (ExcelLineCount = ExcelMaxRowCount + 2);

            TempExcelBuf.CreateNewBook('Top Webshop Items');
            TempExcelBuf.SetFriendlyFilename('Top Webshop Items');
            TempExcelBuf.WriteSheet('Top Webshop Items', CompanyName(), UserId());
            TempExcelBuf.CloseBook();
            TempExcelBuf.OpenExcel();
        end;

    end;

    local procedure SetUpExcelBufferHEader()
    begin
        TempExcelBuf.AddColumn(DescriptionLabel, false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(ValueSoldLabel, false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
    end;


    var

        WebshopUtils: Codeunit WebshopUtilities;
        ExcelLineCount: Integer;
        TempExcelBuf: Record "Excel Buffer" temporary;
        ExcelOutputRequested: Boolean;
        ExcelMaxRowCount: Integer;
        TempValueSold: Decimal;
        TempQuantity: Integer;
        TempWarrantySold: Decimal;
        TempExcelRecord: Record ExcelItem temporary;
        ValueSoldLabel: Label 'Value Sold';
        DescriptionLabel: Label 'Item Description';
        GLSetup: Record "General Ledger Setup";
        CurrencySymbol: Text[10];
        CaptionForHeader: Label 'Top sold Webshop Items';
        ReportIdLabel: Label 'Report Id';
        DateString: Text;
        This: Report "Top Webshop Items";
        Sumline: Label 'Total value of best selled items:';
        ReportLineCount: Integer;
        TotalValue: Decimal;
        totalAmountOfWarranty: Decimal; // ide töltsük az összes garanciára költött összeget
        totalAmountOfWarranty_Label: Label 'Total Amount Of Warrianty: ';
        FullTotalPrice: Decimal;
        FullTotalPrice_Label: Label 'Total:';
        Quantity_Label: Label 'Quantity';
        TempUnitCode: Code[10];

}


/// <summary> 
/// Table ExcelItem (ID 50130), only for temporary use within Top Items reports.
/// </summary>
table 50130 ExcelItem
{
    fields
    {
        field(1; Description; Text[100])
        { }

        field(11; Quantity; Integer) { }

        field(12; "UnitCode"; Code[10])
        { }
        field(2; ValueSold; Decimal)
        { }

        field(10; TempWarrantySold; Decimal)
        { }
        field(3; DescriptionLabel; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; CompanyName; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; CaptionForHeader; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; CurrencySymbol; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; DateString; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(9; SumLine; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Description, ValueSold)
        {
            Clustered = true;
        }
    }
}
