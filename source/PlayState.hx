package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.text.Font;
import openfl.text.FontStyle;

class PlayState extends FlxState
{
	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.mouse.visible = true;

		super.create();
		var text = new FlxText(20, 150, 0, "Path Of Mind");
		text.setFormat("assets/fonts/Chivo", 85);
		text.antialiasing = true;
		add(text);

		var playbtn = new FlxButton(30, 300, play);
		playbtn.loadGraphic("assets/images/MenuItems/PlayBTN.png", true, 43, 27);
		playbtn.animation.add("Play", [1, 2], 24, true);
		playbtn.antialiasing = true;
		playbtn.animation.play("Play");
		add(playbtn);

		var settingsbtn = new FlxButton(30, 330, setting);
		settingsbtn.loadGraphic("assets/images/MenuItems/SettingsBTN.png", true, 77, 27);
		settingsbtn.animation.add("Settings", [1, 2], 24, true);
		settingsbtn.antialiasing = true;
		settingsbtn.animation.play("Settings");
		add(settingsbtn);

		var creditsbtn = new FlxButton(30, 360, credit);
		creditsbtn.loadGraphic("assets/images/MenuItems/CreditsBTN.png", true, 68, 27);
		creditsbtn.animation.add("Credits", [1, 2], 24, true);
		creditsbtn.antialiasing = true;
		creditsbtn.animation.play("Credits");
		add(creditsbtn);

		#if desktop
		var exitbtn = new FlxButton(30, 390, end);
		exitbtn.loadGraphic("assets/images/MenuItems/ExitBTN.png", true, 38, 27);
		exitbtn.animation.add("Exit", [1, 2], 24, true);
		exitbtn.antialiasing = true;
		exitbtn.animation.play("Exit");
		add(exitbtn);
		#end
	}

	function play()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		{
			FlxG.switchState(new GameState());
		});
	}

	function setting()
	{
		trace("Works");
	}

	function credit()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		{
			FlxG.switchState(new CreditsState());
		});
	}

	#if desktop
	function end()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		{
			Sys.exit(0);
		});
	}
	#end

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
