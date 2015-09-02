package;

import messageformat.Parser;

class Main
{
	static public function main():Void
    {
        var suite = new TestSuite();

        // suite.add("")
            // .expect("");

        // suite.add("\\")
            // .expect("\\");

        // suite.add("\\\\")
            // .expect("\\\\");

        // suite.add("\\\\\\")
            // .expect("\\\\\\");

        // suite.add("\\q\\")
            // .expect("\\q\\");

        // suite.add("test\\")
            // .expect("test\\");

        // suite.add("\n")
            // .expect("\n");

        // suite.add("\\n")
            // .expect("\\n");

        // suite.add(" This is \n a string\"")
            // .expect(" This is \n a string\"");

        // suite.add("日本語")
            // .expect("日本語");

        suite.add("Hello, 世界")
            .expect("Hello, 世界");

        suite.add("Hello {NAME}")
            .expect("Hello キティ", [ "NAME" => "キティ" ]);

        // suite.add("{GENDER, select, male{He} female {She} other{They}} liked this.")
            // .expect("He liked this.", [ "GENDER" => "male" ])
            // .expect("She liked this.", [ "GENDER" => "female" ])
            // .expect("They liked this.");

        // suite.add("{GENDER,select,male{He}female{She}other{They}} liked this.")
            // .expect("He liked this.", [ "GENDER" => "male" ])
            // .expect("She liked this.", [ "GENDER" => "female" ])
            // .expect("They liked this.");

        // suite.add("{A, select, other{!#}}, and {B, select, other{#!}}")
            // .expect("!black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        // suite.add("{A,select,other{#, and {B,select,other{#}}}}!")
            // .expect("black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        // suite.add("{A,select,other{\\##\\, and {B,select,other{#\\#}}}}")
            // .expect("#black\\, and mortimer#", [ "A" => "black", "B" => "mortimer" ]);

        // suite.add("Hello {A,select,キティ{Kitty}other{World}}")
            // .expect("Hello Kitty", [ "A" => "キティ" ])
            // .expect("Hello World", [ "A" => "世界" ]);

        for (test in suite)
        {
            var p = new Parser();

            for (expect in test.expects)
            {
                try
                {
                    var mf = p.parse(test.input);
                    var result = mf.format(expect.data);

                    if (result != expect.output)
                    {
                        trace("Expecting <" + expect.output + "> but got <" + result + ">");
                    }
                    else
                    {
                        trace("`" + expect.output + "` succeed...");
                    }
                }
                catch (err:String)
                {
                    trace("`" + test.input + "` threw <" + err + ">");
                }
            }
        }
	}
}