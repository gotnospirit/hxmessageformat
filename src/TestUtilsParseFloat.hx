package;

class TestUtilsParseFloat extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        this.add("0.8")
            .expect(0.8);

        this.add("8")
            .expect(8.0);

        this.add("abc")
            .throws("abc is NaN.");
    }

    override function test(t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
    {
        return messageformat.Utils.ParseFloat(t.input);
    }
}