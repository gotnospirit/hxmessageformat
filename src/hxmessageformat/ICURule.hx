package hxmessageformat;

typedef PluralFunction = Dynamic -> Bool -> String;

typedef Number = {
	// @see http://unicode.org/reports/tr35/tr35-numbers.html#Operands
	//
	// Symbol	Value
	// n	    absolute value of the source number (integer and decimals).
	// i	    integer digits of n.
	// v	    number of visible fraction digits in n, with trailing zeros.
	// w	    number of visible fraction digits in n, without trailing zeros.
	// f	    visible fractional digits in n, with trailing zeros.
	// t	    visible fractional digits in n, without trailing zeros.

    var f:Float;
    var i:Float;
    var n:Float;
    var v:Int;
    var t:Float;
    var w:Int;
};

class ICURule
{
    public static function Finvtw(value:Dynamic):Number
    {
        var result:Number = {
            f: 0,
            i: 0,
            n: 0.0,
            v: 0,
            t: 0,
            w: 0
        };

        var strValue:String = "";
        var floatValue:Float = 0.0;

        var pos:Int = 0;

        var intpart:Float = 0;
        var floatpart:Float = 0;

        var strInt:String = "";
        var strFloat:String = "";

        try
        {
            strValue = Std.string(value);
            floatValue = Utils.ParseFloat(strValue);

            if (Type.ValueType.TFloat == Type.typeof(value))
            {
                strValue = Utils.FixFloatString(Std.string(floatValue));
            }

            pos = strValue.indexOf(".");

            if (-1 == pos)
            {
                strInt = strValue;
                intpart = Utils.ParseFloat(strInt);

                result.n = intpart < 0 ? intpart * -1 : intpart;
            }
            else
            {
                strInt = strValue.substr(0, pos);
                strFloat = strValue.substr(pos + 1);

                intpart = Utils.ParseFloat(strInt);
                floatpart = Utils.ParseFloat(strFloat);

                result.n = floatValue < 0 ? floatValue * -1 : floatValue;
            }

            result.i = intpart;
            if (floatpart < 0)
            {
                result.f = floatpart * -1;
            }
            else
            {
                result.f = floatpart;
            }

            var offset = strFloat.length;
            result.v = offset;

            var i = offset - 1;
            while (i >= 0)
            {
                if ("0" == strFloat.charAt(i))
                {
                    --offset;
                }
                else
                {
                    break;
                }
                --i;
            }

            var strt = "";
            if (offset >= 1)
            {
                strt = strFloat.substr(0, offset);
            }

            if ("" != strt)
            {
                if (strFloat != strt)
                {
                    result.t = Utils.ParseInt(strt);
                    result.w = strt.length;
                }
                else
                {
                    result.t = result.f;
                    result.w = result.v;
                }
            }
        }
        catch (err:String)
        {
        }
        return result;
    }

    public static function Get(culture:String):PluralFunction
    {
        if ("en" != culture && "fr" != culture)
        {
            return null;
        }
        return function (value:Dynamic, ordinal:Bool):String
        {
            var n:Number = Finvtw(value);

            if ("en" == culture)
            {
                var n10:Float = n.n % 10;
                var n100:Float = n.n % 100;

                if (ordinal)
                {
                    if (1 == n10 && 11 != n100)
                    {
                        return "one";
                    }
                    else if (2 == n10 && 12 != n100)
                    {
                        return "two";
                    }
                    else if (3 == n10 && 13 != n100)
                    {
                        return "few";
                    }
                    return "other";
                }
                return (0 == n.v && 1 == n.i) ? "one" : "other";
            }
            else if ("fr" == culture)
            {
                if (ordinal)
                {
                    return (1 == n.n) ? "one" : "other";
                }
                return (0 == n.i || 1 == n.i) ? "one" : "other";
            }
            throw culture + " not defined.";
        };
    }
}
