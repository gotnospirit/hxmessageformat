package messageformat;

import haxe.Utf8;

class Parser
{
	public function new()
    {
    }

    public function parse(str:String)
    {
        var root = new Node();
        var reader = new StringReader(str);

        while (_parse(reader, root))
        {}

        var result = new MessageFormat(root);
        result.set("literal", Literal.Format);
        result.set("var", Var.Format);
        return result;
    }

    function _parseExpression(reader:StringReader, parent:Node)
    {
        var name = Var.Parse(reader);
        if ("" == name)
        {
            throw "MissingVarName";
        }
        else if (reader.isClose())
        {
            parent.add("var", name);
            return ;
        }

        trace("name: " + name);
        trace(reader.isClose());
    }

// func (x *Parser) parseExpression(start, end int, ptr_input *[]rune) (string, Expression, int, error) {
	// varname, char, pos, err := readVar(start, end, ptr_input)
	// if nil != err {
		// return "", nil, pos, err
	// } else if "" == varname {
		// return "", nil, pos, fmt.Errorf("MissingVarName")
	// } else if CloseChar == char {
		// return "var", varname, pos, nil
	// }

	// ctype, char, pos, err := readVar(pos+1, end, ptr_input)
	// if nil != err {
		// return "", nil, pos, err
	// }

	// fn, ok := x.parsers[ctype]
	// if !ok {
		// return "", nil, pos, fmt.Errorf("UnknownType: `%s`", ctype)
	// } else if nil == fn {
		// return "", nil, pos, fmt.Errorf("UndefinedParseFunc: `%s`", ctype)
	// }

	// expr, pos, err := fn(varname, x, char, pos, end, ptr_input)
	// if nil != err {
		// return "", nil, pos, err
	// }

	// if pos >= end || CloseChar != (*ptr_input)[pos] {
		// return "", nil, pos, fmt.Errorf("UnbalancedBraces")
	// }
	// return ctype, expr, pos, nil
// }

    function _parse(reader:StringReader, parent:Node)
    {
        var start = reader.pos();
        var pos = start;
        var level = 0;
        var escaped = false;

        while (reader.hasNext())
        {
            // var char = reader.next();
            reader.next();

            if (reader.isEscape())
            {
                escaped = true;
            }
            else if (reader.isOpen())
            {
                if (!escaped)
                {
                    ++level;

                    if (pos > start)
                    {
                        // trace("ADD LITERAL 1");
                        parent.add("literal", Literal.Parse(reader.slice(start)));
                    }

                    // consume {
                    reader.next();

                    _parseExpression(reader, parent);

                    --level;

                    pos = reader.pos();
                    start = pos + 1;
                }

                escaped = false;
            }
            else if (reader.isClose())
            {
                if (!escaped)
                {
                    --level;
                    break;
                }
                escaped = false;
            }
            else
            {
                // reader.debug();

                escaped = false;
            }

            ++pos;
        }

        if (pos > start)
        {
            // trace("ADD LITERAL 2");
            parent.add("literal", Literal.Parse(reader.slice(start)));
        }
        return reader.hasNext();
    }
}
