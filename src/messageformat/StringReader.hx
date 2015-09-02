package messageformat;

import haxe.Utf8;

class StringReader
{
    var s:String;
    var m:Int;
    var i:Int;
    var c:Int;

    var w:Int;

    public function new(s:String)
    {
        this.s = s;
        m = Utf8.length(s);
        i = 0;
        c = 0;
        w = 0;
    }

    public function eof()
    {
        return i > m;
    }

    public function hasNext()
    {
        var result = i < m;
        if (++w > 100)
        {
            throw "[StringReader] deadlock detected";
        }
        return result;
    }

    public function next()
    {
        c = Utf8.charCodeAt(s, i++);
        w = 0;
        return c;
    }

    public function isEscape()
    {
        return 92 == c;
    }

    public function isOpen()
    {
        return 123 == c;
    }

    public function isClose()
    {
        return 125 == c;
    }

    public function isPart()
    {
        return 44 == c;
    }

    public function isPound()
    {
        return 35 == c;
    }

    public function isWhitespace()
    {
        return 32 == c || 13 == c || 10 == c || 9 == c;
    }

    public function isUnderscore()
    {
        return 95 == c;
    }

    public function isAlphaNumeric()
    {
        return (c >= 48 && c <= 57) || (c >= 97 && c <= 122) || (c >= 65 && c <= 90);
    }

    public function whitespace()
    {
        while (hasNext())
        {
            if (!isWhitespace())
            {
                return c;
            }

            next();
        }
        return 0;
    }

    public function pos()
    {
        return i > 0 ? i - 1 : 0;
    }

    public function length()
    {
        return m;
    }

    public function slice(start:Int)
    {
        var inner = Utf8.sub(s, start, i - start);
        return new StringReader(inner);
    }

    public function substr(start:Int, end:Int)
    {
        return Utf8.sub(s, start, end - start);
    }

    public function debug(?prefix:String)
    {
        var char = String.fromCharCode(c);

        if (null != prefix)
        {
            trace(prefix + char + " (" + c + " at " + (i - 1) + ")");
        }
        else
        {
            trace(char + " (" + c + " at " + (i - 1) + ")");
        }
    }
}
