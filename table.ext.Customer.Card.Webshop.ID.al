pageextension 50120 CustomerWebshopExtensionCard extends "Customer Card"
{
    layout
    {

        addafter(Blocked)
        {
            field("Webshop  ID"; "Webshop ID")
            {
                Caption = 'Webshop ID';
                ApplicationArea = All;
            }
        }
    }
}