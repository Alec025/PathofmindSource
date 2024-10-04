package;

import Controls;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import lime.utils.Assets;
import openfl.text.Font;
import openfl.text.FontStyle;

using StringTools;

class WarningState extends FlxState
{
	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		// Mouse Activation
		FlxG.mouse.visible = false;
		FlxG.save.data.warningquestion = false;

		super.create();
		// NOTE for desktop
		#if desktop
		var txt:FlxText = new FlxText(0, 0, 1200, Assets.getText("assets/language/" + Options.language + "/data/WarningTXT.txt"), 32);
		txt.setFormat(AssetPaths.Chivo__ttf, 30, 0xFFFF0000, CENTER);
		txt.screenCenter();
		txt.antialiasing = Options.antialiasing;
		add(txt);
		#end
		// NOTE for web
		#if html5
		var txt:FlxText = new FlxText(0, 0, 1200, Assets.getText("assets/language/" + Options.language + "/data/WarningTXTWEB.txt"), 32);
		txt.setFormat(AssetPaths.Chivo__ttf, 30, 0xFFFF0000, CENTER);
		txt.antialiasing = Options.antialiasing;
		txt.screenCenter();
		add(txt);
		#end
	}

	override public function update(elapsed:Float)
	{ // keys
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
		var pressedESC:Bool = FlxG.keys.justPressed.ESCAPE;
		// makes warningquestion true
		if (pressedEnter)
		{
			FlxG.save.data.warningquestion = true;
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new MainMenu());
			});
		}
		// exits only on desktop
		#if desktop
		if (pressedESC)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Sys.exit(0);
			});
		}
		#end

		super.update(elapsed);
	}
}
