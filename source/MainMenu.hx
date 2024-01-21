package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.utils.Assets;

class MainMenu extends FlxState
{
	#if desktop
	var mainmenuopts:Array<String> = ['Play', 'Settings', 'Credits', 'Exit'];
	#else
	var mainmenuopts:Array<String> = ['Play', 'Settings', 'Credits'];
	#end
	var optionSelect:Int = 0;
	var txtGroup:FlxTypedGroup<FlxText>;
	var optsTXT:FlxText;
	var canClick:Bool = true;
	var usingMouse:Bool = false;

	var title:FlxText;

	public static var mainGRL:FlxSprite;

	// functions
	override public function create()
	{
		// Camera & Mouse OPTIONS
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		// Assets
		super.create();
		// Title
		title = new FlxText(80, 150, 0, "Path Of Mind");
		title.setFormat(AssetPaths.AnakCute__ttf, 140);
		title.antialiasing = Options.antialiasing;
		add(title);
		// MainGrlImage
		mainGRL = new FlxSprite(700, 128);
		mainGRL.frames = FlxAtlasFrames.fromSparrow(AssetPaths.MainGirl__png, AssetPaths.MainGirl__xml);
		mainGRL.animation.addByPrefix("Idle", "MainMenu_Idle", 18, true);
		mainGRL.updateHitbox();
		mainGRL.animation.play("Idle");
		mainGRL.antialiasing = Options.antialiasing;
		add(mainGRL);
		// Version
		var version:FlxText = new FlxText(1160, 690, "Version:" + Application.current.meta.get('version'));
		version.setFormat(AssetPaths.Chivo__ttf, 20);
		version.antialiasing = Options.antialiasing;
		add(version);
		// Components creating buttons in mainmenu
		txtGroup = new FlxTypedGroup<FlxText>();
		add(txtGroup);

		for (i in 0...mainmenuopts.length)
		{
			optsTXT = new FlxText(340, 300 + (i * 60), 0, mainmenuopts[i]);
			optsTXT.setFormat(AssetPaths.AnakCute__ttf, 50, FlxColor.WHITE, CENTER);
			optsTXT.antialiasing = Options.antialiasing;
			optsTXT.ID = i;
			txtGroup.add(optsTXT);

			switch (i)
			{
				case 1:
					optsTXT.x = 310;
				case 2:
					optsTXT.x = 320;
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!FlxG.save.data.warningquestion != false)
		{
			FlxG.switchState(new WarningState());
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			PopupMessage.stateUsed = "ExitGame";
			PopupMessage.options = ["Exit", "Cancel"];
			PopupMessage.textforState = "Are you Sure You Want To Exit";
			PopupMessage.textSize = 40;
			PopupMessage.textArea = 530;
			openSubState(new PopupMessage());
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
					optionSelect = txt.ID;
					usingMouse = true;
					txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
				}

				if (FlxG.mouse.pressed && canClick)
				{
					switch (mainmenuopts[optionSelect])
					{
						case 'Play':
							FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
							{
								FlxG.switchState(new PlayState());
							});
						case 'Settings':
							FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
							{
								FlxG.switchState(new SettingsState());
							});
						case 'Credits':
							FlxTween.tween(mainGRL, {alpha: 0}, 0.5, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									openSubState(new CreditsState());
								}
							});

						case 'Exit':
							PopupMessage.stateUsed = "ExitGame";
							PopupMessage.options = ["Exit", "Cancel"];
							PopupMessage.textforState = "Are you Sure You Want To Exit";
							openSubState(new PopupMessage());
					}
				}
			}
		});
	}
}

// credits state
class CreditsState extends FlxSubState
{
	var txt:FlxText;

	override public function create()
	{
		super.create();

		txt = new FlxText(300, 0, FlxG.width, "Credits"
			+ "\n\nProgramer: Alec_025"
			+ "\nArtist: Alec_025"
			+ "\nStory: My Sister"
			+ "\n\n Press ESC To Close",
			50);
		txt.setFormat(AssetPaths.AnakCute__ttf, 40, CENTER);
		txt.antialiasing = Options.antialiasing;
		txt.screenCenter(Y);
		txt.alpha = 0;
		add(txt);

		FlxTween.tween(txt, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(txt, {alpha: 0}, 0.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
			FlxTween.tween(MainMenu.mainGRL, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		}
	}
}
