package;

class Test
{
    public var input(default, null):String;
    public var expects(default, null):Array<Expectation>;

    public function new(input:String)
    {
        this.input = input;
        this.expects = new Array<Expectation>();
    }

    public function expect(output:String, ?data:Map<String, String>)
    {
        expects.push(new Expectation(output, data));
        return this;
    }
}

class Expectation
{
    public var output(default, null):String;
    public var data(default, null):Map<String, String>;

    public function new(output:String, ?data:Map<String, String>)
    {
        this.output = output;
        this.data = data;
    }
}

class TestSuite
{
    var t:Array<Test>;

    public function new()
    {
        t = new Array<Test>();
    }

    public function add(input:String)
    {
        var result:Test = new Test(input);
        t.push(result);
        return result;
    }

    public function iterator()
    {
        return t.iterator();
    }
}
