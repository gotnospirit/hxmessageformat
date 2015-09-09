package;

import messageformat.ICURule;

class TestICUFinvtw extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        this.add(true)
            .expect({ f: 0, i: 0, n: 0, v: 0, t: 0, w: 0});

        this.add("abc")
            .expect({ f: 0, i: 0, n: 0, v: 0, t: 0, w: 0});

        this.add("ab.c")
            .expect({ f: 0, i: 0, n: 0, v: 0, t: 0, w: 0});

        this.add(-1)
            .expect({ f: 0, i: -1, n: 1.0, v: 0, t: 0, w: 0});

        this.add(1)
            .expect({ f: 0, i: 1, n: 1.0, v: 0, t: 0, w: 0});

        this.add("1.0")
            .expect({ f: 0, i: 1, n: 1.0, v: 1, t: 0, w: 0});

        this.add("1.00")
            .expect({ f: 0, i: 1, n: 1.0, v: 2, t: 0, w: 0});

        this.add(10.20)
            .expect({ f: 2, i: 10, n: 10.2, v: 1, t: 2, w: 1});

        this.add("10.20")
            .expect({ f: 20, i: 10, n: 10.2, v: 2, t: 2, w: 1});

        this.add(-123)
            .expect({ f: 0, i: -123, n: 123.0, v: 0, t: 0, w: 0});

        this.add(-123.990)
            .expect({ f: 99, i: -123, n: 123.99, v: 2, t: 99, w: 2});

        this.add("-123.990")
            .expect({ f: 990, i: -123, n: 123.99, v: 3, t: 99, w: 2});

        this.add(0.7 + 0.1)
            .expect({ f: 8, i: 0, n: 0.8, v: 1, t: 8, w: 1});

        this.add(123456.305)
            .expect({ f: 305, i: 123456, n: 123456.305, v: 3, t: 305, w: 3});

        this.add(123456.3057892)
            .expect({ f: 3057892, i: 123456, n: 123456.3057892, v: 7, t: 3057892, w: 7});

        this.add(123456.3057000)
            .expect({ f: 3057, i: 123456, n: 123456.3057, v: 4, t: 3057, w: 4});

        this.add("123456.3057000")
            .expect({ f: 3057000, i: 123456, n: 123456.3057, v: 7, t: 3057, w: 4});

        this.add(1000000000000)
            .expect({ f: 0, i: 1000000000000, n: 1000000000000.0, v: 0, t: 0, w: 0});

        this.add(0.33333)
            .expect({ f: 33333, i: 0, n: 0.33333, v: 5, t: 33333, w: 5});

        this.add(0.99999)
            .expect({ f: 99999, i: 0, n: 0.99999, v: 5, t: 99999, w: 5});

        // les floats ça marche jamais comme il faut :(
        this.add(100000000000.2)
            .expect({ f: 2, i: 100000000000, n: 100000000000.2, v: 1, t: 2, w: 1});
    }

    override function test(t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
    {
        return ICURule.Finvtw(t.input);
    }

    override function compare(result:Dynamic, expected:Dynamic)
    {
        return result.f == expected.f
            && result.i == expected.i
            && result.n == expected.n
            && result.v == expected.v
            && result.t == expected.t
            && result.w == expected.w;
    }
}