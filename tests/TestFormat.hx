package;

import hxmessageformat.Parser;

class TestFormat extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        // Literal
        this.createTest("")
            .expect("");

        this.createTest("\\")
            .expect("\\");

        this.createTest("\\\\")
            .expect("\\\\");

        this.createTest("\\\\\\")
            .expect("\\\\\\");

        this.createTest("\\q\\")
            .expect("\\q\\");

        this.createTest("test\\")
            .expect("test\\");

        this.createTest("\n")
            .expect("\n");

        this.createTest("\\n")
            .expect("\\n");

        this.createTest(" This is \n a string\"")
            .expect(" This is \n a string\"");

        this.createTest("日本語")
            .expect("日本語");

        this.createTest("Hello, 世界")
            .expect("Hello, 世界");

        // Var
        this.createTest("Hello {NAME}")
            .expect("Hello キティ", [ "NAME" => "キティ" ]);

        this.createTest("{NAME}")
            .expect("leila", [ "NAME" => "leila" ])
            .expect("", [ "NAME" => null ])
            .expect("");

        this.createTest("My name is { NAME}")
            .expect("My name is yoda", [ "NAME" => "yoda" ]);

        this.createTest("My name is { NAME  }...")
            .expect("My name is chewy...", [ "NAME" => "chewy" ]);

        this.createTest("Hey {A}, i'm your {B}!")
            .expect("Hey luke, i'm your father!", [ "A" => "luke", "B" => "father" ]);

        this.createTest("{
        NAME
        } is my name")
            .expect("chewy is my name", [ "NAME" => "chewy" ]);

        this.createTest("{COUNT} shades of grey")
            .expect("50 shades of grey", [ "COUNT" => 50 ]);

        this.createTest("{VAR}")
            .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // Select
        this.createTest("{GENDER, select, male{He} female {She} other{They}} liked this.")
            .expect("He liked this.", [ "GENDER" => "male" ])
            .expect("She liked this.", [ "GENDER" => "female" ])
            .expect("They liked this.");

        this.createTest("{GENDER,select,male{He}female{She}other{They}} liked this.")
            .expect("He liked this.", [ "GENDER" => "male" ])
            .expect("She liked this.", [ "GENDER" => "female" ])
            .expect("They liked this.");

        this.createTest("{A, select, other{!#}}, and {B, select, other{#!}}")
            .expect("!black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        this.createTest("{A,select,other{#, and {B,select,other{#}}}}!")
            .expect("black, and mortimer!", [ "A" => "black", "B" => "mortimer" ]);

        this.createTest("{A,select,other{\\##\\, and {B,select,other{#\\#}}}}")
            .expect("#black\\, and mortimer#", [ "A" => "black", "B" => "mortimer" ]);

        this.createTest("Hello {A,select,キティ{Kitty}other{World}}")
            .expect("Hello Kitty", [ "A" => "キティ" ])
            .expect("Hello World", [ "A" => "世界" ]);

        this.createTest("{VAR,select,other{succeed}}")
            .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // Plural
        this.createTest("You have {NUM_TASKS, plural, one {one task} other {# tasks} =42 {the answer to the life, the universe and everything tasks}} remaining.")
            .expect("You have -1 tasks remaining.", [ "NUM_TASKS" => -1 ])
            .expect("You have one task remaining.", [ "NUM_TASKS" => 1 ])
            .expect("You have the answer to the life, the universe and everything tasks remaining.", [ "NUM_TASKS" => 42 ]);

        this.createTest("{NUM_TASKS, plural, one {a} =1 {b} other {c}}")
            .expect("b", [ "NUM_TASKS" => 1 ]);

        this.createTest("{NUM, plural, one{a} other{b}}")
            .expect("a", [ "NUM" => 1 ])
            .expect("a", [ "NUM" => "1" ]);

        this.createTest("You {NUM_ADDS, plural, offset:1 =0{didn't add this to your profile} =1{added this to your profile} one{and one other person added this to their profile} other{and # others added this to their profiles}}.")
            .expect("You didn't add this to your profile.", [ "NUM_ADDS" => 0 ])
            .expect("You added this to your profile.", [ "NUM_ADDS" => 1 ])
            .expect("You and one other person added this to their profile.", [ "NUM_ADDS" => 2 ])
            .expect("You and 2 others added this to their profiles.", [ "NUM_ADDS" => 3 ]);

        this.createTest("{NUM_ADDS, plural, offset:10 one{a} other{b}}")
            .expect("a", [ "NUM_ADDS" => 11 ])
            .expect("b", [ "NUM_ADDS" => 1 ]);

        this.createTest("{NUM,plural,other{b}}")
            .throws("ToString: Unsupported type: TBool", [ "NUM" => true ]);

        // Ordinal
        this.createTest("The {FLOOR, selectordinal, one{#st} two{#nd} few{#rd} other{#th}} floor.")
            .expect("The 0th floor.", [ "FLOOR" => 0 ])
            .expect("The 1st floor.", [ "FLOOR" => 1.0 ])
            .expect("The 2nd floor.", [ "FLOOR" => "2" ])
            .expect("The 3.00rd floor.", [ "FLOOR" => "3.00" ])
            .expect("The 4th floor.", [ "FLOOR" => 4 ])
            .expect("The 101st floor.", [ "FLOOR" => 101 ])
            .expect("The #th floor.");

        this.createTest("{VAR,selectordinal,other{succeed}}")
            .throws("ToString: Unsupported type: TBool", [ "VAR" => true ]);

        // Parsing
        this.createTest("{")
            .throws("ParseError: `UnbalancedBraces` at 1");

        this.createTest("{N}}")
            .throws("ParseError: `UnbalancedBraces` at 3");

        this.createTest("{\\}")
            .throws("ParseError: `InvalidFormat` at 1");

        this.createTest("{N")
            .throws("ParseError: `UnbalancedBraces` at 2");

        this.createTest("{ N , select")
            .throws("ParseError: `UnbalancedBraces` at 12");

        this.createTest("{N, select, other")
            .throws("ParseError: `UnbalancedBraces` at 17");

        this.createTest("{N, select, other{#}")
            .throws("ParseError: `UnbalancedBraces` at 20");

        this.createTest("{N, plural, other{#}")
            .throws("ParseError: `UnbalancedBraces` at 20");

        this.createTest("{N, plural, other{#{")
            .throws("ParseError: `UnbalancedBraces` at 20");

        this.createTest("{N, plural, other")
            .throws("ParseError: `UnbalancedBraces` at 17");

        this.createTest("{N, plural, offset:")
            .throws("ParseError: `UnbalancedBraces` at 19");

        this.createTest("{{}")
            .throws("ParseError: `InvalidExpr` at 1");

        this.createTest("{N,{}")
            .throws("ParseError: `InvalidExpr` at 3");

        this.createTest("{}")
            .throws("ParseError: `MissingVarName` at 1");

        this.createTest("{       }")
            .throws("ParseError: `MissingVarName` at 8");

        this.createTest("{    ,   }")
            .throws("ParseError: `MissingVarName` at 5");

        this.createTest("{ , , }")
            .throws("ParseError: `MissingVarName` at 2");

        this.createTest("{NA-ME}")
            .throws("ParseError: `InvalidFormat` at 3");

        this.createTest("{N A M E}")
            .throws("ParseError: `InvalidFormat` at 3");

        this.createTest("{NAMé}")
            .throws("ParseError: `InvalidFormat` at 4");

        this.createTest("{NAMÉ}")
            .throws("ParseError: `InvalidFormat` at 4");

        this.createTest("{\\}NAME")
            .throws("ParseError: `InvalidFormat` at 1");

        this.createTest("{なまえ}")
            .throws("ParseError: `InvalidFormat` at 1");

        this.createTest("{ N, sel ect, other {#} }")
            .throws("ParseError: `InvalidFormat` at 9");

        this.createTest("{ N, SELECT, other {#} }")
            .throws("ParseError: `UnknownType: `SELECT`` at 11");

        this.createTest("{N, select, {#} other {#}}")
            .throws("ParseError: `MissingChoiceName` at 12");

        this.createTest("{N, select, other {#} {#}}")
            .throws("ParseError: `MissingChoiceName` at 22");

        this.createTest("{N, selectordinal, {#} other {#}}")
            .throws("ParseError: `MissingChoiceName` at 19");

        this.createTest("{N, selectordinal, other {#} {#}}")
            .throws("ParseError: `MissingChoiceName` at 29");

        this.createTest("{N, plural, {#} other {#}}")
            .throws("ParseError: `MissingChoiceName` at 12");

        this.createTest("{N, plural, other {#} {#}}")
            .throws("ParseError: `MissingChoiceName` at 22");

        this.createTest("{N, plural, offset:1{#} other {#}}")
            .throws("ParseError: `MissingChoiceName` at 20");

        this.createTest("{N, plural, offset:1 {#} other {#}}")
            .throws("ParseError: `MissingChoiceName` at 21");

        this.createTest("{N, plural, offset:1 other {#} {#}}")
            .throws("ParseError: `MissingChoiceName` at 31");

        this.createTest("{N, select}")
            .throws("ParseError: `MalformedOption` at 10");

        this.createTest("{N, selectordinal}")
            .throws("ParseError: `MalformedOption` at 17");

        this.createTest("{N, plural}")
            .throws("ParseError: `MalformedOption` at 10");

        this.createTest("{N, select, one two{She} other{Other}}")
            .throws("ParseError: `MissingChoiceContent` at 16");

        this.createTest("{N, selectordinal, one two{She} other{Other}}")
            .throws("ParseError: `MissingChoiceContent` at 23");

        this.createTest("{N, plural, one two{She} other{Other}}")
            .throws("ParseError: `MissingChoiceContent` at 16");

        this.createTest("{N, select, one{He} two{She}}")
            .throws("ParseError: `MissingMandatoryChoice` at 28");

        this.createTest("{N, selectordinal, one{He} two{She}}")
            .throws("ParseError: `MissingMandatoryChoice` at 35");

        this.createTest("{N, plural, one{He} two{She}}")
            .throws("ParseError: `MissingMandatoryChoice` at 28");

        this.createTest("{N, select, offset:1 one{#} other {#}}")
            .throws("ParseError: `UnexpectedExtension` at 18");

        this.createTest("{N, selectordinal, offset:1 one{#} other {#}}")
            .throws("ParseError: `UnexpectedExtension` at 25");

        this.createTest("{N, plural, factor:1 one{#} other {#}}")
            .throws("ParseError: `UnsupportedExtension: `factor`` at 18");

        this.createTest("{N, plural, offset:}")
            .throws("ParseError: `MissingOffsetValue` at 19");

        this.createTest("{N, plural, offset: one{#} other {#}}")
            .throws("ParseError: `BadCast` at 23");

        this.createTest("{N, plural, offset:A one{#} other {#}}")
            .throws("ParseError: `BadCast` at 20");

        this.createTest("{N, plural, offset:1.0 one{#} other {#}}")
            .throws("ParseError: `BadCast` at 22");

        this.createTest("{N, plural, offset:-1 one{#} other {#}}")
            .throws("ParseError: `InvalidOffsetValue` at 21");

        // Nested
        this.createTest("{PLUR1, plural, one {1} other {{SEL2, select, other {deep in the heart.}}}}")
            .expect("1", [ "PLUR1" => 1 ])
            .expect("deep in the heart.", [ "SEL2" => 1 ])
            .expect("deep in the heart.");

        this.createTest("I have {FRIENDS, plural, one{one friend} other{# friends but {ENEMIES, plural, one{one enemy} other{# enemies}}.}}.")
            .expect("I have 0 friends but one enemy..", [ "FRIENDS" => 0, "ENEMIES" => "1" ])
            .expect("I have # friends but # enemies..");

        // Escaped
        this.createTest("\\#")
            .expect("#");

        this.createTest("\\\\")
            .expect("\\\\");

        this.createTest("\\{")
            .expect("{");

        this.createTest("\\}")
            .expect("}");

        this.createTest("\\{ {S, select, other{# is a \\#}} \\}")
            .expect("{ 5 is a # }", [ "S" => 5 ]);

        this.createTest("\\{\\{\\{{test, plural, other{#}}\\}\\}\\}")
            .expect("{{{4}}}", [ "test" => 4 ]);

        this.createTest("日\\{本\\}語")
            .expect("日{本}語");

        this.createTest("he\\\\#ll\\\\\\{o\\\\} \\##!")
            .expect("he\\\\#ll\\\\\\{o\\\\} ##!");

        // Non ASCII
        this.createTest("猫 {N}。。。")
            .expect("猫 キティ。。。", [ "N" => "キティ" ]);

        // Multiline
        this.createTest("{GENDER, select,
    male {He}
  female {She}
   other {They}
}")
            .expect("He", [ "GENDER" => "male" ])
            .expect("She", [ "GENDER" => "female" ])
            .expect("They");

        this.createTest("{GENDER, select,
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

        this.createTest("{NUM_RESULTS, plural,
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

        this.createTest("{GENDER, select,
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

    function createTest(input:String):TestSuite.Test
    {
        return this.add(input)
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                var p = new Parser();
                var mf = p.parse(t.input);
                return mf.format(e.data);
            })
            .compare(function (result:Dynamic, expected:Dynamic):Bool
            {
                return result == expected;
            });
    }
}
