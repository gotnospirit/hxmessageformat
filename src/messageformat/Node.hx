package messageformat;

class NodeExpr extends Node
{
    var type:String;
    var expr:Dynamic;

    public function new(type:String, expr:Dynamic)
    {
        super();

        this.type = type;
        this.expr = expr;
    }

    override public function format(output:StringBuf, mf:MessageFormat, params:Map<String, Dynamic>, pound:String):Void
    {
        var formatter = mf.get(type);

        if (null != formatter)
        {
            formatter(expr, output, params, mf, pound);
        }
    }
}

class Node
{
    var children:Array<Node>;

    public function new()
    {
        children = new Array<Node>();
    }

    public function add(type:String, expr:Dynamic):Void
    {
        children.push(new NodeExpr(type, expr));
    }

    public function format(output:StringBuf, mf:MessageFormat, params:Map<String, Dynamic>, pound:String):Void
    {
        for (child in children)
        {
            child.format(output, mf, params, pound);
        }
    }

    public function debug():Void
    {
        trace("nb children: " + children.length);

        for (i in 0...children.length)
        {
            trace(children[i]);
        }
    }
}
