package messageformat;

class Node
{
    var children:Array<Node>;

    public function new()
    {
        children = new Array<Node>();
    }

    public function add(type:String, expr:Dynamic)
    {
        children.push(new NodeExpr(type, expr));
    }

    public function format(output:StringBuf, mf:MessageFormat, ?params:Map<String, String>)
    {
        for (child in children)
        {
            child.format(output, mf, params);
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