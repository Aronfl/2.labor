report 50131 "Top Webshop Items"
{

    WordLayout = 'TopItems.docx';
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
            trigger OnAfterGetRecord()
            begin
                TempValueSold := WebshopUtils.GetTotalSalesForItem(Item."No.");
                TempExcelBuf.EnterCell(TempExcelBuf, LineCount, 1, Description, false, false, false);
                TempExcelBuf.EnterCell(TempExcelBuf, LineCount, 2, TempValueSold, false, false, false);
                LineCount += 1;
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
        if (ExcelOutputRequested) then begin
            TempExcelBuf.CreateNewBook('Top Webshop Items');
            TempExcelBuf.SetFriendlyFilename('Top Webshop Items');
            TempExcelBuf.WriteSheet('Top Webshop Items', CompanyName(), UserId());
            TempExcelBuf.CloseBook();
            TempExcelBuf.OpenExcel();
        end;

    end;

    local procedure SetUpExcelBufferHEader()
    begin
        TempExcelBuf.AddColumn('Item Descrition', false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn('Total Sales', false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
    end;



    var

        WebshopUtils: Codeunit WebshopUtilities;
        LineCount: Integer;
        TempExcelBuf: Record "Excel Buffer" temporary;
        ExcelOutputRequested: Boolean;
        TempValueSold: Decimal;

}
