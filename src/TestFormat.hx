package;

import messageformat.Parser;

class TestFormat extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        // Literal
        this.add("")
            .expect("");

        this.add("\\")
            .expect("\\");

        this.add("\\\\")
            .expect("\\\\");

        this.add("\\\\\\")
            .expect("\\\\\\");

        this.add("\\q\\")
            .expect("\\q\\");

        this.add("test\\")
            .expect("test\\");

        this.add("\n")
            .expect("\n");

        this.add("\\n")
            .expect("\\n");

        this.add(" This is \n a string\"")
            .expect(" This is \n a string\"");

        this.add("日本語")
            .expect("日本語");

        this.add("Hello, 世界")
            .expect("Hello, 世界");

        // Var
        this.add("Hello {NAME}")
            .expect("Hello キティ", [ "NAME" => "キティ" ]);

        this.add("{NAME}")
            .expect("leila", [ "NAME" => "leila" ])
            .expect("", [ "NAME" => null ])
            .expect("");

        this.add("My name is { NAME}")
            .expect("My name is yoda", [ "NAME" => "yoda" ]);

        this.add("My name is { NAME  }...")
            .expect("My name is chewy...", [ "NAME" => "chewy" ]);

        this.add("Hey {A}, i'm your {B}!")
            .expect("Hey luke, i'm your father!", [ "A" => "luke", "B" => "father" ]);

        this.add("{
        NAME
        } is my name")
            .expect("chewy is my name", [ "NAME" => "chewy" ]);

        // this.add("{COUNT} shades of grey")
            // .expect("50 shades of grey", [ "COUNT" => 50 ]);

        // this.add("{VAR}")
            // .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // // Select
        // this.add("{GENDER, select, male{He} female {She} other{They}} liked this.")
            // .expect("He liked this.", [ "GENDER" => "male" ])
            // .expect("She liked this.", [ "GENDER" => "female" ])
            // .expect("They liked this.");

        // this.add("{GENDER,select,male{He}female{She}other{They}} liked this.")
            // .expect("He liked this.", [ "GENDER" => "male" ])
            // .expect("She liked this.", [ "GENDER" => "female" ])
            // .expect("They liked this.");

        // this.add("{A, select, other{!#}}, and {B, select, other{#!}}")
            // .expect("!black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        // this.add("{A,select,other{#, and {B,select,other{#}}}}!")
            // .expect("black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        // this.add("{A,select,other{\\##\\, and {B,select,other{#\\#}}}}")
            // .expect("#black\\, and mortimer#", [ "A" => "black", "B" => "mortimer" ]);

        // this.add("Hello {A,select,キティ{Kitty}other{World}}")
            // .expect("Hello Kitty", [ "A" => "キティ" ])
            // .expect("Hello World", [ "A" => "世界" ]);

        // this.add("{VAR,select,other{succeed}}")
            // .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // // Plural
        // this.add("You have {NUM_TASKS, plural, one {one task} other {# tasks} =42 {the answer to the life, the universe and everything tasks}} remaining.")
            // .expect("You have -1 tasks remaining.", [ "NUM_TASKS" => "-1" ])
            // .expect("You have one task remaining.", [ "NUM_TASKS" => "1" ])
            // .expect("You have the answer to the life, the universe and everything tasks remaining.", [ "NUM_TASKS" => "42" ]);

        // this.add("{NUM_TASKS, plural, one {a} =1 {b} other {c}}")
            // .expect("b", [ "NUM_TASKS" => "1" ]);

        // this.add("{NUM, plural, one{a} other{b}}")
            // .expect("a", [ "NUM" => "1" ]);

        // this.add("You {NUM_ADDS, plural, offset:1 =0{didnt add this to your profile} =1{added this to your profile} one{and one other person added this to their profile} other{and # others added this to their profiles}}.")
            // .expect("You didnt add this to your profile.", [ "NUM_ADDS" => "0" ])
            // .expect("You added this to your profile.", [ "NUM_ADDS" => "1" ])
            // .expect("You and one other person added this to their profile.", [ "NUM_ADDS" => "2" ])
            // .expect("You and 2 others added this to their profiles.", [ "NUM_ADDS" => "3" ]);

        // this.add("{NUM,plural,other{b}}")
            // .throws("ToString: Unsupported type: TBool", [ "NUM" => true ]);

        // // Ordinal
        // this.add("The {FLOOR, selectordinal, one{#st} two{#nd} few{#rd} other{#th}} floor.")
            // .expect("The 0th floor.", [ "FLOOR" => "0" ])
            // .expect("The 1st floor.", [ "FLOOR" => "1.0" ])
            // .expect("The 2nd floor.", [ "FLOOR" => "2" ])
            // .expect("The 3.00rd floor.", [ "FLOOR" => "3.00" ])
            // .expect("The 4th floor.", [ "FLOOR" => "4" ])
            // .expect("The 101st floor.", [ "FLOOR" => "101" ])
            // .expect("The #th floor.");

        // this.add("{VAR,selectordinal,other{succeed}}")
            // .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);
    }

    override function doTest(t:TestSuite.Test, e:TestSuite.Expectation)
    {
        var p = new Parser();
        var mf = p.parse(t.input);
        return mf.format(e.data);
    }
}