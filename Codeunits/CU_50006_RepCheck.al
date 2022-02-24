codeunit 50006 NumbertoText
{
    trigger OnRun();
    begin
    end;

    var
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'MILLION';
        Text16563: Label 'BILLION';
        Text16564: Label 'LAKH';
        Text16565: Label 'CRORE';
        // Text16566: Label 'ZERO PAISA ONLY';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        com: Text[1];
        value1: Integer;
        value2: Integer;
        value3: Decimal;
        value4: Integer;
        value5: Integer;
        valueword1: Text[10];
        valueword2: Text[10];
        valueword3: Text[10];
        valueword4: Text[20];
        valueword5: Text[200];
        word1: Text[60];
        word2: Text[100];
        word3: Text[60];
        word5: Text[30];
        wordarray: array[50] of Text[10];
        arrayval: array[50] of Text[10];
        a: Integer;
        VALLENT: Integer;
        valent: Integer;
        i: Integer;
        deci: Text[3];

    procedure FormatNoText(var NoText: array[2] of Text[200]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No div (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No div POWER(1000, Exponent - 1);
                    Hundreds := Ones div 100;
                end;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode <> '' then begin
            Currency.GET(CurrencyCode);
            //AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Numeric Description");
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) mod 100) div 10;
        OnesDec := (No * 100) mod 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526); //b2bjk


        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + '' + ' ONLY')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'PAISA ONLY');

    end;

    local procedure AddToNoText(var NoText: array[2] of Text[200]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := true;

        while STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ARRAYLEN(NoText) then
                ERROR(Text16529, AddText);
        end;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        // ExponentText[3] := Text16562; // b2bjk
        // ExponentText[4] := Text16563; // b2bjk
        ExponentText[3] := Text16564;
        ExponentText[4] := Text16565;
    end;

    procedure figure(fig: Decimal; Currency: Text[30]; CurrencyUnit: Text[30]) figureinword: Text[200];
    begin
        figureinword := '';
        word1 := '';
        word2 := '';
        word3 := '';
        word5 := '';
        valueword5 := '';
        valueword4 := '';
        valueword3 := '';
        valueword2 := '';
        valueword1 := '';

        if ABS(fig) > 0 then begin
            wordarray[1] := 'ONE';
            wordarray[2] := 'TWO';
            wordarray[3] := 'THREE';
            wordarray[4] := 'FOUR';
            wordarray[5] := 'FIVE';
            wordarray[6] := 'SIX';
            wordarray[7] := 'SEVEN';
            wordarray[8] := 'EIGHT';
            wordarray[9] := 'NINE';
            wordarray[10] := 'TEN';
            wordarray[11] := 'ELEVEN';
            wordarray[12] := 'TWELVE';
            wordarray[13] := 'THIRTEEN';
            wordarray[14] := 'FOURTEEN';
            wordarray[15] := 'FIFTEEN';
            wordarray[16] := 'SIXTEEN';
            wordarray[17] := 'SEVENTEEN';
            wordarray[18] := 'EIGHTEEN';
            wordarray[19] := 'NINETEEN';
            wordarray[20] := 'TWENTY';
            arrayval[1] := 'TEN';
            arrayval[2] := 'TWENTY';
            arrayval[3] := 'THIRTY';
            arrayval[4] := 'FORTY';
            arrayval[5] := 'FIFTY';
            arrayval[6] := 'SIXTY';
            arrayval[7] := 'SEVENTY';
            arrayval[8] := 'EIGHTY';
            arrayval[9] := 'NINETY';
            arrayval[10] := 'HUNDRED';
            arrayval[11] := 'THOUSAND';
            arrayval[12] := 'MILLION';
            arrayval[13] := 'BILLION';
            arrayval[14] := 'TRILLION';
            valueword4 := FORMAT(ABS(ROUND(fig, 0.01, '>')));
            valueword4 := DELCHR(valueword4, '=', ',');
            value4 := STRPOS(valueword4, '.');
            if value4 > 0 then begin
                VALLENT := value4 - 1;
                deci := COPYSTR(valueword4, (STRPOS(valueword4, '.') + 1));
                if STRLEN(deci) < 2 then deci := deci + '0'
            end
            else
                VALLENT := STRLEN(valueword4);
            if VALLENT > 15 then
                ERROR('VALUE IS TOO BIG TO CONVERT');
            value5 := VALLENT mod 3;
            if value5 > 0 then begin                                             // unit and tens conversion begin
                valueword1 := COPYSTR(valueword4, 1, value5);
                EVALUATE(value3, valueword1);
                if (value3 > 0) and (value3 <= 20) then
                    word1 := wordarray[value3]
                else begin
                    valueword2 := COPYSTR(valueword1, 1, 1);
                    valueword3 := COPYSTR(valueword1, 2, 1);
                    EVALUATE(value3, valueword2);
                    word1 := arrayval[value3];
                    EVALUATE(value3, valueword3);
                    if value3 > 0 then
                        word1 := word1 + ' ' + wordarray[value3];
                end;
                if (VALLENT > 3) and (VALLENT < 7) then
                    word1 := word1 + ' ' + arrayval[11];
                if (VALLENT > 6) and (VALLENT < 10) then
                    word1 := word1 + ' ' + arrayval[12];
                if (VALLENT > 9) and (VALLENT < 13) then
                    word1 := word1 + ' ' + arrayval[13];
                if (VALLENT > 12) and (VALLENT < 16) then
                    word1 := word1 + ' ' + arrayval[14];
            end;

            // Figure normal conversion begin by Hassan Sharafadeen
            if VALLENT > 2 then begin
                a := value5 + 1;
                repeat
                    valueword2 := COPYSTR(valueword4, a, 3);
                    EVALUATE(value4, valueword2);
                    if value4 = 0 then begin
                        word2 := '';
                        if (VALLENT > 6) and (VALLENT < 10) then
                            word2 := word2 + ' ' + arrayval[11];
                        if (VALLENT > 9) and (VALLENT < 13) then
                            word2 := word2 + ' ' + arrayval[12];
                        if (VALLENT > 12) and (VALLENT < 16) then
                            word2 := word2 + ' ' + arrayval[13];
                        a := a + 3;
                    end
                    else begin
                        valueword1 := COPYSTR(valueword2, 1, 1);
                        EVALUATE(value3, valueword1);
                        if value3 > 0 then begin
                            word2 := wordarray[value3];
                            word2 := word2 + ' ' + arrayval[10];
                        end
                        else
                            word2 := '';
                        valueword1 := COPYSTR(valueword2, 2);
                        EVALUATE(value3, valueword1);
                        if value3 > 0 then begin
                            if (value3 > 0) and (value3 <= 20) then
                                if word2 <> '' then
                                    word2 := word2 + ' ' + 'AND' + ' ' + wordarray[value3]
                                else
                                    word2 := wordarray[value3]
                            else
                                if value3 > 20 then begin
                                    valueword2 := COPYSTR(valueword1, 1, 1);
                                    valueword3 := COPYSTR(valueword1, 2, 1);
                                    EVALUATE(value3, valueword2);
                                    if word2 <> '' then
                                        word2 := word2 + ' ' + 'AND' + ' ' + arrayval[value3]
                                    else
                                        word2 := arrayval[value3];
                                    EVALUATE(value3, valueword3);
                                    if value3 > 0 then
                                        word2 := word2 + ' ' + wordarray[value3];
                                end;
                        end;
                        a := a + 3;
                        if a < VALLENT then begin
                            if i > 0 then begin
                                case i of
                                    3:
                                        begin
                                            if (VALLENT > 8) and (VALLENT < 12) then
                                                word2 := word2 + ' ' + arrayval[11];
                                            if (VALLENT > 11) and (VALLENT < 15) then
                                                word2 := word2 + ' ' + arrayval[12];
                                            if VALLENT = 15 then
                                                word2 := word2 + ' ' + arrayval[13];
                                        end;
                                    6:
                                        begin
                                            if (VALLENT > 11) and (VALLENT < 15) then
                                                word2 := word2 + ' ' + arrayval[11];
                                            if VALLENT = 15 then
                                                word2 := word2 + ' ' + arrayval[12];
                                        end;
                                    9:
                                        if VALLENT = 15 then
                                            word2 := word2 + ' ' + arrayval[11];
                                end;
                            end
                            else begin
                                case a of
                                    4:
                                        begin
                                            if VALLENT = 6 then
                                                word2 := word2 + ' ' + arrayval[11];
                                            if VALLENT = 9 then
                                                word2 := word2 + ' ' + arrayval[12];
                                            if VALLENT = 12 then
                                                word2 := word2 + ' ' + arrayval[13];
                                            if VALLENT = 15 then
                                                word2 := word2 + ' ' + arrayval[14];
                                        end;
                                    5, 6:
                                        begin
                                            if (VALLENT > 6) and (VALLENT < 9) then
                                                word2 := word2 + ' ' + arrayval[11];
                                            if (VALLENT > 9) and (VALLENT < 12) then
                                                word2 := word2 + ' ' + arrayval[12];
                                            if (VALLENT > 12) and (VALLENT < 15) then
                                                word2 := word2 + ' ' + arrayval[13];
                                        end;
                                end;
                            end;
                        end;
                        valueword5 := valueword5 + ' ' + word2;
                        i := i + 3;
                    end;
                until a > VALLENT;
            end;
            figureinword := word1 + ' ' + valueword5 + ' ' + Currency;
            if deci <> '' then                 //Decimal conversion begin
            begin
                EVALUATE(value3, deci);
                if value3 <= 20 then
                    word3 := wordarray[value3]
                else begin
                    valueword2 := COPYSTR(deci, 1, 1);
                    valueword3 := COPYSTR(deci, 2, 1);
                    EVALUATE(value3, valueword2);
                    word3 := arrayval[value3];
                    EVALUATE(value3, valueword3);
                    if value3 > 0 then
                        word3 := word3 + ' ' + wordarray[value3];
                end;
                word5 := word3 + ' ' + CurrencyUnit;           // Attach Decimal Unit of counting
            end
            else
                word5 := ' ';
            figureinword := figureinword + ' ' + word5;
        end
        else
            figureinword := '';
    end;

    PROCEDURE CheckIsAlphabet(RegistrationNo: Text[100]; Position: Integer; LineNum: Integer; FieldName: Text);
    BEGIN
        IF NOT ((COPYSTR(RegistrationNo, Position, 1) IN ['A' .. 'Z']) OR
               (COPYSTR(RegistrationNo, Position, 1) IN ['a' .. 'z'])) THEN
            ERROR(OnlyAlphabetErr, Position, LineNum, FieldName);
    END;

    PROCEDURE CheckIsNumeric(RegistrationNo: Text[100]; Position: Integer; LineNum: Integer; FieldName: Text);
    BEGIN
        IF NOT (COPYSTR(RegistrationNo, Position, 1) IN ['0' .. '9']) THEN
            ERROR(OnlyNumericErr, Position, LineNum, FieldName);
    END;

    PROCEDURE CheckIsAlphaNumeric(RegistrationNo: Text[100]; Position: Integer; LineNum: Integer; FieldName: Text);
    BEGIN
        IF NOT ((COPYSTR(RegistrationNo, Position, 1) IN ['0' .. '9']) OR (COPYSTR(RegistrationNo, Position, 1) IN ['A' .. 'Z']) or
                  (COPYSTR(RegistrationNo, Position, 1) IN ['a' .. 'z'])) THEN
            ERROR(OnlyAlphaNumericErr, Position, LineNum, FieldName);
    END;

    var
        OnlyAlphabetErr: Label 'Only Alphabet is allowed in the position %1 Line No. %2 Field Name %3.';
        OnlyNumericErr: Label 'Only Numeric is allowed in the position %1 Line No. %2 Field Name %3.';
        OnlyAlphaNumericErr: Label 'Only AlphaNumeric is allowed in the position %1 Line No. %2 Field Name %3.';


}

