package messageformat;

class Literal
{
    public static function Format(expr:Dynamic, output:StringBuf, _:Map<String, Dynamic>, _:MessageFormat, pound:String):Void
    {
        var content:Array<String> = cast expr;

        for (c in content)
        {
            if ("" != c)
            {
                output.add(c);
            }
            else if ("" != pound)
            {
                output.add(pound);
            }
            else
            {
                output.add("#");
            }
        }
    }

    public static function Parse(input:StringReader, start:Int):Array<String>
    {
        var reader = new StringReader(input.substr(start, input.pos));
        var items = new Array<Int>();
        var escaped = false;
        var s = reader.pos;
        var e = s;
        var gap = 0;
        var pos = s;

        while (!reader.eof())
        {
            if (reader.isEscape())
            {
                ++gap;
                ++e;
                escaped = true;
            }
            else
            {
                if (reader.isOpen() || reader.isClose() || reader.isPound())
                {
                    if (escaped)
                    {
                        if (pos - s > gap)
                        {
                            if (gap > 1)
                            {
                                items.push(s);
                                items.push(pos);
                            }
                            else
                            {
                                items.push(s);
                                items.push(pos - 1);
                            }
                        }
                        s = pos;
                    }
                    else
                    {
                        if (s != e)
                        {
                            items.push(s);
                            items.push(e);
                            items.push(pos);
                            items.push(pos);
                        }
                        else if (s != pos)
                        {
                            items.push(s);
                            items.push(pos);
                            items.push(pos);
                            items.push(pos);
                        }
                        else
                        {
                            items.push(pos);
                            items.push(pos);
                        }
                        s = pos + 1;
                    }
                    e = s;
                }
                else
                {
                    ++e;
                }

                escaped = false;
                gap = 0;
            }

            reader.next();
            pos = reader.pos;
        }

        var end = reader.length;
        if (s < end)
        {
            items.push(s);
            items.push(end);
        }

        var result = new Array<String>();
        var i = 0;
        while (i < items.length)
        {
            result.push(reader.substr(items[i], items[i + 1]));
            i += 2;
        }
        return result;
    }
}
