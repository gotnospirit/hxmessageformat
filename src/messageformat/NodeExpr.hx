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

    override public function format(output:StringBuf, mf:MessageFormat, ?params:Map<String, String>)
    {
        var formatter = mf.get(type);

        formatter(expr, output, params);
    }

// func (x *node) format(ptr_output *bytes.Buffer, data *map[string]interface{}, ptr_mf *MessageFormat, pound string) error {
	// for _, child := range x.children {
		// ctype := child.ctype

		// fn, err := ptr_mf.getFormatter(ctype)
		// if nil != err {
			// return err
		// }

		// err = fn(child.expr, ptr_output, data, ptr_mf, pound)
		// if nil != err {
			// return err
		// }
	// }
	// return nil
// }
}
