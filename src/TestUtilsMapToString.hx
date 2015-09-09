package;

class TestUtilsMapToString extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        this.add("unknown")
            .expect("");

        var data:Map<String, Dynamic> = [
            "a" => "Hello",
            "b" => 42,
            "c" => 1.0,
            "d" => "1.0",
            // "e" => true,
            "f" => 0.7 + 0.1,
            "g" => null,
            "h" => 1000000000000,
            "i" => 0.00000001
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

        // this.add("e")
            // .throws("ToString: Unsupported type: TBool", data);

        this.add("f")
            .expect("0.8", data);

        this.add("g")
            .expect("", data);

        this.add("h")
            .expect("1000000000000", data);

        this.add("i")
            .expect("0.00000001", data);
    }

    override function test(t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
    {
        return messageformat.Utils.MapToString(t.input, e.data);
    }
}