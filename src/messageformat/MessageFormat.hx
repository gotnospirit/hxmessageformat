package messageformat;

typedef Formatter = Dynamic -> StringBuf -> Map<String, String> -> Void;

class MessageFormat
{
    var root:Node;
    var formatters:Map<String, Formatter>;

	public function new(root:Node)
    {
        this.root = root;
        formatters = new Map<String, Formatter>();
    }

    public function set(key:String, fn:Formatter)
    {
        if (formatters.exists(key))
        {
            throw "ParserAlreadyRegistered";
        }
        formatters.set(key, fn);
        return this;
    }

    public function get(key:String)
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

    public function format(?params:Map<String, String>)
    {
        // root.debug();

        var buffer = new StringBuf();
        root.format(buffer, this, params);
        return buffer.toString();
    }
}
