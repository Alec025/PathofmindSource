package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.text.Font;
import openfl.text.FontStyle;

class CreditsState extends FlxState
{
	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		super.create();

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Credits"
			+ "\n\nProgramer: Alec_025"
			+ "\n\nArtist:Alec_024 & ???"
			+ "\n\nPart of the HaxeJam 2022: Summer Jam"
			+ "\n\nPress ESC to return back to Main Menu",
			32);
		txt.setFormat("assets/fonts/Chivo", 50, CENTER);
		txt.antialiasing = true;
		txt.screenCenter();
		add(txt);
	}

	override public function update(elapsed:Float)
	{
		var pressedESC:Bool = FlxG.keys.justPressed.ESCAPE;

		// Controller
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedESC = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedESC = true;
			#end
		}

		if (pressedESC)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new PlayState());
			});
		};
		super.update(elapsed);
	}
}
