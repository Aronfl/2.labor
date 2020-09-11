pageextension 50120 CustomerWebshopExtensionCard extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Webshop User Id"; CustomercardWebshopUserId)
            {
                Caption = 'Webshop ID';
                ApplicationArea = All;
            }
        }
    }
}