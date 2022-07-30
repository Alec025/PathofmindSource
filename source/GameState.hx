package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxTimer;
import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.FontStyle;

class GameState extends FlxState
{
	var dialogue = [
		"it's difficult knowing each path leads to a certain consequence. Good or bad",
		"The mind has its path planted out",
		"What does one do when ones mind is jumbled",
		"Losing it",
		"Maybe it's time I finally find out"
	];
	var times:Int = 0;
	var entered:Int = 0;
	var txt:FlxText;

	override public function create()
	{
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.mouse.visible = false;

		txt = new FlxText(10, 10, dialogue[times]);
		txt.setFormat("assets/fonts/Chivo", 30, CENTER);
		txt.antialiasing = true;
		txt.screenCenter();
		add(txt);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var entered:Bool = FlxG.keys.justPressed.ENTER;

		if (times < 6)
		{
			if (entered)
			{
				txt.text = dialogue[times];
				times += 1;

				if (times == 6)
					FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
					{
						FlxG.switchState(new HomeState());
					});
			}
		}
	}
}
