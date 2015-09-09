package messageformat;

typedef ParseFunction = String -> Parser -> StringReader -> Dynamic;
typedef FormatFunction = Dynamic -> StringBuf -> Map<String, Dynamic> -> MessageFormat -> String -> Void;

class Parser
{
    var parsers:Map<String, Parser.ParseFunction>;
    var formatters:Map<String, Parser.FormatFunction>;
    var plural:ICURule.PluralFunction;

	public function new(culture:String = "en")
    {
        parsers = new Map<String, Parser.ParseFunction>();
        formatters = new Map<String, Parser.FormatFunction>();
        plural = ICURule.Get(culture);

        this
            .register("literal", null, Literal.Format)
            .register("var", null, Var.Format)
            .register("select", Select.Parse, Select.Format)
            .register("selectordinal", Select.Parse, SelectOrdinal.Format)
            .register("plural", SelectPlural.Parse, SelectPlural.Format);
    }

    public function register(key:String, p:ParseFunction, f:FormatFunction):Parser
    {
        if (parsers.exists(key))
        {
            throw "ParserAlreadyRegistered";
        }
        parsers.set(key, p);
        formatters.set(key, f);
        return this;
    }

    public function parse(str:String):MessageFormat
    {
        var root = new Node();
        var reader = new StringReader(str);

        while (!reader.eof())
        {
            var level:Int = _parse(reader, root);
            if (0 != level)
            {
                throw Parser.Error("UnbalancedBraces", reader);
            }
        }
        return new MessageFormat(root, formatters, plural);
    }

    public static inline function Error(msg:String, reader:StringReader):String
    {
        return "ParseError: `" + msg + "` at " + reader.pos;
    }

    function _parseExpression(reader:StringReader, parent:Node):Void
    {
        var name = Var.Parse(reader);
        if ("" == name)
        {
            throw Parser.Error("MissingVarName", reader);
        }
        else if (reader.isClose())
        {
            parent.add("var", name);
            return ;
        }

        // consume ,
        reader.next();

        var type = Var.Parse(reader);
        if (!parsers.exists(type))
        {
            throw Parser.Error("UnknownType: `" + type + "`", reader);
        }

        var fn = parsers.get(type);
        if (null == fn)
        {
            throw Parser.Error("UndefinedParseFunc: `" + type + "`", reader);
        }

        var child = fn(name, this, reader);
        if (!reader.hasNext() || !reader.isClose())
        {
            throw Parser.Error("UnbalancedBraces", reader);
        }
        parent.add(type, child);
    }

    @:allow(messageformat.Select.ReadChoice)
    function _parse(reader:StringReader, parent:Node):Int
    {
        var start = reader.pos;
        var level:Int = 0;
        var escaped = false;

        while (!reader.eof())
        {
            if (reader.isEscape())
            {
                escaped = true;
            }
            else if (reader.isOpen())
            {
                if (!escaped)
                {
                    ++level;

                    if (reader.pos > start)
                    {
                        parent.add("literal", Literal.Parse(reader, start));
                    }

                    // consume {
                    reader.next();

                    _parseExpression(reader, parent);

                    --level;

                    start = reader.pos + 1;
                }

                escaped = false;
            }
            else if (reader.isClose())
            {
                if (!escaped)
                {
                    --level;
                    break;
                }
                escaped = false;
            }
            else
            {
                escaped = false;
            }

            reader.next();
        }

        if (reader.pos > start)
        {
            parent.add("literal", Literal.Parse(reader, start));
        }
        return level;
    }
}
