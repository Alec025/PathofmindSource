package;

import cpp.Int16;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.system.Capabilities;

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
	public static var resolutionLimit:Int = 0;
	public static var gameWidth:Int = 1280;
	public static var gameHeight:Int = 720;
	public static var lowQuality:Bool = false;
	public static var antialiasing:Bool = true;
	public static var animations = true;
	// Video TMP Settings
	public static var fpsVisibleTMP:Bool = false;
	public static var displayModesTMP:String = "Windowed";
	// Video NRM Settings
	public static var fpsVisibleNRM:Bool = false;
	public static var displayModesNRM:String = "Windowed";

	public static var vidChange:Bool = false;
	public static var resetActivation:Bool = false;
	public static var acceptActivation:Bool = false;
	public static var resolutionAllowed:Bool = true;

	// Audio Settings
	public static var masterVol:Int = 10;
	public static var sfxVol:Int = 10;
	public static var musicVol:Int = 10;

	public static var controllerTrue = false;

	override public function create()
	{
		super.create();
	}

	function acceptDifference()
	{
		if (SettingsState.stateChange == 1)
		{
			if (fpsVisibleTMP != fpsVisible)
			{
				acceptActivation = true;
			}
		}
	}

	function resetDifference()
	{
		if (SettingsState.stateChange == 1)
		{
			if (fpsVisible != fpsVisibleNRM)
			{
				resetActivation = true;
			}
		}
	}

	public static function controller()
	{
		PopupMessage.stateUsed = "MovementChange";
		PopupMessage.options = ["Yes", "No"];
		PopupMessage.textforState = "Do you want to use 'Keyboard' instead?";
		PopupMessage.textSize = 40;
		PopupMessage.textArea = 550;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		/*FlxG.save.data.autoText = autoText;
			FlxG.save.data.textSpped = textSpeed;
			FlxG.save.data.textSize = textSize;
			FlxG.save.data.gameplaymode = gameplayMode; */
	}
}
