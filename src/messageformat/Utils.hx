package messageformat;

class Utils
{
    static inline function ToFixed(value:Float, precision:Int):String
    {
        var power = Math.pow(10, precision);
        return Std.string(Math.fround(value * power) / power);
    }

    public static function FixFloatString(value:String):String
    {
        var pos = value.indexOf("e");
        if (-1 != pos)
        {
            var sign = value.substr(pos + 1, 1);
            var nzero:Int = Std.parseInt(value.substr(pos + 2));

            if ("+" == sign)
            {
                var result:String = value.substr(0, pos);
                var i:Int = 0;
                while (i++ < nzero)
                {
                    result += "0";
                }
                return result;
            }
            else if ("-" == sign)
            {
                var result:String = "0.";
                var i:Int = 0;
                --nzero;
                while (i++ < nzero)
                {
                    result += "0";
                }
                result += value.substr(0, pos);
                return result;
            }
            throw "Invalid notation";
        }
        return value;
    }

    public static inline function ParseInt(value:String):Int
    {
        var result = Std.parseInt(value);
        if (null == result)
        {
            throw value + " is NaN.";
        }
        return result;
    }

    public static inline function ParseFloat(value:String):Float
    {
        var result = Std.parseFloat(value);
        if (Math.isNaN(result))
        {
            throw value + " is NaN.";
        }

        var power = Math.pow(10, 8);
        return Math.fround(result * power) / power;
    }

    public static inline function MapToString(key:String, params:Map<String, Dynamic>):String
    {
        if (null == params || !params.exists(key))
        {
            return "";
        }
        return ToString(params.get(key));
    }

    public static function ToString(value:Dynamic):String
    {
        var type = Type.typeof(value);

        if (Std.is(value, String))
        {
            return value;
        }
        else if (Type.ValueType.TNull == type)
        {
            return "";
        }
        else if (Type.ValueType.TFloat == type)
        {
            return FixFloatString(ToFixed(value, 8));
        }
        // else if (Type.ValueType.TBool == type)
        // {
            // return value ? "true" : "false";
        // }
        else if (Type.ValueType.TInt == type)
        {
            return value + "";
        }
        else
        {
            throw "ToString: Unsupported type: " + type;
        }
        return "";
    }
}