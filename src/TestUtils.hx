package;

class TestUtils extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        var data:Map<String, Dynamic> = [
            "a" => "Hello"
        ];

        this.createMapToStringTest("unknown")
            .expect("", null);

        this.createMapToStringTest("unknown")
            .expect("", data);

        this.createMapToStringTest("a")
            .expect("Hello", data);

        this.createToStringTest("Hello")
            .expect("Hello");

        this.createToStringTest(42)
            .expect("42");

        this.createToStringTest(1.0)
            .expect("1");

        this.createToStringTest("1.0")
            .expect("1.0");

        this.createToStringTest(true)
            .throws("ToString: Unsupported type: TBool");

        this.createToStringTest(0.7 + 0.1)
            .expect("0.8");

        this.createToStringTest(null)
            .expect("");

        this.createToStringTest(1000000000000)
            .expect("1000000000000");

        this.createToStringTest(0.00000001)
            .expect("0.00000001");

        this.createParseFloatTest("0.8")
            .expect(0.8);

        this.createParseFloatTest("8")
            .expect(8.0);

        this.createParseFloatTest("abc")
            .throws("abc is NaN.");

        this.createParseIntTest("0.8")
            .expect(0);

        this.createParseIntTest("8")
            .expect(8);

        this.createParseIntTest("abc")
            .throws("abc is NaN.");
    }

    function createParseFloatTest(input:String):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return messageformat.Utils.ParseFloat(t.input);
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result == expected;
            });
    }

    function createParseIntTest(input:String):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return messageformat.Utils.ParseInt(t.input);
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result == expected;
            });
    }

    function createMapToStringTest(input:String):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return messageformat.Utils.MapToString(t.input, e.data);
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result == expected;
            });
    }

    function createToStringTest(input:Dynamic):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return messageformat.Utils.ToString(t.input);
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result == expected;
            });
    }
}