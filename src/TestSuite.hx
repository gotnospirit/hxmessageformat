package;

#if neko
import neko.Lib;
#end

class Test
{
    public var input(default, null):String;
    public var expects(default, null):Array<Expectation>;

    public function new(input:String)
    {
        this.input = input;
        this.expects = new Array<Expectation>();
    }

    public function expect(output:String, ?data:Map<String, Dynamic>)
    {
        expects.push(new Expectation(output, data, null));
        return this;
    }

    public function throws(error:String, ?data:Map<String, Dynamic>)
    {
        expects.push(new Expectation(null, data, error));
        return this;
    }
}

class Expectation
{
    public var output(default, null):String;
    public var data(default, null):Map<String, Dynamic>;
    public var error(default, null):String;

    public function new(output:String, data:Map<String, Dynamic>, error:String)
    {
        this.output = output;
        this.data = data;
        this.error = error;
    }
}

class TestSuite
{
    var t:Array<Test>;
    var verbose:Bool;

    public function new(verbose:Bool)
    {
        t = new Array<Test>();
        this.verbose = verbose;
    }

    function add(input:String)
    {
        var result:Test = new Test(input);
        t.push(result);
        return result;
    }

    function fails(msg:String)
    {
        print("- " + msg + "\n");
    }

    function success(msg:String)
    {
        if (verbose)
        {
            print("- `" + msg + "` succeed...\n");
        }
    }

    function print(msg:String)
    {
        Lib.print(msg);
    }

    function doTest(t:Test, e:Expectation)
    {
        return "";
    }

    public function run()
    {
        var runned = 0;
        var failed = 0;
        var succeed = 0;

        print(Type.getClassName(Type.getClass(this)) + "\n");

        for (test in t)
        {
            for (expect in test.expects)
            {
                try
                {
                    var result = doTest(test, expect);

                    if (null != expect.error)
                    {
                        fails("`" + test.input + "` should threw <" + expect.error + "> but got none");
                        ++failed;
                    }
                    else if (result != expect.output)
                    {
                        fails("`" + test.input + "`: Expecting <" + expect.output + "> but got <" + result + ">");
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
                            fails("`" + test.input + "` should threw <" + expect.error + "> but got <" + err + ">");
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
                        fails("`" + test.input + "` threw <" + err + ">");
                        ++failed;
                    }
                }
                ++runned;
            }
        }

        print("Total: " + runned + ", Succeed: " + succeed + ", Failed: " + failed + "\n");

        print("\n");
    }
}
