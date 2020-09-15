tableextension 50120 CustomerWebshopExtension extends Customer
{
    fields
    {
        field(1001; CustomercardWebshopUserId; Integer)
        {
            Caption = 'Webshop User ID ext';
            DataClassification = CustomerContent;
            /// <summary> 
            /// Validate if webshop Id is not negative, if it is, it is set to 0
            /// </summary>
            trigger OnValidate()
            begin
                if CustomercardWebshopUserId < 0 then begin
                    Message('Webshop ID cannot be negative number');
                    CustomercardWebshopUserId := 0;
                end;
            end;
        }
    }
}
