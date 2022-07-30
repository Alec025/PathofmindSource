package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class SettingsState extends FlxState
{
	#if desktop
	var fullscreenButton:FlxButton;
	#end

	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
