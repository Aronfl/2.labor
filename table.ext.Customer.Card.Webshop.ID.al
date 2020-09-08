pageextension 50120 CustomerWebshopExtensionCard extends "Customer Card"
{
    layout
    {

        addafter(Blocked)
        {
            field("Webshop User Id"; WebshopUserId)
            {
                Caption = 'Webshop ID';
                ApplicationArea = All;
            }
        }
    }
}