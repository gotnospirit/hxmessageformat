package;

class Main
{
	static public function main():Void
    {
        new TestFormat().run();
        new TestICUNamedKey().run();
        new TestICUFinvtw().run();
        new TestUtilsMapToString().run();
        new TestUtilsParseInt().run();
        new TestUtilsParseFloat().run();
        // new TestStringReader().run();
	}
}