package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.text.Font;
import openfl.text.FontStyle;

// This is usless don't use!
class UselessState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.switchState(new WarningState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
