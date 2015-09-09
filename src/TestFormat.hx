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

        this.add("{COUNT} shades of grey")
            .expect("50 shades of grey", [ "COUNT" => 50 ]);

        this.add("{VAR}")
            .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // Select
        this.add("{GENDER, select, male{He} female {She} other{They}} liked this.")
            .expect("He liked this.", [ "GENDER" => "male" ])
            .expect("She liked this.", [ "GENDER" => "female" ])
            .expect("They liked this.");

        this.add("{GENDER,select,male{He}female{She}other{They}} liked this.")
            .expect("He liked this.", [ "GENDER" => "male" ])
            .expect("She liked this.", [ "GENDER" => "female" ])
            .expect("They liked this.");

        this.add("{A, select, other{!#}}, and {B, select, other{#!}}")
            .expect("!black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        this.add("{A,select,other{#, and {B,select,other{#}}}}!")
            .expect("black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        this.add("{A,select,other{\\##\\, and {B,select,other{#\\#}}}}")
            .expect("#black\\, and mortimer#", [ "A" => "black", "B" => "mortimer" ]);

        this.add("Hello {A,select,キティ{Kitty}other{World}}")
            .expect("Hello Kitty", [ "A" => "キティ" ])
            .expect("Hello World", [ "A" => "世界" ]);

        this.add("{VAR,select,other{succeed}}")
            .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // Plural
        this.add("You have {NUM_TASKS, plural, one {one task} other {# tasks} =42 {the answer to the life, the universe and everything tasks}} remaining.")
            .expect("You have -1 tasks remaining.", [ "NUM_TASKS" => -1 ])
            .expect("You have one task remaining.", [ "NUM_TASKS" => 1 ])
            .expect("You have the answer to the life, the universe and everything tasks remaining.", [ "NUM_TASKS" => 42 ]);

        this.add("{NUM_TASKS, plural, one {a} =1 {b} other {c}}")
            .expect("b", [ "NUM_TASKS" => 1 ]);

        this.add("{NUM, plural, one{a} other{b}}")
            .expect("a", [ "NUM" => 1 ])
            .expect("a", [ "NUM" => "1" ]);

        this.add("You {NUM_ADDS, plural, offset:1 =0{didn't add this to your profile} =1{added this to your profile} one{and one other person added this to their profile} other{and # others added this to their profiles}}.")
            .expect("You didn't add this to your profile.", [ "NUM_ADDS" => 0 ])
            .expect("You added this to your profile.", [ "NUM_ADDS" => 1 ])
            .expect("You and one other person added this to their profile.", [ "NUM_ADDS" => 2 ])
            .expect("You and 2 others added this to their profiles.", [ "NUM_ADDS" => 3 ]);

        this.add("{NUM_ADDS, plural, offset:10 one{a} other{b}}")
            .expect("a", [ "NUM_ADDS" => 11 ])
            .expect("b", [ "NUM_ADDS" => 1 ]);

        this.add("{NUM,plural,other{b}}")
            .throws("ToString: Unsupported type: TBool", [ "NUM" => true ]);

        // Ordinal
        this.add("The {FLOOR, selectordinal, one{#st} two{#nd} few{#rd} other{#th}} floor.")
            .expect("The 0th floor.", [ "FLOOR" => 0 ])
            .expect("The 1st floor.", [ "FLOOR" => 1.0 ])
            .expect("The 2nd floor.", [ "FLOOR" => "2" ])
            .expect("The 3.00rd floor.", [ "FLOOR" => "3.00" ])
            .expect("The 4th floor.", [ "FLOOR" => 4 ])
            .expect("The 101st floor.", [ "FLOOR" => 101 ])
            .expect("The #th floor.");

        this.add("{VAR,selectordinal,other{succeed}}")
            .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // Parsing
        this.add("{").throws("ParseError: `UnbalancedBraces` at 1");
        this.add("{N}}").throws("ParseError: `UnbalancedBraces` at 3");
        this.add("{\\}").throws("ParseError: `InvalidFormat` at 1");
        this.add("{N").throws("ParseError: `UnbalancedBraces` at 2");
        this.add("{ N , select").throws("ParseError: `UnbalancedBraces` at 12");
        this.add("{N, select, other").throws("ParseError: `UnbalancedBraces` at 17");
        this.add("{N, select, other{#}").throws("ParseError: `UnbalancedBraces` at 20");
        this.add("{N, plural, other{#}").throws("ParseError: `UnbalancedBraces` at 20");
        this.add("{N, plural, other{#{").throws("ParseError: `UnbalancedBraces` at 20");
        this.add("{N, plural, other").throws("ParseError: `UnbalancedBraces` at 17");
        this.add("{N, plural, offset:").throws("ParseError: `UnbalancedBraces` at 19");
        this.add("{{}").throws("ParseError: `InvalidExpr` at 1");
        this.add("{N,{}").throws("ParseError: `InvalidExpr` at 3");

        this.add("{}").throws("ParseError: `MissingVarName` at 1");
        this.add("{       }").throws("ParseError: `MissingVarName` at 8");
        this.add("{    ,   }").throws("ParseError: `MissingVarName` at 5");
        this.add("{ , , }").throws("ParseError: `MissingVarName` at 2");

        this.add("{NA-ME}").throws("ParseError: `InvalidFormat` at 3");
        this.add("{N A M E}").throws("ParseError: `InvalidFormat` at 3");
        this.add("{NAMé}").throws("ParseError: `InvalidFormat` at 4");
        this.add("{NAMÉ}").throws("ParseError: `InvalidFormat` at 4");
        this.add("{\\}NAME").throws("ParseError: `InvalidFormat` at 1");
        this.add("{なまえ}").throws("ParseError: `InvalidFormat` at 1");

        this.add("{ N, sel ect, other {#} }").throws("ParseError: `InvalidFormat` at 9");
        this.add("{ N, SELECT, other {#} }").throws("ParseError: `UnknownType: `SELECT`` at 11");

        this.add("{N, select, {#} other {#}}").throws("ParseError: `MissingChoiceName` at 12");
        this.add("{N, select, other {#} {#}}").throws("ParseError: `MissingChoiceName` at 22");
        this.add("{N, selectordinal, {#} other {#}}").throws("ParseError: `MissingChoiceName` at 19");
        this.add("{N, selectordinal, other {#} {#}}").throws("ParseError: `MissingChoiceName` at 29");
        this.add("{N, plural, {#} other {#}}").throws("ParseError: `MissingChoiceName` at 12");
        this.add("{N, plural, other {#} {#}}").throws("ParseError: `MissingChoiceName` at 22");
        this.add("{N, plural, offset:1{#} other {#}}").throws("ParseError: `MissingChoiceName` at 20");
        this.add("{N, plural, offset:1 {#} other {#}}").throws("ParseError: `MissingChoiceName` at 21");
        this.add("{N, plural, offset:1 other {#} {#}}").throws("ParseError: `MissingChoiceName` at 31");

        this.add("{N, select}").throws("ParseError: `MalformedOption` at 10");
        this.add("{N, selectordinal}").throws("ParseError: `MalformedOption` at 17");
        this.add("{N, plural}").throws("ParseError: `MalformedOption` at 10");

        this.add("{N, select, one two{She} other{Other}}").throws("ParseError: `MissingChoiceContent` at 16");
        this.add("{N, selectordinal, one two{She} other{Other}}").throws("ParseError: `MissingChoiceContent` at 23");
        this.add("{N, plural, one two{She} other{Other}}").throws("ParseError: `MissingChoiceContent` at 16");

        this.add("{N, select, one{He} two{She}}").throws("ParseError: `MissingMandatoryChoice` at 28");
        this.add("{N, selectordinal, one{He} two{She}}").throws("ParseError: `MissingMandatoryChoice` at 35");
        this.add("{N, plural, one{He} two{She}}").throws("ParseError: `MissingMandatoryChoice` at 28");

        this.add("{N, select, offset:1 one{#} other {#}}").throws("ParseError: `UnexpectedExtension` at 18");
        this.add("{N, selectordinal, offset:1 one{#} other {#}}").throws("ParseError: `UnexpectedExtension` at 25");
        this.add("{N, plural, factor:1 one{#} other {#}}").throws("ParseError: `UnsupportedExtension: `factor`` at 18");

        this.add("{N, plural, offset:}").throws("ParseError: `MissingOffsetValue` at 19");
        this.add("{N, plural, offset: one{#} other {#}}").throws("ParseError: `BadCast` at 23");
        this.add("{N, plural, offset:A one{#} other {#}}").throws("ParseError: `BadCast` at 20");
        this.add("{N, plural, offset:1.0 one{#} other {#}}").throws("ParseError: `BadCast` at 22");
        this.add("{N, plural, offset:-1 one{#} other {#}}").throws("ParseError: `InvalidOffsetValue` at 21");

        // Nested
        this.add("{PLUR1, plural, one {1} other {{SEL2, select, other {deep in the heart.}}}}")
            .expect("1", [ "PLUR1" => 1 ])
            .expect("deep in the heart.", [ "SEL2" => 1 ])
            .expect("deep in the heart.");

        this.add("I have {FRIENDS, plural, one{one friend} other{# friends but {ENEMIES, plural, one{one enemy} other{# enemies}}.}}.")
            .expect("I have 0 friends but one enemy..", [ "FRIENDS" => 0, "ENEMIES" => "1" ])
            .expect("I have # friends but # enemies..");

        // Escaped
        this.add("\\#").expect("#");
        this.add("\\\\").expect("\\\\");
        this.add("\\{").expect("{");
        this.add("\\}").expect("}");

        this.add("\\{ {S, select, other{# is a \\#}} \\}")
            .expect("{ 5 is a # }", [ "S" => 5 ]);

        this.add("\\{\\{\\{{test, plural, other{#}}\\}\\}\\}")
            .expect("{{{4}}}", [ "test" => 4 ]);

        this.add("日\\{本\\}語").expect("日{本}語");
        this.add("he\\\\#ll\\\\\\{o\\\\} \\##!").expect("he\\\\#ll\\\\\\{o\\\\} ##!");

        // Non ASCII
        this.add("猫 {N}。。。")
            .expect("猫 キティ。。。", [ "N" => "キティ" ]);

        // Multiline
        this.add("{GENDER, select,
    male {He}
  female {She}
   other {They}
}")
            .expect("He", [ "GENDER" => "male" ])
            .expect("She", [ "GENDER" => "female" ])
            .expect("They");

        this.add("{GENDER, select,
    male {He}
  female {She}
   other {They}
} found {NUM_RESULTS, plural,
            one
            {1 result}
          other {
          # results in {NUM_CATEGORIES, plural,
                  one {1 category}
                other {# categories}
             } !}
        }.")
            .expect("He found 1 result.", [ "GENDER" => "male", "NUM_RESULTS" => 1, "NUM_CATEGORIES" => 2 ])
            .expect("She found 1 result.", [ "GENDER" => "female", "NUM_RESULTS" => 1, "NUM_CATEGORIES" => 2 ])
            .expect("He found \r\n          2 results in 1 category !.", [ "GENDER" => "male", "NUM_RESULTS" => 2, "NUM_CATEGORIES" => 1 ])
            .expect("They found \r\n          2 results in 2 categories !.", [ "NUM_RESULTS" => 2, "NUM_CATEGORIES" => 2 ]);

        this.add("{NUM_RESULTS, plural,
            one
            {1 result}
          other {# results}
        }, {NUM_CATEGORIES, plural,
                  one {1 category}
                other {# categories}
             }.")
            .expect("1 result, 2 categories.", [ "NUM_RESULTS" => 1, "NUM_CATEGORIES" => 2 ])
            .expect("2 results, 1 category.", [ "NUM_RESULTS" => 2, "NUM_CATEGORIES" => 1 ])
            .expect("2 results, 2 categories.", [ "NUM_RESULTS" => 2, "NUM_CATEGORIES" => 2 ]);

        this.add("{GENDER, select,
    male {He}
  female {She}
   other {They}
} found {NUM_RESULTS, plural,
            one
            {1 result}
          other {# results}
        } in {NUM_CATEGORIES, plural,
                  one {1 category}
                other {# categories}
             }.")
            .expect("He found 1 result in 2 categories.", [ "GENDER" => "male", "NUM_RESULTS" => 1, "NUM_CATEGORIES" => 2 ])
            .expect("She found 1 result in 2 categories.", [ "GENDER" => "female", "NUM_RESULTS" => 1, "NUM_CATEGORIES" => 2 ])
            .expect("He found 2 results in 1 category.", [ "GENDER" => "male", "NUM_RESULTS" => 2, "NUM_CATEGORIES" => 1 ])
            .expect("They found 2 results in 2 categories.", [ "NUM_RESULTS" => 2, "NUM_CATEGORIES" => 2 ]);
    }

    override function test(t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
    {
        var p = new Parser();
        var mf = p.parse(t.input);
        return mf.format(e.data);
    }
}
