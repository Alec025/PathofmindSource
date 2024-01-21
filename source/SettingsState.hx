package;

import Options;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Lib;
import openfl.display.FPS;

class SettingsState extends FlxState
{
	// Bools
	public static var selection:Bool = false;

	// StateChanges
	var stateChange:Int = 0;

	// MAIN COMPONENTS
	public static var brain:FlxSprite;
	public static var gameplayBTN:FlxButton;
	public static var videoBTN:FlxButton;
	public static var audioBTN:FlxButton;

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		brain = new FlxSprite(338, 305).loadGraphic(AssetPaths.SettingBrain__png, 548, 286);
		brain.antialiasing = Options.antialiasing;
		add(brain);

		gameplayBTN = new FlxButton(100, 370, function gameplay()
		{
			stateChange = 0;
			substateChange();
		});
		gameplayBTN.loadGraphic("assets/language/" + Options.language + "/images/Settings/GameplayBTN.png", true, 144, 144);
		gameplayBTN.antialiasing = Options.antialiasing;

		videoBTN = new FlxButton(540, 120, function video()
		{
			stateChange = 1;
			substateChange();
		});
		videoBTN.loadGraphic("assets/language/" + Options.language + "/images/Settings/VideoBTN.png", true, 144, 144);
		videoBTN.antialiasing = Options.antialiasing;

		audioBTN = new FlxButton(1000, 370, function audio()
		{
			stateChange = 2;
			substateChange();
		});
		audioBTN.loadGraphic("assets/language/" + Options.language + "/images/Settings/AudioBTN.png", true, 144, 144);
		audioBTN.antialiasing = Options.antialiasing;
		add(gameplayBTN);
		add(videoBTN);
		add(audioBTN);

		super.create();
	}

	function refreshBTN()
	{
		gameplayBTN.loadGraphic("assets/language/" + Options.language + "/images/Settings/GameplayBTN.png", true, 144, 144);
		videoBTN.loadGraphic("assets/language/" + Options.language + "/images/Settings/VideoBTN.png", true, 144, 144);
		audioBTN.loadGraphic("assets/language/" + Options.language + "/images/Settings/AudioBTN.png", true, 144, 144);
	}

	function substateChange()
	{
		selection = true;

		FlxTween.tween(gameplayBTN, {alpha: 0}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(brain, {y: 100}, 1, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						switch (stateChange)
						{
							case 0:
								openSubState(new GMPlaySettings());
							case 1:
								openSubState(new VideoState());
							case 2:
								openSubState(new AudioState());
						}
					}
				});
			}
		});
		FlxTween.tween(videoBTN, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(audioBTN, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
	}

	/*#if desktop
		function fullscreenFCT()
		{
			FlxG.fullscreen = !FlxG.fullscreen;
			fullscreenBTN.text = FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED";
			FlxG.save.data.fullscreen = FlxG.fullscreen;
	}*/
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE && selection == false)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new MainMenu());
			});
		}
		if (Options.language != Options.languageAdapt)
		{
			refreshBTN();
		}
	}
}

class GMPlaySettings extends FlxSubState
{
	var textopts:Array<String> = ["AutoText:", "Text Speed:", "Text Size:", "Control Mode:", "Language:"];
	var options:Array<String> = [
		Options.autoText ? "On" : "Off",
		"" + Options.textSpeed,
		"x " + Options.textSize,
		"" + Options.gameplayMode,
		"" + Options.language
	];
	var optBTN:Array<String> = ['Accept', 'Reset', 'Cancel'];

	var optionSelect:Int = 0;
	var menuSelect:Int = 0;
	var controllerSwitch:Int = 0;

	var line:FlxSprite;

	public static var title:FlxText;

	var optsTXT:FlxText;
	var mainOptsTXT:FlxText;
	var menuTXT:FlxText;

	var canClick:Bool = true;
	var usingMouse:Bool = false;

	public static var txtGroup:FlxTypedGroup<FlxText>;
	public static var mainOpts:FlxTypedGroup<FlxText>;
	public static var menuOpts:FlxTypedGroup<FlxText>;

	override public function create()
	{
		super.create();

		title = new FlxText(500, 420, "Gameplay");
		title.setFormat(AssetPaths.Chivo__ttf, 50, FlxColor.WHITE, CENTER);
		title.alpha = 0;
		title.antialiasing = Options.antialiasing;
		add(title);

		line = new FlxSprite(610, 490);
		line.makeGraphic(3, 3, FlxColor.WHITE);
		line.alpha = 0;
		add(line);

		txtGroup = new FlxTypedGroup<FlxText>();
		mainOpts = new FlxTypedGroup<FlxText>();
		menuOpts = new FlxTypedGroup<FlxText>();
		add(txtGroup);
		add(mainOpts);
		add(menuOpts);

		for (i in 0...textopts.length)
		{
			mainOptsTXT = new FlxText(400, 500 + (i * 35), 0, textopts[i]);
			mainOptsTXT.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			mainOptsTXT.antialiasing = Options.antialiasing;
			mainOpts.add(mainOptsTXT);
			mainOpts.forEach(function(txt:FlxText)
			{
				txt.alpha = 0;
			});
		}

		for (i in 0...options.length)
		{
			optsTXT = new FlxText(600, 500 + (i * 35), 0, options[i]);
			optsTXT.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			optsTXT.antialiasing = Options.antialiasing;
			optsTXT.ID = i;
			txtGroup.add(optsTXT);
			txtGroup.forEach(function(txt:FlxText)
			{
				txt.alpha = 0;
			});

			switch (i)
			{
				case 1:
					if (Options.textSpeed == 0.05)
					{
						optsTXT.text = "Default";
					}
					else
					{
						optsTXT.text = "USER CHOICE(" + Options.textSpeed + ")";
					}
			}
		}

		for (i in 0...optBTN.length)
		{
			menuTXT = new FlxText(830, 550 + (i * 35), 0, optBTN[i]);
			menuTXT.setFormat(AssetPaths.AnakCute__ttf, 30, FlxColor.GRAY, CENTER);
			menuTXT.antialiasing = Options.antialiasing;
			menuTXT.ID = i;
			menuOpts.add(menuTXT);
			menuOpts.forEach(function(txt:FlxText)
			{
				txt.alpha = 0;
			});
		}

		mainOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		});
		txtGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		});
		menuOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		});

		// Beginning Animation
		FlxTween.tween(title, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(line, {"scale.x": 200, alpha: 1}, 0.5, {ease: FlxEase.quadOut});
	}

	function closing()
	{
		FlxTween.tween(title, {alpha: 0}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				close();
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
		mainOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		txtGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		menuOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
	}

	function canceled()
	{
		/*if (Options.autoTextTMP != Options.autoText
				|| Options.textSpeedTMP != Options.textSpeed
				|| Options.textSizeTMP != Options.textSize
				|| Options.gameplayModeTMP != Options.gameplayMode
				|| Options.languageTMP != Options.language)
			{
				Options.autoTextTMP = Options.autoText;
				Options.textSpeedTMP = Options.textSpeed;
				Options.textSizeTMP = Options.textSize;
				Options.gameplayModeTMP = Options.gameplayMode;
				Options.languageTMP = Options.language;
		}*/
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Close Animation
		if (FlxG.keys.justPressed.ESCAPE && Options.animations == true)
		{
			canceled();
			closing();
		}
		menuOpts.forEach(function(txt:FlxText)
		{
			/*if (Options.autoText != Options.autoTextRST
				|| Options.textSpeed != Options.textSpeedRST
				|| Options.textSize != Options.textSizeRST
				|| Options.gameplayMode != Options.gameplayModeRST
				|| Options.language != Options.languageRST) {} */
			if (Options.autoText != Options.autoText
				|| Options.textSpeed != Options.textSpeed
				|| Options.textSize != Options.textSize
				|| Options.gameplayMode != Options.gameplayMode
				|| Options.language != Options.language)
			{
				txt.setFormat(AssetPaths.AnakCute__ttf, 30, FlxColor.WHITE, CENTER);
				if (usingMouse)
				{
					if (!FlxG.mouse.overlaps(txt))
						txt.setBorderStyle(NONE);
				}

				if (FlxG.mouse.overlaps(txt))
				{
					if (canClick)
					{
						menuSelect = txt.ID;
						usingMouse = true;
						txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
					}

					if (FlxG.mouse.justPressed && canClick)
					{
						switch (optBTN[menuSelect])
						{
							case 'Accept':
							/*if (Options.autoTextTMP != Options.autoText
									|| Options.textSpeedTMP != Options.textSpeed
									|| Options.textSizeTMP != Options.textSize
									|| Options.gameplayModeTMP != Options.gameplayMode
									|| Options.languageTMP != Options.language)
								{
									Options.autoText = Options.autoTextTMP;
									Options.textSpeed = Options.textSpeedTMP;
									Options.textSize = Options.textSizeTMP;
									Options.gameplayMode = Options.gameplayModeTMP;
									Options.language = Options.languageTMP;
							}*/
							case 'Reset':
								/*if (Options.autoText != Options.autoTextRST
										|| Options.textSpeed != Options.textSpeedRST
										|| Options.textSize != Options.textSizeRST
										|| Options.gameplayMode != Options.gameplayModeRST
										|| Options.language != Options.languageRST)
									{
										Options.autoTextTMP = false;
										Options.autoText = false;
										Options.textSpeedTMP = 0.05;
										Options.textSpeed = 0.05;
										Options.textSizeTMP = 1;
										Options.textSize = 1;
										Options.gameplayModeTMP = "Keyboard";
										Options.gameplayMode = "Keyboard";
										Options.languageTMP = "en-US";
										Options.language = "en-US";
								}*/
								PopupMessage.stateUsed = "ResetSettings";
								PopupMessage.options = ["Yes", "No"];
								PopupMessage.textforState = "Are You Sure You Want To Reset?";
								PopupMessage.textSize = 40;
								PopupMessage.textArea = 550;
								openSubState(new PopupMessage());
							case 'Cancel':
								canceled();
								closing();
						}
					}
				}
			}
			else
			{
				txt.setFormat(AssetPaths.AnakCute__ttf, 30, FlxColor.GRAY, CENTER);
			}
		});

		txtGroup.forEach(function(txt:FlxText)
		{
			if (usingMouse)
			{
				if (!FlxG.mouse.overlaps(txt))
					txt.setBorderStyle(NONE);
			}

			if (FlxG.mouse.overlaps(txt))
			{
				/*if (Options.autoTextTMP != Options.autoText
						|| Options.textSpeedTMP != Options.textSpeed
						|| Options.textSizeTMP != Options.textSize
						|| Options.gameplayModeTMP != Options.gameplayMode
						|| Options.languageTMP != Options.language)
					{
						switch (optionSelect) {}
				}*/
				if (canClick)
				{
					optionSelect = txt.ID;
					usingMouse = true;
					txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
				}

				if (FlxG.mouse.justPressed && canClick)
				{
					switch (optionSelect)
					{
						case 0:
							Options.autoText = !Options.autoText;
							txt.text = Options.autoText ? "On" : "Off";
						// FlxG.switchState(new PlayState());
						case 1:
							openSubState(new TextSpeedClass());
						case 2:
							openSubState(new TextSizeClass());
						case 3:
							if (Options.gameplayMode == "Keyboard")
							{
								Options.gameplayMode = "Controller";
								txt.text = Options.gameplayMode;
								openSubState(new ControllerSelection());
							}
							else
							{
								Options.gameplayMode = "Keyboard";
								txt.text = Options.gameplayMode;
							}
						case 4:
							if (Options.language == "en-US")
							{
								Options.language = "es-US";
								txt.text = Options.language;
							}
							else
							{
								Options.language = "en-US";
								txt.text = Options.language;
							}
					}
				}
			}
		});
		/*else
			{
				{
					SettingsState.brain.y = 305;
					SettingsState.gameplayBTN.alpha = 1;
					SettingsState.videoBTN.alpha = 1;
					SettingsState.audioBTN.alpha = 1;
					close();
				}
		}*/
	}
}

class VideoState extends FlxSubState
{
	var vidTXT:Array<String> = [
		'Fps Shown:',
		'Display Mode:',
		'Resolution:',
		'Low Quality:',
		'Antialiasing:',
		'Animations:'
	];
	var vidOpts:Array<String> = [
		Options.fpsVisible ? "On" : "Off",
		FlxG.fullscreen ? "Fullscreen" : "Windowed",
		Options.width + "x" + Options.height,
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
				close();
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

		var keyESC = FlxG.keys.justPressed.ESCAPE;

		if (keyESC)
		{
			closing();
		}

		optGroup.forEach(function(txt:FlxText)
		{
			if (Options.fpsVisible != Options.fpsVisible
				|| Options.displayModes != Options.displayModes
				|| Options.resolution != Options.resolution
				|| Options.lowQuality != Options.lowQuality
				|| Options.antialiasing != Options.antialiasing
				|| Options.animations != Options.animations)
			{
				txt.setFormat(AssetPaths.AnakCute__ttf, 30, FlxColor.WHITE, CENTER);
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
						txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
					}

					if (FlxG.mouse.justPressed && canClick)
					{
						switch (optSelection)
						{
							case 0:
								Options.fpsVisible = Options.fpsVisible;
								(cast(Lib.current.getChildAt(0), Main)).toggleFPS(Options.fpsVisible || Options.fpsVisible);
								Options.displayModes = Options.displayModes;
								Options.resolution = Options.resolution;
								Options.lowQuality = Options.lowQuality;
								Options.antialiasing = Options.antialiasing;
								Options.animations = Options.animations;
							case 1:
								openSubState(new ResetSubState());
							case 2:
						}
					}
				}
			}
			else
			{
				txt.setFormat(AssetPaths.AnakCute__ttf, 30, FlxColor.GRAY, CENTER);
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
					txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
				}

				if (FlxG.mouse.justPressed && canClick)
				{
					switch (vidSelection)
					{
						case 0:
							Options.fpsVisible = !Options.fpsVisible;
							txt.text = Options.fpsVisible ? "On" : "Off";
								(cast(Lib.current.getChildAt(0), Main)).toggleFPS(Options.fpsVisible || Options.fpsVisible);
						case 1:
							FlxG.fullscreen = !FlxG.fullscreen;
							txt.text = FlxG.fullscreen ? "Fullscreen" : "Windowed";
							Options.displayModes = txt.text;
						case 2:
							Options.resolution += 1;
							txt.text = Options.width + "x" + Options.height;
							trace(FlxG.width);
							trace(FlxG.height);
							trace(Options.resolution);
						case 3:
							Options.lowQuality = !Options.lowQuality;
							txt.text = Options.lowQuality ? "On" : "Off";
						case 4:
							Options.antialiasing = !Options.antialiasing;
							txt.text = Options.antialiasing ? "On" : "Off";
						case 5:
							Options.animations = !Options.animations;
							txt.text = Options.animations ? "On" : "Off";
					}
				}
			}
		});
	}
}

class AudioState extends FlxSubState
{
	public static var title:FlxText;
	public static var line:FlxSprite;

	var audTXT:Array<String> = ['Master Volume:', 'SFX Volume:', 'Music Volume:'];
	var audOpts:Array<String> = ["" + Options.masterVol, "" + Options.sfxVol, "" + Options.musicVol];
	var audSelection:Int = 0;
	var audText:FlxText;
	var audOptions:FlxText;
	var audOptGroup:FlxTypedGroup<FlxText>;
	var audTXTGroup:FlxTypedGroup<FlxText>;

	override public function create()
	{
		super.create();

		title = new FlxText(530, 420, "Audio");
		title.setFormat(AssetPaths.Chivo__ttf, 50, FlxColor.WHITE, CENTER);
		title.alpha = 0;
		title.antialiasing = true;
		add(title);

		line = new FlxSprite(610, 490);
		line.makeGraphic(3, 3, FlxColor.WHITE);
		line.alpha = 0;
		add(line);

		FlxTween.tween(title, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(line, {"scale.x": 200, alpha: 1}, 0.5, {ease: FlxEase.quadOut});

		audOptGroup = new FlxTypedGroup<FlxText>();
		audTXTGroup = new FlxTypedGroup<FlxText>();
		add(audTXTGroup);
		add(audOptGroup);

		for (i in 0...audTXT.length)
		{
			audText = new FlxText(400, 500 + (i * 35), 0, audTXT[i]);
			audText.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			audText.antialiasing = Options.antialiasing;
			audText.ID = i;
			audTXTGroup.add(audText);
		}

		for (i in 0...audOpts.length)
		{
			audOptions = new FlxText(600, 500 + (i * 35), 0, audOpts[i]);
			audOptions.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			audOptions.antialiasing = Options.antialiasing;
			audOptions.ID = i;
			audOptGroup.add(audOptions);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var keyESC = FlxG.keys.justPressed.ESCAPE;

		if (keyESC)
		{
			FlxTween.tween(title, {alpha: 0}, 0.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					close();
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
		}
	}
}

class ResetSubState extends FlxSubState
{
	var resetopts:Array<String> = ['Yes', 'No'];
	var resetselec:Int = 0;
	var txtGroup:FlxTypedGroup<FlxText>;
	var optsTXT:FlxText;
	var canClick:Bool = true;
	var usingMouse:Bool = false;

	var bg:FlxSprite;
	var text:FlxText;

	override public function create()
	{
		super.create();

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			bg.animation.pause();
		}, 1);

		bg = new FlxSprite(400, 300);
		bg.frames = FlxAtlasFrames.fromSparrow(AssetPaths.BG__png, AssetPaths.BG__xml);
		bg.animation.addByPrefix('Idle', 'BG', 24);
		bg.animation.play('Idle');
		add(bg);

		txtGroup = new FlxTypedGroup<FlxText>();
		add(txtGroup);

		text = new FlxText(400, 350, 498, "Are You Sure You Want To Reset?");
		text.antialiasing = Options.antialiasing;
		text.setFormat(AssetPaths.AnakCute__ttf, 40, FlxColor.WHITE, CENTER);
		add(text);

		for (i in 0...resetopts.length)
		{
			optsTXT = new FlxText(530 + (i * 150), 420, 0, resetopts[i]);
			optsTXT.antialiasing = Options.antialiasing;
			optsTXT.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			optsTXT.ID = i;
			txtGroup.add(optsTXT);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(text, {alpha: 0}, 0.3, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					bg.animation.resume();
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						close();
					});
				}
			});
			txtGroup.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});

				if (resetselec != txt.ID)
				{
					FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				}
			});
		}

		txtGroup.forEach(function(txt:FlxText)
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
					resetselec = txt.ID;
					usingMouse = true;
					txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
				}

				if (FlxG.mouse.pressed && canClick)
				{
					switch (resetopts[resetselec])
					{
						case 'Yes':

						case 'No':
							FlxTween.tween(text, {alpha: 0}, 0.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									bg.animation.resume();
									new FlxTimer().start(0.2, function(tmr:FlxTimer)
									{
										close();
									});
								}
							});
							FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
							// Affects the unselected options
							txtGroup.forEach(function(txt:FlxText)
							{
								if (resetselec != txt.ID)
								{
									FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
								}
							});
					}
				}
			}
		});
	}
}

class TextSpeedClass extends FlxSubState
{
	var speedOPTS:Array<String> = ['Replay', 'Accept', 'Reset', 'Cancel'];

	var bar:FlxSprite;
	var bg:FlxSprite;
	var pls:FlxButton;
	var min:FlxButton;
	var switchStateLEFT:FlxButton;
	var switchStateRIGHT:FlxButton;
	var switchedState:Bool = false;
	var allowed:Bool = true;

	public static var promptAccepted:Bool = false;

	public static var testTXT:FlxTypeText;

	override public function create()
	{
		super.create();

		bar = new FlxSprite(460, 410);
		bar.frames = FlxAtlasFrames.fromSparrow(AssetPaths.level__png, AssetPaths.level__xml);
		bar.scale.set(1.5, 1);
		bar.alpha = 0;
		bar.animation.addByPrefix("Normal", "Zero");
		bar.animation.addByPrefix("One", "LevelOne");
		bar.animation.addByPrefix("Two", "LevelTwo");
		bar.animation.addByPrefix("Three", "LevelThree");
		bar.animation.addByPrefix("Four", "LevelFour");
		bar.animation.addByPrefix("Five", "LevelFive");
		bar.animation.addByPrefix("Six", "LevelSix");
		bar.animation.addByPrefix("Seven", "LevelSeven");
		bar.animation.addByPrefix("Eight", "LevelEight");
		add(bar);

		bg = new FlxSprite(360, 500);
		bg.frames = FlxAtlasFrames.fromSparrow(AssetPaths.BG__png, AssetPaths.BG__xml);
		bg.scale.set(1.5, 1);
		bg.alpha = 0;
		bg.animation.addByPrefix('Idle', 'TextBox', 0);
		bg.animation.play('Idle');
		add(bg);

		testTXT = new FlxTypeText(300, 550, 1280, "Text Will Type This Fast || Speed is " + Options.textSpeed);
		testTXT.setFormat(AssetPaths.ARIAL__TTF, 30, FlxColor.WHITE);
		testTXT.showCursor = true;
		testTXT.alpha = 0;
		testTXT.cursorBlinkSpeed = 1;
		add(testTXT);

		pls = new FlxButton(880, 430, "+", function plus()
		{
			if (Options.textSpeedOptions >= 9 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Proceed", "Cancel"];
				PopupMessage.textforState = "Going Above The Allowed Amount May Break The Game Are you Sure?";
				PopupMessage.textSize = 32;
				PopupMessage.textSpeedOutput = "Add";
				PopupMessage.textArea = 530;
				openSubState(new PopupMessage());
			}
			else
			{
				adds();
			}
		});
		pls.loadGraphic(AssetPaths.Arrow__png);
		pls.color = 0xffCCCCCC;
		pls.alpha = 0;
		pls.flipX = true;
		add(pls);

		min = new FlxButton(320, 430, "-", function subtract()
		{
			if (Options.textSpeedOptions <= 1 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Cancel"];
				PopupMessage.textforState = "You Can Not Go Further Than (0.05) For Text Speed";
				PopupMessage.textSize = 30;
				PopupMessage.textSpeedOutput = "Subtract";
				PopupMessage.textArea = 610;
				openSubState(new PopupMessage());
			}
			else
			{
				subs();
			}
		});
		min.loadGraphic(AssetPaths.Arrow__png);
		min.color = 0xffCCCCCC;
		min.alpha = 0;
		add(min);

		FlxTween.tween(GMPlaySettings.title, {alpha: 0, y: 430}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(bar, {alpha: 1, y: 400}, 0.3, {ease: FlxEase.quadOut});
				FlxTween.tween(testTXT, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(bg, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(pls, {alpha: 1, y: 405}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(min, {alpha: 1, y: 405}, 0.5, {ease: FlxEase.quadOut});
				testTXT.start(Options.textSpeed);
			}
		});
		GMPlaySettings.mainOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		GMPlaySettings.txtGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		GMPlaySettings.menuOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
	}

	function delete():Void
	{
		testTXT.erase(0.01, false, null, function name()
		{
			testTXT.resetText("Text Will Type This Fast || Speed is " + Options.textSpeed);
			testTXT.start(Options.textSpeed);
		});
	}

	function adds()
	{
		Options.textSpeedOptions += 1;
		Options.textSpeed += .05;
		delete();
		trace(Options.textSpeed);
	}

	function subs()
	{
		Options.textSpeedOptions -= 1;
		Options.textSpeed -= .05;
		delete();
		trace(Options.textSpeed);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
		{
			if (Options.textSpeedOptions >= 9 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Proceed", "Cancel"];
				PopupMessage.textforState = "Going Above The Allowed Amount May Break The Game Are you Sure?";
				PopupMessage.textSize = 32;
				PopupMessage.textSpeedOutput = "Add";
				PopupMessage.textArea = 530;
				openSubState(new PopupMessage());
			}
			else
			{
				adds();
			}
		}
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
		{
			if (Options.textSpeedOptions <= 1 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Cancel"];
				PopupMessage.textforState = "You Can Not Go Further Than (0.05) For Text Speed";
				PopupMessage.textSize = 30;
				PopupMessage.textSpeedOutput = "Subtract";
				PopupMessage.textArea = 610;
				openSubState(new PopupMessage());
			}
			else
			{
				subs();
			}
		}
		if (FlxG.keys.justPressed.ESCAPE && Options.animations == true)
		{
			FlxTween.tween(bar, {alpha: 0, y: 410}, 0.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(GMPlaySettings.title, {alpha: 1, y: 420}, 0.5, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							close();
						}
					});
				}
			});
			FlxTween.tween(testTXT, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(bg, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(pls, {alpha: 0, y: 430}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(min, {alpha: 0, y: 430}, 0.5, {ease: FlxEase.quadOut});
			GMPlaySettings.mainOpts.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
			GMPlaySettings.txtGroup.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
			GMPlaySettings.menuOpts.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
		}

		switch (Options.textSpeedOptions)
		{
			case 1:
				bar.animation.play("Normal");
			case 2:
				bar.animation.play("One");
			case 3:
				bar.animation.play("Two");
			case 4:
				bar.animation.play("Three");
			case 5:
				bar.animation.play("Four");
			case 6:
				bar.animation.play("Five");
			case 7:
				bar.animation.play("Six");
			case 8:
				bar.animation.play("Seven");
			case 9:
				bar.animation.play("Eight");
		}

		super.update(elapsed);
	}
}

class TextSizeClass extends FlxSubState
{
	var speedOPTS:Array<String> = ['Replay', 'Accept', 'Reset', 'Cancel'];

	var bar:FlxSprite;
	var bg:FlxSprite;
	var pls:FlxButton;
	var min:FlxButton;
	var switchStateLEFT:FlxButton;
	var switchStateRIGHT:FlxButton;
	var switchedState:Bool = false;
	var allowed:Bool = true;

	public static var promptAccepted:Bool = false;

	public static var testTXT:FlxTypeText;

	override public function create()
	{
		super.create();

		bar = new FlxSprite(460, 410);
		bar.frames = FlxAtlasFrames.fromSparrow(AssetPaths.level__png, AssetPaths.level__xml);
		bar.scale.set(1.5, 1);
		bar.alpha = 0;
		bar.animation.addByPrefix("Normal", "Zero");
		bar.animation.addByPrefix("One", "LevelOne");
		bar.animation.addByPrefix("Two", "LevelTwo");
		bar.animation.addByPrefix("Three", "LevelThree");
		bar.animation.addByPrefix("Four", "LevelFour");
		bar.animation.addByPrefix("Five", "LevelFive");
		bar.animation.addByPrefix("Six", "LevelSix");
		bar.animation.addByPrefix("Seven", "LevelSeven");
		bar.animation.addByPrefix("Eight", "LevelEight");
		add(bar);

		bg = new FlxSprite(360, 500);
		bg.frames = FlxAtlasFrames.fromSparrow(AssetPaths.BG__png, AssetPaths.BG__xml);
		bg.scale.set(1.5, 1);
		bg.alpha = 0;
		bg.animation.addByPrefix('Idle', 'TextBox', 0);
		bg.animation.play('Idle');
		add(bg);

		testTXT = new FlxTypeText(300, 550, 1280, "SAMPLE SIZE || Size is " + Options.textSize, 1 * Options.textSize);
		testTXT.setFormat(AssetPaths.ARIAL__TTF, 30, FlxColor.WHITE);
		testTXT.showCursor = true;
		testTXT.alpha = 0;
		testTXT.cursorBlinkSpeed = 1;
		add(testTXT);

		pls = new FlxButton(880, 430, "+", function plus()
		{
			if (Options.textSpeedOptions >= 9 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Proceed", "Cancel"];
				PopupMessage.textforState = "Going Above The Allowed Amount May Break The Game Are you Sure?";
				PopupMessage.textSize = 32;
				PopupMessage.textSpeedOutput = "Add";
				PopupMessage.textArea = 530;
				openSubState(new PopupMessage());
			}
			else
			{
				adds();
			}
		});
		pls.loadGraphic(AssetPaths.Arrow__png);
		pls.color = 0xffCCCCCC;
		pls.alpha = 0;
		pls.flipX = true;
		add(pls);

		min = new FlxButton(320, 430, "-", function subtract()
		{
			if (Options.textSpeedOptions <= 1 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Cancel"];
				PopupMessage.textforState = "You Can Not Go Further Than (0.05) For Text Size";
				PopupMessage.textSize = 30;
				PopupMessage.textSpeedOutput = "Subtract";
				PopupMessage.textArea = 610;
				openSubState(new PopupMessage());
			}
			else
			{
				subs();
			}
		});
		min.loadGraphic(AssetPaths.Arrow__png);
		min.color = 0xffCCCCCC;
		min.alpha = 0;
		add(min);

		FlxTween.tween(GMPlaySettings.title, {alpha: 0, y: 430}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(bar, {alpha: 1, y: 400}, 0.3, {ease: FlxEase.quadOut});
				FlxTween.tween(testTXT, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(bg, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(pls, {alpha: 1, y: 405}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(min, {alpha: 1, y: 405}, 0.5, {ease: FlxEase.quadOut});
				testTXT.start(Options.textSpeed);
			}
		});
		GMPlaySettings.mainOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		GMPlaySettings.txtGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		GMPlaySettings.menuOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
	}

	function delete():Void
	{
		testTXT.erase(0.01, false, null, function name()
		{
			testTXT.resetText("Sample Text || Size is " + Options.textSize);
			testTXT.start(Options.textSpeed);
		});
	}

	function adds()
	{
		Options.textSizeOptions += 1;
		Options.textSize += 1;
		delete();
		trace(Options.textSize);
	}

	function subs()
	{
		Options.textSizeOptions -= 1;
		Options.textSize -= 1;
		delete();
		trace(Options.textSize);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
		{
			if (Options.textSizeOptions >= 9 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Proceed", "Cancel"];
				PopupMessage.textforState = "Going Above The Allowed Amount May Break The Game Are you Sure?";
				PopupMessage.textSize = 32;
				PopupMessage.textSpeedOutput = "Add";
				PopupMessage.textArea = 530;
				openSubState(new PopupMessage());
			}
			else
			{
				adds();
			}
		}
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
		{
			if (Options.textSpeedOptions <= -1 && promptAccepted == false)
			{
				PopupMessage.stateUsed = "TextSpeedOverDrive";
				PopupMessage.options = ["Cancel"];
				PopupMessage.textforState = "You Can Not Go Further Than -1 For Text Size";
				PopupMessage.textSize = 30;
				PopupMessage.textSpeedOutput = "Subtract";
				PopupMessage.textArea = 610;
				openSubState(new PopupMessage());
			}
			else
			{
				subs();
			}
		}
		if (FlxG.keys.justPressed.ESCAPE && Options.animations == true)
		{
			FlxTween.tween(bar, {alpha: 0, y: 410}, 0.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(GMPlaySettings.title, {alpha: 1, y: 420}, 0.5, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							close();
						}
					});
				}
			});
			FlxTween.tween(testTXT, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(bg, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(pls, {alpha: 0, y: 430}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(min, {alpha: 0, y: 430}, 0.5, {ease: FlxEase.quadOut});
			GMPlaySettings.mainOpts.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
			GMPlaySettings.txtGroup.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
			GMPlaySettings.menuOpts.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
		}

		switch (Options.textSpeed)
		{
			case 1:
				bar.animation.play("Normal");
			case 2:
				bar.animation.play("One");
			case 3:
				bar.animation.play("Two");
			case 4:
				bar.animation.play("Three");
			case 5:
				bar.animation.play("Four");
			case 6:
				bar.animation.play("Five");
			case 7:
				bar.animation.play("Six");
			case 8:
				bar.animation.play("Seven");
			case 9:
				bar.animation.play("Eight");
		}

		super.update(elapsed);
	}
}

class ControllerSelection extends FlxSubState
{
	var ps4:FlxButton;
	var xbox:FlxButton;

	var title:FlxText;

	override public function create()
	{
		super.create();

		title = new FlxText(380, 430, "Controller Selection");
		title.setFormat(AssetPaths.Chivo__ttf, 50, FlxColor.WHITE, CENTER);
		title.alpha = 0;
		title.antialiasing = Options.antialiasing;
		add(title);

		ps4 = new FlxButton(0, 0, "Playstation Controller");
		add(ps4);

		xbox = new FlxButton(0, 40, "Xbox Controller");
		add(xbox);

		FlxTween.tween(GMPlaySettings.title, {alpha: 0, y: 430}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(title, {alpha: 1, y: 420}, 0.5, {ease: FlxEase.quadOut});
			}
		});
		GMPlaySettings.mainOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		GMPlaySettings.txtGroup.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
		GMPlaySettings.menuOpts.forEach(function(txt:FlxText)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(title, {alpha: 0, y: 430}, 0.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(GMPlaySettings.title, {alpha: 1, y: 420}, 0.5, {ease: FlxEase.quadOut});
					close();
				}
			});
			GMPlaySettings.mainOpts.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
			GMPlaySettings.txtGroup.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
			GMPlaySettings.menuOpts.forEach(function(txt:FlxText)
			{
				FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			});
		}
	}
}
