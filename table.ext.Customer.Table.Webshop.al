tableextension 50120 CustomerWebshopExtension extends Customer
{
    fields
    {
        field(1001; "Webshop ID"; Integer)
        {
            Caption = 'Webshop User ID ext';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Webshop ID" < 0 then begin
                    Message('Webshop ID cannot be negative number');
                    "Webshop ID" := 0;
                end;
            end;
        }
    }
}
/*Egészítsük ki a Vevő táblát egy új, integer típusú mezővel:
 Webshop azonosító. A mező legyen szerkeszthető, negatív számot ne lehessen megadni benne, 
 és tegyük ki a Vevőkartonra az Általános fülre.  */
