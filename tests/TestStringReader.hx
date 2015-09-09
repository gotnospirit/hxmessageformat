package;

import hxmessageformat.StringReader;

class TestStringReader extends TestSuite
{
    public function new(verbose:Bool = false)
    {
        super(verbose);

        this.add("StringReader.eof()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).eof();
            })
            .compare(BasicCompare)
            .expect(true, [ "value" => "" ])
            .expect(false, [ "value" => "abc" ]);

        this.add("StringReader.hasNext()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).hasNext();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "" ])
            .expect(true, [ "value" => "abc" ]);

        this.add("StringReader.next()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).next();
            })
            .compare(BasicCompare)
            .expect(98, [ "value" => "ab" ])
            .expect(42, [ "value" => "b*" ])
            .expect(0, [ "value" => "a" ])
            .expect(0, [ "value" => "" ]);

        this.add("StringReader.isEscape()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isEscape();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "\\" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isOpen()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isOpen();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "{" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isClose()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isClose();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "}" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isComma()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isComma();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "," ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isPound()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isPound();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "#" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isColon()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isColon();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => ":" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isWhitespace()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isWhitespace();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => " " ])
            .expect(true, [ "value" => "\t" ])
            .expect(true, [ "value" => "\r" ])
            .expect(true, [ "value" => "\n" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isUnderscore()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isUnderscore();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "_" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isAlphaNumeric()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isAlphaNumeric();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "-" ])
            .expect(true, [ "value" => "a" ])
            .expect(true, [ "value" => "b" ])
            .expect(true, [ "value" => "c" ])
            .expect(true, [ "value" => "d" ])
            .expect(true, [ "value" => "e" ])
            .expect(true, [ "value" => "f" ])
            .expect(true, [ "value" => "g" ])
            .expect(true, [ "value" => "h" ])
            .expect(true, [ "value" => "i" ])
            .expect(true, [ "value" => "j" ])
            .expect(true, [ "value" => "k" ])
            .expect(true, [ "value" => "l" ])
            .expect(true, [ "value" => "m" ])
            .expect(true, [ "value" => "n" ])
            .expect(true, [ "value" => "o" ])
            .expect(true, [ "value" => "p" ])
            .expect(true, [ "value" => "q" ])
            .expect(true, [ "value" => "r" ])
            .expect(true, [ "value" => "s" ])
            .expect(true, [ "value" => "t" ])
            .expect(true, [ "value" => "u" ])
            .expect(true, [ "value" => "v" ])
            .expect(true, [ "value" => "w" ])
            .expect(true, [ "value" => "x" ])
            .expect(true, [ "value" => "y" ])
            .expect(true, [ "value" => "z" ])
            .expect(true, [ "value" => "0" ])
            .expect(true, [ "value" => "1" ])
            .expect(true, [ "value" => "2" ])
            .expect(true, [ "value" => "3" ])
            .expect(true, [ "value" => "4" ])
            .expect(true, [ "value" => "5" ])
            .expect(true, [ "value" => "6" ])
            .expect(true, [ "value" => "7" ])
            .expect(true, [ "value" => "8" ])
            .expect(true, [ "value" => "9" ])
            .expect(true, [ "value" => "A" ])
            .expect(true, [ "value" => "B" ])
            .expect(true, [ "value" => "C" ])
            .expect(true, [ "value" => "D" ])
            .expect(true, [ "value" => "E" ])
            .expect(true, [ "value" => "F" ])
            .expect(true, [ "value" => "G" ])
            .expect(true, [ "value" => "H" ])
            .expect(true, [ "value" => "I" ])
            .expect(true, [ "value" => "J" ])
            .expect(true, [ "value" => "K" ])
            .expect(true, [ "value" => "L" ])
            .expect(true, [ "value" => "M" ])
            .expect(true, [ "value" => "N" ])
            .expect(true, [ "value" => "O" ])
            .expect(true, [ "value" => "P" ])
            .expect(true, [ "value" => "Q" ])
            .expect(true, [ "value" => "R" ])
            .expect(true, [ "value" => "S" ])
            .expect(true, [ "value" => "T" ])
            .expect(true, [ "value" => "U" ])
            .expect(true, [ "value" => "V" ])
            .expect(true, [ "value" => "W" ])
            .expect(true, [ "value" => "X" ])
            .expect(true, [ "value" => "Y" ])
            .expect(true, [ "value" => "Z" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.isUnderscore()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).isUnderscore();
            })
            .compare(BasicCompare)
            .expect(false, [ "value" => "a" ])
            .expect(true, [ "value" => "_" ])
            .expect(false, [ "value" => "" ]);

        this.add("StringReader.whitespace()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value")).whitespace();
            })
            .compare(BasicCompare)
            .expect(97, [ "value" => "      a" ])
            .expect(122, [ "value" => " z " ])
            .expect(0, [ "value" => "" ]);

        this.add("StringReader.substr()")
            .test(function (t:TestSuite.Test, e:TestSuite.Expectation):Dynamic
            {
                return new StringReader(e.data.get("value"))
                    .substr(e.data.get("from"), e.data.get("to"));
            })
            .compare(BasicCompare)
            .throws("-", [ "value" => "hello world", "from" => "a", "to" => "b" ])
            .throws("-", [ "value" => "hello world", "from" => 3, "to" => "9" ])
            .throws("-", [ "value" => "hello world", "from" => "3", "to" => 9 ])
            .expect("lo wor", [ "value" => "hello world", "from" => 3, "to" => 9 ]);
    }

    static function BasicCompare(result:Dynamic, expected:Dynamic):Bool
    {
        return result == expected;
    }
}