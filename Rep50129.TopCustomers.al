report 50129 "Top Webshop Customers"
{
    WordLayout = 'TopCustomers.docx';
    RDLCLayout = 'TopCustomers.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(WebshopOrder; "Webshop Order Header table")
        {
            column(CustomerName; TempCustomer.Name)
            {

            }

            //will be summed in the report
            column(MoneySpent; WebshopOrder.Price)
            {

            }

            column(ItemsBought; WebshopUtils.GetItemsBughtByCustomerText(TempCustomer."No."))
            {

            }
            trigger OnAfterGetRecord()
            begin
                WebshopOrder.CalcFields("BC Customer ID", Price);
                TempCustomer.Get(WebshopOrder."BC Customer ID");
            end;

            trigger OnPostDataItem()
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
                }
            }
        }

        actions
        {
            area(processing)
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
        SetUpExcelBufferHEader();
    end;

    trigger OnPostReport()
    begin
        TempExcelBuf.WriteAllToCurrentSheet(TempExcelBufSheet);
        TempExcelBuf.SetFriendlyFilename('Top Webshop Customers.xlsx');
        TempExcelBuf.OpenExcel();
    end;

    /// <summary>
    /// Sets up basic column header names for the buffer
    /// </summary>
    local procedure SetUpExcelBufferHEader()
    begin
        TempExcelBufSheet.EnterCell(TempExcelBuf, 1, 1, 'Customer name', false, false, false);
        TempExcelBufSheet.EnterCell(TempExcelBuf, 1, 2, 'Customer name', false, false, false);
        TempExcelBufSheet.EnterCell(TempExcelBuf, 1, 3, 'Customer name', false, false, false);
    end;

    var
        TempCustomer: Record Customer;
        WebshopUtils: Codeunit WebshopUtilities;
        LineCount: Integer;
        TempExcelBuf: Record "Excel Buffer" temporary;
        TempExcelBufSheet: Record "Excel Buffer" temporary;
        ExcelOutputRequested: Boolean;

}
