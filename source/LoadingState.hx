package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import lime.app.Application;

class LoadingState extends FlxState
{
	static var mainimagesToload:Array<String> = [];
	static var langimagesToload:Array<String> = [];
	static var musicToload:Array<String> = [];

	// static var library:Array<String> = [];

	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Options.lowQuality == true)
		{
			switch (Options.loadState)
			{
				case 0:
					// MainMenu
					mainimagesToload = ['MainGirl'];
					langimagesToload = ['PlayBTN', 'SettingsBTN', 'CreditsBTN', 'ExitBTN'];
			}
		}
	}
}
