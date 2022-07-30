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

class HomeState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var floor:FlxTilemap;
	var bed:FlxSprite;
	var carpet:FlxSprite;
	var table2:FlxSprite;
	var txt:FlxText;

	var dialogue1 = [
		"Another day wasted",
		"Well I should go take my medication",
		"Click to interact with objects"
	];

	var line:Int = 0;

	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.mouse.visible = true;
		map = new FlxOgmo3Loader(AssetPaths.pathofmind__ogmo, AssetPaths.room_001__json);

		floor = map.loadTilemap(AssetPaths.tiles__png, "floor");
		floor.follow();
		floor.setTileProperties(1, NONE);
		floor.setTileProperties(2, ANY);

		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);
		add(floor);

		carpet = new FlxSprite(500, 320);
		carpet.antialiasing = true;
		carpet.scale.set(2, 2);
		carpet.loadGraphic(AssetPaths.carpet__png);
		add(carpet);

		bed = new FlxSprite(935, 140);
		bed.antialiasing = true;
		bed.loadGraphic(AssetPaths.deocrations__png);
		add(bed);

		var table2 = new FlxButton(450, 130, table);
		table2.loadGraphic(AssetPaths.table__png, true, 199, 93);
		table2.antialiasing = true;
		add(table2);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);
		super.create();

		txt = new FlxText(200, 600, dialogue1[line]);
		txt.setFormat("assets/fonts/Chivo", 30, CENTER);
		txt.antialiasing = true;
		add(txt);
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			player.setPosition(entity.x, entity.y);
		}
	}

	function table()
	{
		FlxG.switchState(new MedicineState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);

		var entered:Bool = FlxG.keys.justPressed.ENTER;

		if (line < 3)
		{
			if (entered)
			{
				txt.text = dialogue1[line];
				line += 1;

				if (line == 3)
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						remove(txt);
					});
			}
		}
	}
}
