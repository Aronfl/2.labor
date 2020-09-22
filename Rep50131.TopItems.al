report 50131 "Top Webshop Items"
{
    WordLayout = 'TopItems.docx';
    RDLCLayout = 'TopItems.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Item; Item)
        {
            column(Description; Description)
            {

            }

            column(ValueSold; WebshopUtils.GetTotalSalesForItem(Item."No."))
            {

            }

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
        WebshopUtils: Codeunit WebshopUtilities;
}
