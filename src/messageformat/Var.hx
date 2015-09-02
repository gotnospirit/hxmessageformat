package messageformat;

import haxe.Utf8;

class Var
{
// func formatVar(expr Expression, ptr_output *bytes.Buffer, data *map[string]interface{}, _ *MessageFormat, _ string) error {
	// value, err := toString(*data, expr.(string))
	// if nil != err {
		// return err
	// }
	// ptr_output.WriteString(value)
	// return nil
// }

    public static function Format(expr:Dynamic, output:StringBuf, ?params:Map<String, String>)
    {
    }

    public static function Parse(reader:StringReader)
    {
        reader.whitespace();
        var fc_pos = reader.pos();
        var lc_pos = fc_pos;

        while (!reader.eof())
        {
// reader.debug("> ");
            if (reader.isOpen())
            {
                throw "InvalidExpr";
            }
            else if (reader.isPart() || reader.isClose())
            {
                return reader.substr(fc_pos, lc_pos);
            }
            else if (reader.isWhitespace())
            {
                reader.next();
                reader.whitespace();
            }
            else if ((!reader.isUnderscore() && !reader.isAlphaNumeric()) || (reader.pos() != lc_pos))
            {
                throw "InvalidFormat";
            }

            reader.next();
            lc_pos = reader.pos();
        }
        throw "UnbalancedBraces";
    }

// func readVar(start, end int, ptr_input *[]rune) (string, rune, int, error) {
	// char, pos := whitespace(start, end, ptr_input)
	// fc_pos, lc_pos := pos, pos
	// input := *ptr_input

	// for pos < end {
		// switch char {
		// default:
			// [_0-9a-zA-Z]+
			// if '_' != char && (char < '0' || char > '9') && (char < 'A' || char > 'Z') && (char < 'a' || char > 'z') {
				// return "", char, pos, errors.New("InvalidFormat")
			// } else if pos != lc_pos { // non continu (inner whitespace)
				// return "", char, pos, errors.New("InvalidFormat")
			// }

			// lc_pos = pos + 1

			// pos++

			// if pos < end {
				// char = input[pos]
			// }

		// case ' ', '\r', '\n', '\t':
			// char, pos = whitespace(pos+1, end, ptr_input)

		// case PartChar, CloseChar:
			// return string(input[fc_pos:lc_pos]), char, pos, nil

		// case OpenChar:
			// return "", char, pos, errors.New("InvalidExpr")
		// }
	// }
	// return "", char, pos, errors.New("UnbalancedBraces")
// }

}
