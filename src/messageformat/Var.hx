package messageformat;

class Var
{
    public static function Format(expr:Dynamic, output:StringBuf, params:Map<String, Dynamic>, _:MessageFormat, _:String):Void
    {
        var value = Utils.MapToString(cast expr, params);

        if ("" != value)
        {
            output.add(value);
        }
    }

    public static function Parse(reader:StringReader):String
    {
        reader.whitespace();
        var fc_pos = reader.pos;
        var lc_pos = fc_pos;

        while (!reader.eof())
        {
            if (reader.isOpen())
            {
                throw Parser.Error("InvalidExpr", reader);
            }
            else if (reader.isComma() || reader.isClose())
            {
                return fc_pos != lc_pos ? reader.substr(fc_pos, lc_pos) : "";
            }
            else if (reader.isWhitespace())
            {
                reader.whitespace();
            }
            else if ((!reader.isUnderscore() && !reader.isAlphaNumeric()) || (reader.pos != lc_pos))
            {
                throw Parser.Error("InvalidFormat", reader);
            }
            else
            {
                reader.next();
                lc_pos = reader.pos;
            }
        }
        throw Parser.Error("UnbalancedBraces", reader);
    }
}
