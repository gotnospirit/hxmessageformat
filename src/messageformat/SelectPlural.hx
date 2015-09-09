package messageformat;

class SelectPlural
{
    public static function Format(expr:Dynamic, output:StringBuf, params:Map<String, Dynamic>, mf:MessageFormat, pound:String):Void
    {
        var o:SelectPluralExpr = cast expr;

        var key = o.key;
        var offset = o.offset;

        var value = Utils.MapToString(key, params);

        var choices = o.choices;
        var choice:Node;

        if (null != params && params.exists(key))
        {
            var v = params.get(key);

            var is_string:Bool = Std.is(v, String);
            var is_float:Bool = Std.is(v, Int);
            var is_int:Bool = Std.is(v, Float);

            if (is_string)
            {
                Utils.ParseFloat(v);
            }
            else if (!is_int && !is_float)
            {
                throw "Ordinal: Unsupported type for named key: " + Type.typeof(v);
            }

            choice = choices.get("=" + v);

            if (null == choice)
            {
                if (is_int || is_float)
                {
                    if (0 != offset)
                    {
                        var offset_value = v - offset;

                        value = Utils.ToString(offset_value);
                        key = mf.getNamedKey(offset_value, false);
                    }
                    else
                    {
                        key = mf.getNamedKey(v, false);
                    }
                }
                else if (is_string)
                {
                    if (0 != offset)
                    {
                        var offset_value = Utils.ParseFloat(value) - offset;

                        value = Utils.ToString(offset_value);
                        key = mf.getNamedKey(offset_value, false);
                    }
                    else
                    {
                        key = mf.getNamedKey(value, false);
                    }
                }

                choice = choices.get(key);
            }
        }
        else
        {
            choice = choices.get("other");
        }
        return choice.format(output, mf, params, value);
    }

    public static function Parse(key:String, p:Parser, reader:StringReader):SelectPluralExpr
    {
        if (!reader.isComma())
        {
            throw Parser.Error("MalformedOption", reader);
        }

        var result = new SelectPluralExpr(key);
        var hasOtherChoice = false;

        // consume ,
        reader.next();

        while (!reader.eof())
        {
            var key = Select.ReadKey(reader);

            if (reader.isColon())
            {
                if ("offset" != key)
                {
                    throw Parser.Error("UnsupportedExtension: `" + key + "`", reader);
                }

                // consume :
                reader.next();

                result.offset = ReadOffset(reader);

                if (reader.isWhitespace())
                {
                    reader.whitespace();
                }

                key = Select.ReadKey(reader);
                if ("" == key)
                {
                    throw Parser.Error("MissingChoiceName", reader);
                }
            }

            if ("other" == key)
            {
                hasOtherChoice = true;
            }

            result.add(key, Select.ReadChoice(p, reader));

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

    public static function ReadOffset(reader:StringReader):Int
    {
        reader.whitespace();

        var pos:Int = reader.pos;
        var end:Int = pos;

        while (!reader.eof())
        {
            if (reader.isWhitespace() || reader.isOpen() || reader.isClose())
            {
                end = reader.pos;

                if (pos != end)
                {
                    var offset = reader.substr(pos, end);
                    if (-1 != offset.indexOf("."))
                    {
                        throw Parser.Error("BadCast", reader);
                    }

                    var result = Std.parseInt(offset);

                    if (null == result)
                    {
                        throw Parser.Error("BadCast", reader);
                    }
                    else if (result < 0)
                    {
                        throw Parser.Error("InvalidOffsetValue", reader);
                    }
                    return result;
                }
                throw Parser.Error("MissingOffsetValue", reader);
            }
            else
            {
                reader.next();
            }
        }
        throw Parser.Error("UnbalancedBraces", reader);
    }
}
