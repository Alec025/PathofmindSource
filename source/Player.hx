package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 200;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.Player1__png, true, 21, 34);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		antialiasing = true;
		animation.add("lr", [0, 1, 2], 6, false);
		animation.add("u", [3, 4, 5], 6, false);
		animation.add("d", [6, 7, 8], 6, false);
		// scale.set(0.2, 0.2);

		drag.x = drag.y = 1600;
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		var newAngle:Float = 0;
		if (up)
		{
			newAngle = -90;
			if (left)
				newAngle -= 45;
			else if (right)
				newAngle += 45;
		}
		else if (down)
		{
			newAngle = 90;
			if (left)
				newAngle += 45;
			else if (right)
				newAngle -= 45;
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

		if (up || down || left || right)
		{
			velocity.set(SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}

		var action = "Idle";

		// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			switch (facing)
			{
				case LEFT, RIGHT:
					animation.play("lr");
				case UP:
					animation.play("u");
				case DOWN:
					animation.play("d");
				case _:
			}
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}
