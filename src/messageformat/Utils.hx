package messageformat;

class Utils
{
    static function ToFixed(value:Float, precision:Int)
    {
        var power = Math.pow(10, precision);
        return Std.string(Math.round(value * power) / power);
    }

    public static function ToString(key:String, params:Map<String, Dynamic>)
    {
        if (!params.exists(key))
        {
            return "";
        }

        var value = params.get(key);
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
            return ToFixed(value, 8);
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