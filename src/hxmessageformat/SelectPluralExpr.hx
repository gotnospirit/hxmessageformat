package hxmessageformat;

class SelectPluralExpr extends SelectExpr
{
    public var offset:Int;

    public function new(key:String)
    {
        super(key);
        this.offset = 0;
    }
}
