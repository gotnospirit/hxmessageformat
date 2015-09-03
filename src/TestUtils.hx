package;

class TestUtils extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        var data:Map<String, Dynamic> = [
            "a" => "Hello",
            "b" => 42,
            "c" => 1.0,
            "d" => "1.0",
            "e" => true,
            "f" => 0.7 + 0.1,
            "g" => null
        ];

        this.add("unknown")
            .expect("", data);

        this.add("a")
            .expect("Hello", data);

        this.add("b")
            .expect("42", data);

        this.add("c")
            .expect("1", data);

        this.add("d")
            .expect("1.0", data);

        this.add("e")
            .throws("ToString: Unsupported type: TBool", data);

        this.add("f")
            .expect("0.8", data);

        this.add("g")
            .expect("", data);
    }

    override function doTest(t:TestSuite.Test, e:TestSuite.Expectation)
    {
        return messageformat.Utils.ToString(t.input, e.data);
    }
}