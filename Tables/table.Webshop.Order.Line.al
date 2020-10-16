table 50101 "Webshop Order Line"
{
    Caption = 'Webshop Order Line';
    DataClassification = CustomerContent;
    LookupPageId = "Item List";
    DrillDownPageId = "Item List";


    fields
    {
        field(1; "Item No."; Code[20])
        {
            Editable = true;
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = "Item";
            trigger OnValidate()
            begin
                CalcPrice();
            end;
        }

        field(2; "Quantity"; Decimal)
        {
            InitValue = 1;
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalcPrice();
            end;
        }

        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."Unit Price" where("No." = field("Item No.")));
            trigger OnValidate()
            begin

                CalcPrice();
            end;
        }

        field(4; "Base unit of measure"; Code[10])
        {
            Caption = 'Unit code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }

        field(5; Price; Decimal)
        {
            Caption = 'Price';
            Editable = false;
        }
        field(6; "ext. warranty price"; Decimal)
        {
            Caption = 'ext. warranty price';
            Editable = false;
        }
        field(7; "Price with warranty"; Decimal)
        {
            Caption = 'Price with warranty';
            Editable = false;
        }
        field(8; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }


        field(9; "Webshop Order ID"; Integer)
        {
            Caption = 'Order No.';
            Editable = false;
            TableRelation = "Webshop Order Header table"."Webshop Order ID";
        }

        field(10; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(11; "Target Shipping Date"; Date)
        {
            Caption = 'Target shipping date';

            trigger OnValidate()
            var

            begin
                if (currEnumName <> '') or (webShopOrderLine."Target Shipping Date" <> 0D) then begin

                end else begin

                    currEnumName := GetEnumValueName(enumWarranty);
                    if currEnumName <> '' then begin
                        Message('Enum hase value, calculating new date . (this just for test)'); //tesztüzi (*＾▽＾)／
                        CalculateNewDate();
                        CalcPrice();
                    end;
                end;
            end;
        }

        field(12; "enumWarranty"; Enum enumWarranty)
        {
            InitValue = "<1Y>";
            Caption = 'Warranty';

            trigger OnValidate()
            begin

                if "Target Shipping Date" <> 0D then begin
                    Message('Target date hase value, calculating new date . (this just for test)'); //tesztüzi (*＾▽＾)／
                    CalculateNewDate();
                    CalcPrice();
                end;
                CalcPrice();
            end;
        }
        field(13; "Date Result"; Date)
        {
            Caption = 'Expiration';
            Editable = false;

        }
    }


    keys
    {
        key(PK; "Webshop Order ID", "Line No.")
        {

        }
    }
    var

        Initvalue: Enum enumWarranty;
        webShopOrder: Record "Webshop Order Header table";
        webShopOrderLine: Record "Webshop Order Line";
        currEnumName: Text;

    local procedure testEnumHasValue() //"enumWarranty"
    begin

    end;

    local procedure testTArgetDateHasValue() //"Reference for Date Calculation"
    begin

    end;

    local procedure GetEnumValueName(pSourceType: Enum "enumWarranty"): Text
    var
        Index1: Integer;
        ValueName1: Text;
    begin
        Index1 := pSourceType.Ordinals().IndexOf(pSourceType.AsInteger());
        if Index1 <> 0 then begin
            pSourceType.Names().Get(Index1, ValueName1);
        end;
        exit(ValueName1);

    end;
    /// <summary> 
    /// Description for CalculateNewDate.
    /// </summary>
    local procedure CalculateNewDate()
    var
        DateFormulaToUse: DateFormula;
        EnumText: Text[10];
        EnumIndex: Integer;
    begin

        /*
        //FIXME
        Eltörik, ha a dátum vagy az enumwarraty-nál nincs érték (korábbi adat felfrissítése esetén
        Számolja úgy a dátumot, ha valamelyik a kettő közül üres!
         - Ha azt enumwarraty hiányzik, akkor legyen automatikus nulla nap (tehát a két dátum megegyezik)
         - Ha a dátum üres (tehát enumot állítja be először a user, akkor maradjon üres (aka ne csináljon semmit ez a method)
         4 eset van - 4 elágázás ebben a methodban :
          a, nincs dátum és nincs enum -> ne csináljon semmit a method
          b, van dátum, de nincs enum -> a számolandó dátum egyezzen meg az eredeti dátummal
          c, nincs dátum, de van enum -> ne csináljon semmit a method
          d, van dátum és van enum -> az amit eddig csinált

        */

        // ez innentől a d, eset

        EnumIndex := "enumWarranty".AsInteger();
        "enumWarranty".Names().Get(EnumIndex, EnumText);

        if "Target Shipping Date" = 0D then begin
            "Date Result" := 0D;

            Message('No Target Shipping date added. Please add.')
        end else begin

            if (System.Evaluate(DateFormulaToUse, EnumText)) then begin
                "Date Result" := CalcDate(DateFormulaToUse, "Target Shipping Date");
            end;
        end;
    end;


    /// <summary> 
    /// Calculates the price of a given product. 
    /// If there is a warranty, the price will calculate it in a separate value.
    /// </summary>
    procedure CalcPrice()
    var
        EnumText: Text[5];
        EnumIndex: Integer;
        extendedWarPrice: Decimal;

    begin
        CalcFields("Unit Price");
        extendedWarPrice := "Unit Price" * 0.15;
        EnumIndex := "enumWarranty".AsInteger();
        //*1 issue
        if "enumWarranty".Names().Get(EnumIndex, EnumText) then begin
            "enumWarranty".Names().Get(EnumIndex, EnumText);

            if (EnumText = '<5Y>') then begin
                "ext. warranty price" := Quantity * extendedWarPrice;
            end
            else begin
                "ext. warranty price" := 0;
            end;
            Price := Quantity * "Unit Price";
            "Price with warranty" := Price + "ext. warranty price";

        end
        else begin
            Price := Quantity * "Unit Price";
        end;
        ;
    end;

    trigger OnInsert()
    begin
        CalcPrice();
        if webShopOrder.get("Webshop Order ID") then;
        validate("Target Shipping Date", CalcDate('<1W>', webShopOrder."Order Date"));
    end;
}
enum 50131 enumWarranty
{

    value(1; "<1Y>")
    {
        Caption = '1 Year';
    }
    value(2; "<5Y>")
    {
        Caption = '5 Year (extended)';
    }

}

//*1 issue (calcPrice):
/* Itt eltörik a report, ha a korábbi rendelésekhez nincs Warraty rendelve,
           amit utólag nem lehet megtenni, mert a shipping date is hiányzik, meg a warraty hossza is
           és mivel egymásból számolják, utólag nem lehet megadni.
           TODO FIX ME :
            - Mi van ha nincs dátum? Számolja az árat anélkül is! >>> done, pls test
            - Mi van ha nincs warraty hossz? Számolja az árat anélkül is! >>> done, pls test
            - Mi van ha nincs warraty ár? Készüljön el a report anélkül is (legyen ott nulla) >>> done, pls test
        */
