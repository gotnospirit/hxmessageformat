package messageformat;

class SelectExpr
{
    public var key(default, null):String;
    public var choices(default, null):Map<String, Node>;

    public function new(key:String)
    {
        this.key = key;
        this.choices = new Map<String, Node>();
    }

    public function add(key:String, value:Node):Void
    {
        this.choices.set(key, value);
    }
}
