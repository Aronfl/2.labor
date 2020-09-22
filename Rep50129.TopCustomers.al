report 50129 "Top Customers"
{
    WordLayout = 'TopCustomers.docx';
    RDLCLayout = 'TopCustomers.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
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
            trigger OnAfterGetRecord()
            begin
                WebshopOrder.CalcFields("BC Customer ID", Price);
                TempCustomer.Get(WebshopOrder."BC Customer ID");
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
        TempCustomer: Record Customer;
}
