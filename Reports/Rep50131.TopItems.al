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
        dataitem(Item; Item)
        {
            column(Description; Description) { }
            column(ValueSold; TempValueSold) { }
            column(DescriptionLabel; DescriptionLabel) { }
            column(ValueSoldLabel; ValueSoldLabel) { }
            column(CompanyName; CompanyName()) { }
            column(CaptionForHeader; CaptionForHeader) { }
            column(Currency; CurrencySymbol) { }
            column(DateString; DateString) { }
            column(TotalPrice; SumPrice) { }
            column(CurrReportPageNo; CurrReport.PageNo()) { }
            column(ReportId; Format(This, 20)) { }
            column(Sumline; Sumline) { }

            trigger OnAfterGetRecord()
            begin
                TempValueSold := WebshopUtils.GetTotalSalesForItem(Item."No.");
                if (TempValueSold <> 0) then begin
                    TempExcelRecord.Init();
                    TempExcelRecord.Description := Description;
                    TempExcelRecord.ValueSold := TempValueSold;
                    TempExcelRecord.Insert();
                end else begin
                    CurrReport.Skip();
                end;
                /* TODO

                1.) sorba rendezni a TempExcelRecordban ValueSold alapján csökkenő sorrendbe

                2.) megtartjuk az első 10 db-ot, többit eldobjuk

                3.) összérték

                */
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
        LineCount := 2;
        SetUpExcelBufferHEader();
        GLSetup.get();
        CurrencySymbol := GLSetup.GetCurrencySymbol();
        if (GlobalLanguage() = 1038) then begin //HUN
            DateString := Format(Today(), 0, '<Year4>. <Month Text> <Day>.')
        end else begin
            DateString := Format(Today(), 0, '<Month Text> <Day>. <Year4>.')
        end;
    end;

    trigger OnPostReport()
    begin
        TempExcelRecord.SetCurrentKey(ValueSold);
        TempExcelRecord.SetAscending(ValueSold, false);
        if (ExcelOutputRequested) then begin
            if (TempExcelRecord.FindSet()) then
                repeat
                    TempExcelBuf.EnterCell(TempExcelBuf, LineCount, 1, TempExcelRecord.Description, false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, LineCount, 2, TempExcelRecord.ValueSold, false, false, false);
                    LineCount += 1;
                until (TempExcelRecord.Next() = 0) or (LineCount = ExcelMaxRowCount + 2);

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

    local procedure GetTotalPrice(): Decimal //do something?
    var
        TempExcelRecord: Record "ExcelItem";
    begin
        if IsSimplePage then begin
            TempExcelRecord.SetRange("ValueSold");
            TempExcelRecord.CalcSums("ValueSold");
            exit(TempExcelRecord."ValueSold");
        end
    end;

    var

        WebshopUtils: Codeunit WebshopUtilities;
        LineCount: Integer;
        TempExcelBuf: Record "Excel Buffer" temporary;
        ExcelOutputRequested: Boolean;
        ExcelMaxRowCount: Integer;
        TempValueSold: Decimal;
        TempExcelRecord: Record ExcelItem temporary;
        ValueSoldLabel: Label 'Value Sold';
        DescriptionLabel: Label 'Item Description';
        GLSetup: Record "General Ledger Setup";
        CurrencySymbol: Text[10];
        Currency: Record Currency;
        CaptionForHeader: Label 'Top 10 sold Webshop Items';
        DateString: Text;
        Language: Record Language;
        This: Report "Top Webshop Items";
        IsSimplePage: Boolean;
        SumPrice: Decimal;
        Sumline: Label 'Total value of best selled items:';

}


/// <summary> 
/// Table ExcelItem (ID 50130), only for temporary use within Top Items reports
/// </summary>
table 50130 ExcelItem
{

    fields
    {
        field(1; Description; Text[100])
        { }

        field(2; ValueSold; Decimal)
        { }
    }
    keys
    {
        key(PK; Description, ValueSold)
        {
            Clustered = true;
        }
    }
}
