package hxmessageformat;

class MessageFormat
{
    var root:Node;
    var formatters:Map<String, Parser.FormatFunction>;
    var plural:ICURule.PluralFunction;

	public function new(root:Node, formatters:Map<String, Parser.FormatFunction>, ?plural:ICURule.PluralFunction)
    {
        this.root = root;
        this.formatters = formatters;
        this.plural = plural;
    }

    // @TODO -> formatNode
    public function get(key:String):Parser.FormatFunction
    {
        if (!formatters.exists(key))
        {
            throw "UnknownType: `" + key + "`";
        }

        var result = formatters.get(key);
        if (null == result)
        {
            throw "UndefinedFormatFunc: `" + key + "`";
        }
        return result;
    }

    public function getNamedKey(n:Dynamic, ordinal:Bool):String
    {
        if (null == plural)
        {
            throw "UndefinedPluralFunc";
        }
        return plural(n, ordinal);
    }

    public function format(?params:Map<String, Dynamic>):String
    {
        var buffer = new StringBuf();
        root.format(buffer, this, params, "");
        return buffer.toString();
    }
}
