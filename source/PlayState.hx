package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.text.FlxTypeText;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

// Class1
class PlayState extends FlxState
{
	var dialogue:Array<String> = [
		"Every choice leads to a certain consequence...",
		"either good or bad...",
		"The mind knows these consequences...",
		"as it plans its self out...",
		"but what happenes when the mind is jumbled...",
		"Losing it...",
		"Maybe it's time I finally find out."
	];
	var line:Int = 0;
	var complete:Bool = true;
	var msg:FlxTypeText;

	var allowInput:Bool = true;

	override public function create()
	{
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.mouse.visible = false;

		msg = new FlxTypeText(0, 0, 1280, dialogue[line], 30);
		msg.setFormat(AssetPaths.Chivo__ttf, 30, CENTER);
		msg.completeCallback = function name()
		{
			complete = true;
		};
		msg.start(0.05);
		msg.antialiasing = Options.antialiasing;
		msg.screenCenter();
		add(msg);
	}

	function testFCT()
	{
		msg.resetText(dialogue[line += 1]);
		msg.start(0.05);
		msg.screenCenter();
		msg.setFormat(AssetPaths.Chivo__ttf, 30, CENTER);
		msg.antialiasing = Options.antialiasing;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.camera.fade(FlxColor.BLACK, 3, false, () ->
			{
				FlxG.switchState(new MedicineState());
			});
		}

		if (Options.autoText == true && complete == true && line <= 6)
		{
			allowInput = false;
			complete = false;
			new FlxTimer().start(10, function(tmr:FlxTimer)
			{
				testFCT();
			});
		}

		if (FlxG.keys.justPressed.ENTER && line <= 6 && allowInput == true)
		{
			msg.resetText(dialogue[line += 1]);
			msg.start(0.04);
			msg.screenCenter();
			msg.setFormat(AssetPaths.Chivo__ttf, 30, CENTER);
			msg.antialiasing = Options.antialiasing;
		}
		if (line == 6)
		{
			FlxG.camera.fade(FlxColor.BLACK, 6, false, () ->
			{
				FlxG.switchState(new MedicineState());
			});
			// new FlxTimer().start(1, function(tmr:FlxTimer) {});
		}
	}
}

// Class2
/*class Player extends FlxSprite
	{
	var testSprite:Player;

	static inline var SPEED:Float = 100;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.Player1__png, true, 21, 34);
		animation.add("d_Idle", [0]);
		animation.add("lr_Idle", [4]);
		animation.add("u_Idle", [8]);
		animation.add("d_Walk", [2, 1, 2, 3], 6);
		animation.add("lr_Walk", [6, 5, 6, 7], 6);
		animation.add("u_Walk", [10, 9, 10, 11], 6);
		setSize(8, 8);
		offset.set(4, 8);
		drag.x = drag.y = 800;
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
	}

	override public function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		#end

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		if (up && right)
			up = right = false;
		if (up && left)
			up = left = false;
		if (down && right)
			down = right = false;
		if (down && left)
			down = left = false;

		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = DOWN;
			}
			else if (left)
			{
				newAngle = 180;
				facing = LEFT;
			}
			else if (right)
			{
				newAngle = 0;
				facing = RIGHT;
			}

			// determine our velocity based on angle and speed
			velocity.setPolarDegrees(SPEED, newAngle);
		}

		var action = "Idle";
		// check if the player is moving, and not walking into walls
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			action = "Walk";
		}

		switch (facing)
		{
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}
	}
}*/
// class3
class MedicineState extends FlxState
{
	var player:Player;

	override public function create()
	{
		player = new Player(20, 20);
		add(player);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
