tableextension 50120 CustomerWebshopExtension extends Customer
{
    fields
    {
        field(1001; WebshopUserId; Integer)
        {
            Caption = 'Webshop User ID ext';
            DataClassification = CustomerContent;
            /// <summary> 
            /// Validate if webshop Id is not negative, if it is, it is set to 0
            /// </summary>
            trigger OnValidate()
            begin
                if WebshopUserId < 0 then begin
                    Message('Webshop ID cannot be negative number');
                    WebshopUserId := 0;
                end;
            end;
        }
    }
}
/*Egészítsük ki a Vevő táblát egy új, integer típusú mezővel:
 Webshop azonosító. A mező legyen szerkeszthető, negatív számot ne lehessen megadni benne, 
 és tegyük ki a Vevőkartonra az Általános fülre.  */
