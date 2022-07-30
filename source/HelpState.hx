package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import openfl.text.Font;
import openfl.text.FontStyle;

class HelpState extends FlxState
{
	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		// Mouse Activation
		FlxG.mouse.visible = false;

		super.create();
		// NOTE
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"If you are in need of help"
			+ "\n\nYou are not alone"
			+ "\n\nSuicide and Crisis Lifeline:"
			+ "\n988\n"
			+ "\nPress Enter To Continue", 32);
		txt.setFormat("assets/fonts/Chivo", 50, 0xFFFF0000, CENTER);
		txt.screenCenter();
		add(txt);
		#if switch
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"If you are in need of help"
			+ "\n\nYou are not alone"
			+ "\n\nSuicide and Crisis Lifeline:"
			+ "\n988\n"
			+ "\nPress B To Continue", 32);
		txt.setFormat("assets/fonts/Chivo", 50, 0xFFFF0000, CENTER);
		txt.screenCenter();
		add(txt);
		#end
	}

	override public function update(elapsed:Float)
	{ // keys
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		// Controller
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new PlayState());
			});
		}
		super.update(elapsed);
	}
}
