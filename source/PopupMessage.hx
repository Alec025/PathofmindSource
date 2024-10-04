package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PopupMessage extends FlxSubState
{
	public static var stateUsed:String = "";
	public static var textforState:String = "";
	public static var options:Array<String> = [];
	public static var textSpeedOutput:String = "";
	public static var textSize:Int = 40;
	public static var textArea:Int = 530;

	var messageSelect:Int = 0;
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

		text = new FlxText(400, 350, 498, textforState);
		text.antialiasing = Options.antialiasing;
		text.setFormat(AssetPaths.AnakCute__ttf, textSize, FlxColor.WHITE, CENTER);
		add(text);

		for (i in 0...options.length)
		{
			optsTXT = new FlxText(textArea + (i * 150), 420, 0, options[i]);
			optsTXT.antialiasing = Options.antialiasing;
			optsTXT.setFormat(AssetPaths.AnakCute__ttf, 35, FlxColor.WHITE, CENTER);
			optsTXT.ID = i;
			txtGroup.add(optsTXT);
		}

		trace(stateUsed);
		trace(textforState);
		trace(options);
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

				if (messageSelect != txt.ID)
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
					messageSelect = txt.ID;
					usingMouse = true;
					txt.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.2);
				}

				if (FlxG.mouse.pressed && canClick)
				{
					if (stateUsed == "ExitGame")
					{
						switch (options[messageSelect])
						{
							case 'Exit':
								FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
								{
									Sys.exit(0);
								});
							case 'Cancel':
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
									if (messageSelect != txt.ID)
									{
										FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
									}
								});
						}
					}
					if (stateUsed == "ResetSettings")
					{
						switch (options[messageSelect])
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
									if (messageSelect != txt.ID)
									{
										FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
									}
								});
						}
					}

					if (stateUsed == "TextSpeedOverDrive")
					{
						switch (options[messageSelect])
						{
							case 'Proceed':
								if (textSpeedOutput == "Add") {}
								else {}

							case 'Cancel':
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
									if (messageSelect != txt.ID)
									{
										FlxTween.tween(txt, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
									}
								});
						}
					}
				}
			}
		});
	}
}
