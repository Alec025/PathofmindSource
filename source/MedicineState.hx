package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class MedicineState extends FlxState
{
	var btn1:FlxButton;
	var btn2:FlxButton;

	override public function create()
	{
		super.create();

		var bg = new FlxSprite();
		bg.antialiasing = true;
		bg.loadGraphic(AssetPaths.inside__png);
		add(bg);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			btn1 = new FlxButton(500, 350, "Take Medicine", btnoption1);
			btn1.antialiasing = true;
			add(btn1);

			btn2 = new FlxButton(600, 350, "Don't take it", btnoption2);
			btn2.antialiasing = true;
			add(btn2);
		});
	}

	function btnoption1()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false);
		remove(btn1);
		remove(btn2);
		var txt = new FlxText("You lived");
		txt.setFormat("assets/fonts/Chivo", 50, 0xFFFF0000, CENTER);
		txt.screenCenter();

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new HelpState());
		});
	}

	function btnoption2()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false);
		remove(btn1);
		remove(btn2);
		var txt = new FlxText("You die");
		txt.setFormat("assets/fonts/Chivo", 50, 0xFFFF0000, CENTER);
		txt.screenCenter();

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new HelpState());
		});
	}
}
