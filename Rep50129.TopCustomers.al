report 50129 "Top Webshop Customers"
{
    Caption = 'Top Webshop Customers';
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

            column(ItemsBought; TempItemsBoughtText)
            {

            }
            trigger OnAfterGetRecord()
            begin
                WebshopOrder.CalcFields("BC Customer ID", Price);
                TempCustomer.Get(WebshopOrder."BC Customer ID");
                TempItemsBoughtText := WebshopUtils.GetItemsBughtByCustomerText(TempCustomer."No.");
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


            }
        }
    }
    var
        TempItemsBoughtText: Text;
        TempCustomer: Record Customer;
        WebshopUtils: Codeunit WebshopUtilities;

}
