package hxmessageformat;

class SelectOrdinal
{
    public static function Format(expr:Dynamic, output:StringBuf, params:Map<String, Dynamic>, mf:MessageFormat, _:String):Void
    {
        var o:SelectExpr = cast expr;

        var key = o.key;
        var value = Utils.MapToString(key, params);

        var choices = o.choices;
        var choice:Node;

        if (null != params && params.exists(key))
        {
            var v = params.get(key);

            if (Std.is(v, String))
            {
                Utils.ParseFloat(v);
            }
            else if (!Std.is(v, Int)) // Int & Float
            {
                throw "Ordinal: Unsupported type for named key: " + Type.typeof(v);
            }

            choice = choices.get(mf.getNamedKey(v, true));
        }
        else
        {
            choice = choices.get("other");
        }
        return choice.format(output, mf, params, value);
    }
}
