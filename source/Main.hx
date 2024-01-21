package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import lime.app.Application;
import lime.system.System;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(Options.width, Options.height, MainMenu));

		/*
			if (FlxG.save.data.FirstBoot != null) 
				{
					addChild(new FlxGame(Options.width, Options.height, FirstBoot));
				}
				else 
				{
					addChild(new FlxGame(Options.width, Options.height, MainMenu));
				}
		 */

		fpsCounter = new FPS(10, 10, 0xffffff);

		addChild(fpsCounter);
		toggleFPS(Options.fpsVisible);

		// if (FlxG.save.data.fpsload != null) {}

		#if desktop
		if (FlxG.save.data.fullscreen != null)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
		}
		#end
	}

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void
	{
		fpsCounter.visible = fpsEnabled;
	}
}
