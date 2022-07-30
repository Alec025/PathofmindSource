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

class WarningState extends FlxState
{
	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		// Mouse Activation
		FlxG.mouse.visible = false;

		super.create();
		// NOTE
		#if desktop
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Warning!"
			+ "\n\nThis Game Contains Jumpscares, Flashing Lights, Mentions  of Suicide"
			+ "\n\nand may not be suitable for all ages"
			+ "\n\nViewer discretion is advised"
			+ "\n\nPress Enter To Continue\n"
			+ "\nPress ESC To Exit",
			32);
		txt.setFormat("assets/fonts/Chivo", 50, 0xFFFF0000, CENTER);
		txt.screenCenter();
		add(txt);
		#end
		// if web
		#if html5
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Warning!"
			+ "\n\nThis Game Contains Jumpscares, Flashing Lights, Mentions of Suicide"
			+ "\n\nand may not be suitable for all ages"
			+ "\n\nViewer discretion is advised"
			+ "\n\nPress Enter To Continue\n",
			32);
		txt.setFormat("assets/fonts/Chivo", 50, 0xFFFF0000, CENTER);
		txt.antialiasing = true;
		txt.screenCenter();
		add(txt);
		#end
	}

	override public function update(elapsed:Float)
	{ // keys
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
		var pressedESC:Bool = FlxG.keys.justPressed.ESCAPE;

		// Controller
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			if (gamepad.justPressed.A)
				pressedESC = true;
			#end
		}

		if (pressedEnter)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new PlayState());
			});
		}
		if (pressedESC)
		{
			#if desktop
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Sys.exit(0);
			});
			#end
		}
		super.update(elapsed);
	}
}
