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

            column(Description; Description)
            {
            }

            column(ValueSold; TempValueSold)
            {
            }

            column(DescriptionLabel; DescriptionLabel) { }

            column(ValueSoldLabel; ValueSoldLabel) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CaptionForHeader; CaptionForHeader) { }

            // TODO

            // új column a pénznemnek

            // új column a cégnévhez (CRONUS)

            // új column a dátumhoz - nyelvi beállítás szerint!

            // ennek a reportnak a Captionjét át lehet vinni Word-be?

            trigger OnAfterGetRecord()
            begin
                TempValueSold := WebshopUtils.GetTotalSalesForItem(Item."No.");
                if (TempValueSold <> 0) then begin
                    TempExcelRecord.Init();
                    TempExcelRecord.Description := Description;
                    TempExcelRecord.ValueSold := TempValueSold;
                    TempExcelRecord.Insert();
                end;
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
        TempExcelBuf.AddColumn(CaptionForHeader, false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
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
        CaptionForHeader: Label 'Top 10 sold Webshop Items';

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
