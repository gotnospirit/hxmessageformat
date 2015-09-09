package hxmessageformat;

class Select
{
    public static function Format(expr:Dynamic, output:StringBuf, params:Map<String, Dynamic>, mf:MessageFormat, _:String):Void
    {
        var o:SelectExpr = cast expr;

        var value = Utils.MapToString(o.key, params);
        var choices = o.choices;

        var choice = !choices.exists(value)
            ? choices.get("other")
            : choices.get(value);
        return choice.format(output, mf, params, value);
    }

    public static function Parse(key:String, p:Parser, reader:StringReader):SelectExpr
    {
        if (!reader.isComma())
        {
            throw Parser.Error("MalformedOption", reader);
        }

        var result = new SelectExpr(key);
        var hasOtherChoice = false;

        // consume ,
        reader.next();

        while (!reader.eof())
        {
            var key = ReadKey(reader);

            if (reader.isColon())
            {
                throw Parser.Error("UnexpectedExtension", reader);
            }
            else if ("other" == key)
            {
                hasOtherChoice = true;
            }

            result.add(key, ReadChoice(p, reader));

            if (reader.isClose())
            {
                break;
            }
        }

        if (!hasOtherChoice)
        {
            throw Parser.Error("MissingMandatoryChoice", reader);
        }
        return result;
    }

    public static function ReadKey(reader:StringReader):String
    {
        reader.whitespace();
        var fc_pos = reader.pos;
        var lc_pos = fc_pos;

        while (!reader.eof())
        {
            if (reader.isWhitespace())
            {
                reader.whitespace();
                return fc_pos != lc_pos ? reader.substr(fc_pos, lc_pos) : "";
            }
            else if (reader.isColon() || reader.isComma() || reader.isClose() || reader.isOpen())
            {
                if (fc_pos != lc_pos)
                {
                    return reader.substr(fc_pos, lc_pos);
                }
                throw Parser.Error("MissingChoiceName", reader);
            }
            else
            {
                reader.next();
                lc_pos = reader.pos;
            }
        }
        throw Parser.Error("UnbalancedBraces", reader);
    }

    public static function ReadChoice(p:Parser, reader:StringReader):Node
    {
        if (!reader.isOpen())
        {
            throw Parser.Error("MissingChoiceContent", reader);
        }

        var result = new Node();

        // consume {
        reader.next();

        p._parse(reader, result);

        // consume }
        reader.next();

        if (reader.isWhitespace())
        {
            reader.whitespace();
        }
        return result;
    }
}
