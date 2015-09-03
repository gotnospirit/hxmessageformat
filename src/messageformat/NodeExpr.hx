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

    override public function format(output:StringBuf, mf:MessageFormat, ?params:Map<String, Dynamic>)
    {
        var formatter = mf.get(type);

        if (null != formatter)
        {
            formatter(expr, output, params);
        }
    }
}
