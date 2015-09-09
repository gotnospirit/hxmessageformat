package;

#if neko
import neko.Lib;
#elseif cpp
import cpp.Lib;
#end

typedef TestFunction = Test -> Expectation -> Dynamic;
typedef CompareFunction = Dynamic -> Dynamic -> Bool;

class Test
{
    public var input(default, null):Dynamic;
    public var expects(default, null):Array<Expectation>;
    public var fnTest(default, null):TestFunction;
    public var fnCompare(default, null):CompareFunction;

    public function new(input:Dynamic)
    {
        this.input = input;
        expects = new Array<Expectation>();
    }

    public function test(fn:TestFunction):Test
    {
        fnTest = fn;
        return this;
    }

    public function compare(fn:CompareFunction):Test
    {
        fnCompare = fn;
        return this;
    }

    public function expect(output:Dynamic, ?data:Map<String, Dynamic>):Test
    {
        expects.push(new Expectation(output, data, null));
        return this;
    }

    public function throws(error:String, ?data:Map<String, Dynamic>):Test
    {
        expects.push(new Expectation(null, data, error));
        return this;
    }
}

class Expectation
{
    public var output(default, null):Dynamic;
    public var data(default, null):Map<String, Dynamic>;
    public var error(default, null):String;

    public function new(output:Dynamic, data:Map<String, Dynamic>, error:String)
    {
        this.output = output;
        this.data = data;
        this.error = error;
    }
}

class TestSuite
{
    var tests:Array<Test>;
    var verbose:Bool;

    public function new(verbose:Bool)
    {
        tests = new Array<Test>();
        this.verbose = verbose;
    }

    function add(input:Dynamic):Test
    {
        var result:Test = new Test(input);
        tests.push(result);
        return result;
    }

    function fails(msg:String):Void
    {
        print("- " + msg + "\n");
    }

    function success(msg:String):Void
    {
        if (verbose)
        {
            print("- `" + msg + "` succeed...\n");
        }
    }

    function print(msg:String):Void
    {
#if (neko || cpp)
        Lib.print(msg);
#else
        trace(StringTools.trim(msg));
#end
    }

    // function test(t:Test, e:Expectation):Dynamic
    // {
        // throw "Method `test` must be overloaded.";
    // }

    // function compare(result:Dynamic, expected:Dynamic):Bool
    // {
        // return result == expected;
    // }

    public function run():Void
    {
        var runned = 0;
        var failed = 0;
        var succeed = 0;
        var ignored = 0;

        print(Type.getClassName(Type.getClass(this)) + "\n");

        for (t in tests)
        {
            if (null == t.fnTest || null == t.fnCompare)
            {
                ++ignored;
                continue;
            }

            for (expect in t.expects)
            {
                try
                {
                    var result = t.fnTest(t, expect);

                    if (null != expect.error)
                    {
                        fails("`" + t.input + "` should threw <" + expect.error + "> but got none");
                        ++failed;
                    }
                    else if (!t.fnCompare(result, expect.output))
                    {
                        fails("`" + t.input + "`: Expecting <" + expect.output + "> but got <" + result + ">");
                        ++failed;
                    }
                    else
                    {
                        success(expect.output);
                        ++succeed;
                    }
                }
                catch (err:String)
                {
                    if (null != expect.error)
                    {
                        if (err != expect.error)
                        {
                            fails("`" + t.input + "` should threw <" + expect.error + "> but got <" + err + ">");
                            ++failed;
                        }
                        else
                        {
                            success(expect.error);
                            ++succeed;
                        }
                    }
                    else
                    {
                        fails("`" + t.input + "` threw <" + err + ">");
                        ++failed;
                    }
                }
                ++runned;
            }
        }

        print("Total: " + runned + ", Succeed: " + succeed + ", Failed: " + failed + ", Ignored: " + ignored + "\n");

        print("\n");
    }
}
