package;

import Options;
import flixel.FlxBasic.IFlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.app.Application;
import openfl.Lib;
import openfl.display.FPS;
import openfl.system.Capabilities;
import sys.FileSystem;
import sys.io.File;

class VideoSettingState extends FlxState
{
	// Testing
	public static var fpsVisible = false;
	public static var displayModes = "Windowed";
	public static var fpsVisibleTMP = false;
	public static var displayModesTMP = "Windowed";

	public static var user = {name: "Mark", age: 31};

	var content:String = Json.stringify(user);
	var filePath:String = 'assets/NewFile.json';

	var vidTXT:Array<String> = [
		'Fps Shown:',
		'Display Mode:',
		'Resolution:',
		'Low Quality:',
		'Antialiasing:',
		'Animations:'
	];
	var vidOpts:Array<String> = [
		fpsVisible ? "On" : "Off",
		FlxG.fullscreen ? "Fullscreen" : "Windowed",
		Options.gameWidth + "x" + Options.gameHeight,
		Options.lowQuality ? "On" : "Off",
		Options.antialiasing ? "On" : "Off",
		Options.animations ? "On" : "Off"
	];
	var optBTN:Array<String> = ['Accept', 'Reset', 'Cancel'];

	var optSelection:Int = 0;
	var vidSelection:Int = 0;
	var controllerSwitch:Int = 0;

	var line:FlxSprite;

	public static var title:FlxText;

	var vidText:FlxText;
	var vidOptions:FlxText;
	var optText:FlxText;

	var vidTXTGroup:FlxTypedGroup<FlxText>;
	var optGroup:FlxTypedGroup<FlxText>;
	var vidOptGroup:FlxTypedGroup<FlxText>;

	var canClick:Bool = true;
	var usingMouse:Bool = false;

	override public function create()
	{
		super.create();

		File.saveContent('assets/NewFile.json', content);

		title = new FlxText(540, 420, "Video");
		title.setFormat(AssetPaths.Chivo__ttf, 50, FlxColor.WHITE, CENTER);
		title.alpha = 0;
		title.antialiasing = Options.antialiasing;
		add(title);

		line = new FlxSprite(610, 490);
		line.makeGraphic(3, 3, FlxColor.WHITE);
		line.alpha = 0;
		add(line);

		FlxTween.tween(title, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(line, {"scale.x": 200, alpha: 1}, 0.5, {ease: FlxEase.quadOut});

		vidOptGroup = new FlxTypedGroup<FlxText>();
		vidTXTGroup = new FlxTypedGroup<FlxText>();
		optGroup = new FlxTypedGroup<FlxText>();
		add(vidTXTGroup);
		add(optGroup);
		add(vidOptGroup);

		for (i in 0...optBTN.length)
		{
			optText = new FlxText(830, 550 + (i * 35), 0, optBTN[i]);
			optText.setFormat(AssetPaths.AnakCute__ttf, 30, FlxColor.GRAY, CENTER);
			optText.antialiasing = Options.antialiasing;
			optText.ID = i;
			optGroup.add(optText);
			optGroup.forEach(function(txt:FlxText)
			{
				txt.alpha = 0;
			});
		}

		for (i in 0...vidTXT.length)
		{
			vidText = new FlxText(400, 500 + (i * 35), 0, vidTXT[i]);
			vidText.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			vidText.antialiasing = Options.antialiasing;
			vidTXTGroup.add(vidText);
			vidTXTGroup.forEach(function(txt:FlxText)
			{
				txt.alpha = 0;
			});
		}

		for (i in 0...vidOpts.length)
		{
			vidOptions = new FlxText(600, 500 + (i * 35), 0, vidOpts[i]);
			vidOptions.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			vidOptions.antialiasing = Options.antialiasing;
			vidOptions.ID = i;
			vidOptGroup.add(vidOptions);
			vidOptGroup.forEach(function(txt:FlxText)
			{
				txt.alpha = 0;
			});
		}

		optGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		});
		vidOptGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		});
		vidTXTGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		});
	}

	function closing()
	{
		FlxTween.tween(title, {alpha: 0}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				FlxG.switchState(new SettingsState());
				SettingsState.selection = false;
				FlxTween.tween(SettingsState.brain, {y: 305}, 1, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(SettingsState.gameplayBTN, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
						FlxTween.tween(SettingsState.videoBTN, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
						FlxTween.tween(SettingsState.audioBTN, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
					}
				});
			}
		});
		FlxTween.tween(line, {"scale.x": 0, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		optGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		vidOptGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		vidTXTGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (FileSystem.exists(filePath))
			{
				FileSystem.deleteFile(filePath);
				trace('File deleted successfully');
			}
			else
			{
				trace('File does not exist');
			}
			closing();
		}

		if (fpsVisibleTMP != fpsVisible)
			Options.acceptActivation = true;
		if (displayModesTMP != displayModes)
			Options.acceptActivation = true;

		if (fpsVisible != Options.fpsVisibleNRM)
			Options.resetActivation = true;
		else
			Options.resetActivation = false;

		if (Options.displayModes != Options.displayModesNRM)
			Options.resetActivation = true;
		else
			Options.resetActivation = false;

		if (Options.fpsVisibleTMP == Options.fpsVisible)
			Options.acceptActivation = false;
		if (Options.displayModesTMP == Options.displayModes)
			Options.acceptActivation = false;

		optGroup.forEach(function(txt:FlxText)
		{
			if (usingMouse)
			{
				if (!FlxG.mouse.overlaps(txt))
					txt.setBorderStyle(NONE);
			}

			if (FlxG.mouse.overlaps(txt))
			{
				if (canClick)
				{
					optSelection = txt.ID;
					usingMouse = true;
					switch (optSelection)
					{
						case 0:
							if (Options.acceptActivation)
								txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
						case 1:
							if (Options.resetActivation)
								txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
						case 2:
							txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
					}
				}

				if (FlxG.mouse.justPressed && canClick)
				{
					switch (optSelection)
					{
						case 0:
							if (Options.acceptActivation == true)
							{
								fpsVisible = fpsVisibleTMP;
								displayModes = displayModesTMP;
							}
						case 1:
							if (Options.resetActivation == true)
							{
								// openSubState(new ResetSubState());
							}
						case 2:
							if (fpsVisibleTMP != Options.fpsVisible)
							{
								fpsVisibleTMP = !fpsVisibleTMP;
								(cast(Lib.current.getChildAt(0), Main)).toggleFPS(fpsVisibleTMP || fpsVisibleTMP);
								Options.acceptActivation = false;
							}
							if (displayModesTMP != displayModes)
							{
								if (FlxG.fullscreen)
								{
									FlxG.fullscreen = !FlxG.fullscreen;
									Options.acceptActivation = false;
									Options.resolutionAllowed = true;
									FlxG.resizeWindow(1280, 720);
									FlxG.resizeGame(1280, 720);
									Options.resolution = 0;
								}
								else
								{
									FlxG.fullscreen = !FlxG.fullscreen;
									Options.acceptActivation = false;
									Options.resolutionAllowed = false;
									FlxG.resizeWindow(Math.round(Capabilities.screenResolutionX), Math.round(Capabilities.screenResolutionY));
									FlxG.resizeGame(Math.round(Capabilities.screenResolutionX), Math.round(Capabilities.screenResolutionY));
									if (Math.round(Capabilities.screenResolutionX) == 1280)
										Options.resolution = 0;
									else if (Math.round(Capabilities.screenResolutionX) == 1336)
										Options.resolution = 1;
									else if (Math.round(Capabilities.screenResolutionX) == 1600)
										Options.resolution = 2;
									else if (Math.round(Capabilities.screenResolutionX) == 1920)
										Options.resolution = 3;
									else if (Math.round(Capabilities.screenResolutionX) == 2560)
										Options.resolution = 4;
									else if (Math.round(Capabilities.screenResolutionX) == 3840)
										Options.resolution = 5;
								}
							}
							closing();
					}
				}
			}
			optSelection = txt.ID;
			switch (optSelection)
			{
				case 0:
					if (Options.acceptActivation)
						txt.color = FlxColor.WHITE;
					else if (!Options.acceptActivation)
						txt.color = FlxColor.GRAY;
				case 1:
					if (Options.resetActivation)
						txt.color = FlxColor.WHITE;
					else if (!Options.resetActivation)
						txt.color = FlxColor.GRAY;
				case 2:
					txt.color = FlxColor.WHITE;
			}
		});

		vidOptGroup.forEach(function(txt:FlxText)
		{
			if (usingMouse)
			{
				if (!FlxG.mouse.overlaps(txt))
					txt.setBorderStyle(NONE);
			}

			if (FlxG.mouse.overlaps(txt))
			{
				if (canClick)
				{
					vidSelection = txt.ID;
					usingMouse = true;
					switch (vidSelection)
					{
						case 0 | 1 | 3 | 4 | 5:
							txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
						case 2:
							if (Options.resolutionAllowed)
								txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
					}
				}

				if (FlxG.mouse.justPressed && canClick)
				{
					switch (vidSelection)
					{
						case 0:
							Options.fpsVisibleTMP = !Options.fpsVisibleTMP;
							txt.text = Options.fpsVisibleTMP ? "On" : "Off";
								(cast(Lib.current.getChildAt(0), Main)).toggleFPS(Options.fpsVisibleTMP || Options.fpsVisibleTMP);
							trace(Options.acceptActivation);
						case 1:
							FlxG.fullscreen = !FlxG.fullscreen;
							txt.text = FlxG.fullscreen ? "Fullscreen" : "Windowed";
							Options.displayModesTMP = txt.text;
							trace("ORG: " + Options.displayModes);
							trace("TMP: " + Options.displayModesTMP);
							trace(Options.acceptActivation);
							if (FlxG.fullscreen)
							{
								Options.resolutionAllowed = false;
								FlxG.resizeWindow(Math.round(Capabilities.screenResolutionX), Math.round(Capabilities.screenResolutionY));
								FlxG.resizeGame(Math.round(Capabilities.screenResolutionX), Math.round(Capabilities.screenResolutionY));
								if (Math.round(Capabilities.screenResolutionX) == 1280)
									Options.resolution = 0;
								else if (Math.round(Capabilities.screenResolutionX) == 1336)
									Options.resolution = 1;
								else if (Math.round(Capabilities.screenResolutionX) == 1600)
									Options.resolution = 2;
								else if (Math.round(Capabilities.screenResolutionX) == 1920)
									Options.resolution = 3;
								else if (Math.round(Capabilities.screenResolutionX) == 2560)
									Options.resolution = 4;
								else if (Math.round(Capabilities.screenResolutionX) == 3840)
									Options.resolution = 5;
							}
							else
							{
								Options.resolutionAllowed = true;
								FlxG.resizeWindow(1280, 720);
								FlxG.resizeGame(1280, 720);
								Options.resolution = 0;
							}
						case 2:
							if (Options.resolutionAllowed)
							{
								Options.resolution += 1;
								trace(Options.gameWidth);
								trace(Options.gameHeight);
								FlxG.resizeWindow(Options.gameWidth, Options.gameHeight);
								FlxG.resizeGame(Options.gameWidth, Options.gameHeight);
								txt.text = Options.gameWidth + "x" + Options.gameHeight;
								trace(Options.resolution);
							}
						case 3:
							Options.lowQuality = !Options.lowQuality;
							txt.text = Options.lowQuality ? "On" : "Off";
							if (Options.lowQuality)
							{
								Options.antialiasing = false;
								Options.animations = false;
							}
						case 4:
							Options.antialiasing = !Options.antialiasing;
							txt.text = Options.antialiasing ? "On" : "Off";
						case 5:
							Options.animations = !Options.animations;
							txt.text = Options.animations ? "On" : "Off";
					}
				}
			}
			vidSelection = txt.ID;
			switch (vidSelection)
			{
				case 2:
					txt.text = Options.gameWidth + "x" + Options.gameHeight;
					if (Options.resolutionAllowed)
					{
						txt.color = FlxColor.WHITE;
					}
					else if (!Options.resolutionAllowed)
					{
						txt.color = FlxColor.GRAY;
					}
				case 3:
					if (Options.antialiasing && Options.animations)
					{
						Options.lowQuality = false;
						txt.text = Options.lowQuality ? "On" : "Off";
					}
					else if (!Options.antialiasing && !Options.animations)
					{
						Options.lowQuality = true;
						txt.text = Options.lowQuality ? "On" : "Off";
					}
				case 4:
					txt.text = Options.antialiasing ? "On" : "Off";
				case 5:
					txt.text = Options.animations ? "On" : "Off";
			}
		});
		switch (Options.resolution)
		{
			case 0:
				Options.gameWidth = 1280;
				Options.gameHeight = 720;
			case 1:
				Options.gameWidth = 1336;
				Options.gameHeight = 768;
			case 2:
				Options.gameWidth = 1600;
				Options.gameHeight = 900;
			case 3:
				Options.gameWidth = 1920;
				Options.gameHeight = 1080;
			case 4:
				Options.gameWidth = 2560;
				Options.gameHeight = 1440;
			case 5:
				Options.gameWidth = 3840;
				Options.gameHeight = 2160;
			case 6:
				Options.resolution -= 6;
		}
	}
}
