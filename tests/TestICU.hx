package;

import hxmessageformat.ICURule;

class TestICU extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        this.createFinvtwTest(true)
            .expect({ f: 0, i: 0, n: 0, v: 0, t: 0, w: 0});

        this.createFinvtwTest("abc")
            .expect({ f: 0, i: 0, n: 0, v: 0, t: 0, w: 0});

        this.createFinvtwTest("ab.c")
            .expect({ f: 0, i: 0, n: 0, v: 0, t: 0, w: 0});

        this.createFinvtwTest(-1)
            .expect({ f: 0, i: -1, n: 1.0, v: 0, t: 0, w: 0});

        this.createFinvtwTest(1)
            .expect({ f: 0, i: 1, n: 1.0, v: 0, t: 0, w: 0});

        this.createFinvtwTest("1.0")
            .expect({ f: 0, i: 1, n: 1.0, v: 1, t: 0, w: 0});

        this.createFinvtwTest("1.00")
            .expect({ f: 0, i: 1, n: 1.0, v: 2, t: 0, w: 0});

        this.createFinvtwTest(10.20)
            .expect({ f: 2, i: 10, n: 10.2, v: 1, t: 2, w: 1});

        this.createFinvtwTest("10.20")
            .expect({ f: 20, i: 10, n: 10.2, v: 2, t: 2, w: 1});

        this.createFinvtwTest(-123)
            .expect({ f: 0, i: -123, n: 123.0, v: 0, t: 0, w: 0});

        this.createFinvtwTest(-123.990)
            .expect({ f: 99, i: -123, n: 123.99, v: 2, t: 99, w: 2});

        this.createFinvtwTest("-123.990")
            .expect({ f: 990, i: -123, n: 123.99, v: 3, t: 99, w: 2});

        this.createFinvtwTest(0.7 + 0.1)
            .expect({ f: 8, i: 0, n: 0.8, v: 1, t: 8, w: 1});

        this.createFinvtwTest(123456.305)
            .expect({ f: 305, i: 123456, n: 123456.305, v: 3, t: 305, w: 3});

        this.createFinvtwTest(123456.3057892)
            .expect({ f: 3057892, i: 123456, n: 123456.3057892, v: 7, t: 3057892, w: 7});

        this.createFinvtwTest(123456.3057000)
            .expect({ f: 3057, i: 123456, n: 123456.3057, v: 4, t: 3057, w: 4});

        this.createFinvtwTest("123456.3057000")
            .expect({ f: 3057000, i: 123456, n: 123456.3057, v: 7, t: 3057, w: 4});

        this.createFinvtwTest(1000000000000)
            .expect({ f: 0, i: 1000000000000, n: 1000000000000.0, v: 0, t: 0, w: 0});

        this.createFinvtwTest(0.33333)
            .expect({ f: 33333, i: 0, n: 0.33333, v: 5, t: 33333, w: 5});

        this.createFinvtwTest(0.99999)
            .expect({ f: 99999, i: 0, n: 0.99999, v: 5, t: 99999, w: 5});

        // les floats ?a marche jamais comme il faut :(
        this.createFinvtwTest(100000000000.2)
            .expect({ f: 2, i: 100000000000, n: 100000000000.2, v: 1, t: 2, w: 1});

        this.createNamedKeyTest("en")
            .expect("one", [ "value" => 1, "ordinal" => true ])
            .expect("one", [ "value" => 21, "ordinal" => true ])
            .expect("one", [ "value" => 31, "ordinal" => true ])
            .expect("one", [ "value" => 41, "ordinal" => true ])
            .expect("one", [ "value" => 51, "ordinal" => true ])
            .expect("one", [ "value" => 61, "ordinal" => true ])
            .expect("one", [ "value" => 71, "ordinal" => true ])
            .expect("one", [ "value" => 81, "ordinal" => true ])
            .expect("one", [ "value" => 91, "ordinal" => true ])
            .expect("one", [ "value" => 101, "ordinal" => true ])
            .expect("one", [ "value" => 1001, "ordinal" => true ])
            .expect("one", [ "value" => 1, "ordinal" => false ])
            .expect("two", [ "value" => 2, "ordinal" => true ])
            .expect("two", [ "value" => 22, "ordinal" => true ])
            .expect("two", [ "value" => 32, "ordinal" => true ])
            .expect("two", [ "value" => 42, "ordinal" => true ])
            .expect("two", [ "value" => 52, "ordinal" => true ])
            .expect("two", [ "value" => 62, "ordinal" => true ])
            .expect("two", [ "value" => 72, "ordinal" => true ])
            .expect("two", [ "value" => 82, "ordinal" => true ])
            .expect("two", [ "value" => 92, "ordinal" => true ])
            .expect("two", [ "value" => 102, "ordinal" => true ])
            .expect("two", [ "value" => 1002, "ordinal" => true ])
            .expect("few", [ "value" => 3, "ordinal" => true ])
            .expect("few", [ "value" => 23, "ordinal" => true ])
            .expect("few", [ "value" => 33, "ordinal" => true ])
            .expect("few", [ "value" => 43, "ordinal" => true ])
            .expect("few", [ "value" => 53, "ordinal" => true ])
            .expect("few", [ "value" => 63, "ordinal" => true ])
            .expect("few", [ "value" => 73, "ordinal" => true ])
            .expect("few", [ "value" => 83, "ordinal" => true ])
            .expect("few", [ "value" => 93, "ordinal" => true ])
            .expect("few", [ "value" => 103, "ordinal" => true ])
            .expect("few", [ "value" => 1003, "ordinal" => true ])
            .expect("other", [ "value" => 0, "ordinal" => true ])
            .expect("other", [ "value" => 4, "ordinal" => true ])
            .expect("other", [ "value" => 18, "ordinal" => true ])
            .expect("other", [ "value" => 100, "ordinal" => true ])
            .expect("other", [ "value" => 1000, "ordinal" => true ])
            .expect("other", [ "value" => 10000, "ordinal" => true ])
            .expect("other", [ "value" => 100000, "ordinal" => true ])
            .expect("other", [ "value" => 1000000, "ordinal" => true ])
            .expect("other", [ "value" => 0, "ordinal" => false ])
            .expect("other", [ "value" => 2, "ordinal" => false ])
            .expect("other", [ "value" => 16, "ordinal" => false ])
            .expect("other", [ "value" => 100, "ordinal" => false ])
            .expect("other", [ "value" => 1000, "ordinal" => false ])
            .expect("other", [ "value" => 10000, "ordinal" => false ])
            .expect("other", [ "value" => 100000, "ordinal" => false ])
            .expect("other", [ "value" => 1000000, "ordinal" => false ])
            .expect("other", [ "value" => "0.0", "ordinal" => false ])
            .expect("other", [ "value" => "1.5", "ordinal" => false ])
            .expect("other", [ "value" => "10.0", "ordinal" => false ])
            .expect("other", [ "value" => "100.0", "ordinal" => false ])
            .expect("other", [ "value" => "1000.0", "ordinal" => false ])
            .expect("other", [ "value" => "10000.0", "ordinal" => false ])
            .expect("other", [ "value" => "100000.0", "ordinal" => false ])
            .expect("other", [ "value" => "1000000.0", "ordinal" => false ]);

        this.createNamedKeyTest("fr")
            .expect("one", [ "value" => 1, "ordinal" => true ])
            .expect("one", [ "value" => 0, "ordinal" => false ])
            .expect("one", [ "value" => 1, "ordinal" => false ])
            .expect("one", [ "value" => "0.0", "ordinal" => false ])
            .expect("one", [ "value" => "1.5", "ordinal" => false ])
            .expect("other", [ "value" => 0, "ordinal" => true ])
            .expect("other", [ "value" => 2, "ordinal" => true ])
            .expect("other", [ "value" => 16, "ordinal" => true ])
            .expect("other", [ "value" => 100, "ordinal" => true ])
            .expect("other", [ "value" => 1000, "ordinal" => true ])
            .expect("other", [ "value" => 10000, "ordinal" => true ])
            .expect("other", [ "value" => 100000, "ordinal" => true ])
            .expect("other", [ "value" => 1000000, "ordinal" => true ])
            .expect("other", [ "value" => 2, "ordinal" => false ])
            .expect("other", [ "value" => 17, "ordinal" => false ])
            .expect("other", [ "value" => 100, "ordinal" => false ])
            .expect("other", [ "value" => 1000, "ordinal" => false ])
            .expect("other", [ "value" => 10000, "ordinal" => false ])
            .expect("other", [ "value" => 100000, "ordinal" => false ])
            .expect("other", [ "value" => 1000000, "ordinal" => false ])
            .expect("other", [ "value" => "2.0", "ordinal" => false ])
            .expect("other", [ "value" => "3.5", "ordinal" => false ])
            .expect("other", [ "value" => "10.0", "ordinal" => false ])
            .expect("other", [ "value" => "100.0", "ordinal" => false ])
            .expect("other", [ "value" => "1000.0", "ordinal" => false ])
            .expect("other", [ "value" => "10000.0", "ordinal" => false ])
            .expect("other", [ "value" => "100000.0", "ordinal" => false ])
            .expect("other", [ "value" => "1000000.0", "ordinal" => false ]);
    }

    function createFinvtwTest(input:Dynamic):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return ICURule.Finvtw(t.input);
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result.f == expected.f
                    && result.i == expected.i
                    && result.n == expected.n
                    && result.v == expected.v
                    && result.t == expected.t
                    && result.w == expected.w;
            });
    }

    function createNamedKeyTest(input:String):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return ICURule.Get(t.input)(e.data.get("value"), e.data.get("ordinal"));
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result == expected;
            });
    }
}