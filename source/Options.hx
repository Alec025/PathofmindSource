package;

import cpp.Int16;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class Options extends FlxState
{
	public static var loadState:Int = 0;

	// Gameplay Settings
	public static var autoText:Bool = false;
	public static var textSpeedOptions:Int = 1;
	public static var textSizeOptions:Int = 1;
	public static var textSpeed:Float = .05;
	public static var autoTextSpeedOptions:Int = 1;
	public static var autoTextSpeed:Int = 10;
	public static var textSize:Int = 1;
	public static var gameplayMode:String = "Keyboard";
	public static var language:String = "en-US";

	public static var languageAdapt:String = "en-US";

	// Video Settings
	public static var fpsVisible:Bool = false;
	public static var displayModes:String = "Windowed";
	public static var resolution:Int = 0;
	public static var width:Int = 1280;
	public static var height:Int = 720;
	public static var lowQuality:Bool = false;
	public static var antialiasing:Bool = true;
	public static var animations = true;

	// Audio Settings
	public static var masterVol:Int = 10;
	public static var sfxVol:Int = 10;
	public static var musicVol:Int = 10;

	override public function create()
	{
		super.create();
	}

	function changeResolution()
	{
		FlxG.resizeGame(width, height);
		FlxG.resizeWindow(width, height);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (resolution)
		{
			case 0:
				width = 1280;
				height = 720;
				changeResolution();
			case 1:
				// width = 1336;
				// height = 768;
				FlxG.resizeGame(1336, 768);
				FlxG.resizeWindow(1336, 768);
			// changeResolution();
			case 2:
				width = 1600;
				height = 900;
				changeResolution();
			case 3:
				width = 1920;
				height = 1080;
				changeResolution();
			case 4:
				width = 2560;
				height = 1440;
				changeResolution();
			case 5:
				width = 3840;
				height = 2160;
				changeResolution();
			case 6:
				resolution -= 6;
		}
		/*FlxG.save.data.autoText = autoText;
			FlxG.save.data.textSpped = textSpeed;
			FlxG.save.data.textSize = textSize;
			FlxG.save.data.gameplaymode = gameplayMode; */
	}
}
