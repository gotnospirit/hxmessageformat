package hxmessageformat;

import haxe.Utf8;

class StringReader
{
    var s:String;
    public var length(default, null):Int;
    public var pos(default, null):Int;
    var c:Int;
    var w:Int;

    public function new(s:String)
    {
        this.s = s;
        length = Utf8.length(s);
        pos = 0;
        c = length > 0 ? Utf8.charCodeAt(s, pos) : 0;
        w = 0;
    }

    public function eof():Bool
    {
        var result = pos >= length;
        if (++w > 10)
        {
            throw "[StringReader] infinite loop detected";
        }
        return result;
    }

    public function hasNext():Bool
    {
        var result = pos + 1 <= length;
        if (++w > 10)
        {
            throw "[StringReader] infinite loop detected";
        }
        return result;
    }

    public function next():Int
    {
        if (++pos < length)
        {
            c = Utf8.charCodeAt(s, pos);
            w = 0;
        }
        else
        {
            c = 0;
        }
        return c;
    }

    public function isEscape():Bool
    {
        return 92 == c;
    }

    public function isOpen():Bool
    {
        return 123 == c;
    }

    public function isClose():Bool
    {
        return 125 == c;
    }

    public function isComma():Bool
    {
        return 44 == c;
    }

    public function isPound():Bool
    {
        return 35 == c;
    }

    public function isColon():Bool
    {
        return 58 == c;
    }

    public function isWhitespace():Bool
    {
        return 32 == c || 13 == c || 10 == c || 9 == c;
    }

    public function isUnderscore():Bool
    {
        return 95 == c;
    }

    public function isAlphaNumeric():Bool
    {
        return (c >= 48 && c <= 57) || (c >= 97 && c <= 122) || (c >= 65 && c <= 90);
    }

    public function whitespace():Int
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

    public function substr(start:Int, end:Int):String
    {
        return Utf8.sub(s, start, end - start);
    }

    public function debug(?prefix:String):Void
    {
        var char = String.fromCharCode(c);

        if (null != prefix)
        {
            trace(prefix + char + " (" + c + " at " + pos + ")");
        }
        else
        {
            trace(char + " (" + c + " at " + pos + ")");
        }
    }
}
