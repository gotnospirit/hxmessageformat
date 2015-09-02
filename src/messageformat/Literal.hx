package messageformat;

import haxe.Utf8;

class Literal
{
// func formatLiteral(expr Expression, ptr_output *bytes.Buffer, _ *map[string]interface{}, _ *MessageFormat, pound string) error {
	// content := expr.([]string)

	// for _, c := range content {
		// if "" != c {
			// ptr_output.WriteString(c)
		// } else if "" != pound {
			// ptr_output.WriteString(pound)
		// } else {
			// ptr_output.WriteRune(PoundChar)
		// }
	// }
	// return nil
// }

    public static function Format(expr:Dynamic, output:StringBuf, ?params:Map<String, String>)
    {
        var content:Array<String> = cast expr;

        for (c in content)
        {
            // trace(c);
            output.add(c);
        }
    }

    public static function Parse(reader:StringReader)
    {
        var items = new Array<Int>();
        var escaped = false;
        var s = reader.pos();
        var e = s;
        var gap = 0;
        var pos = s;

        while (reader.hasNext())
        {
            reader.next();

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

            ++pos;
        }

        var end = reader.length();
        if (s < end)
        {
            items.push(s);
            items.push(end);
        }

        var result = new Array<String>();
        {
            var i = 0;
            while (i < items.length)
            {
                var s = items[i];
                var e = items[i + 1];

                if (s != e)
                {
                    result.push(reader.substr(s, e));
                }
                i += 2;
            }
        }
        return result;
    }
}
