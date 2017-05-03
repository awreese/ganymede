package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import map.GameMap;
import math.Vec;
import source.Ship;

class PlayState extends FlxState
{

	private var gameMap: GameMap;
	private var grpShips: FlxTypedGroup<Ship>;

	override public function create(): Void
	{
		// Initialize the map
		gameMap = new GameMap();
		add(gameMap);

		// Create the ships
		grpShips = new FlxTypedGroup<Ship>();
		add(grpShips);
		
		for (i in 0...10)
		{
			var s = new Ship(gameMap.nodes[0], 0);
			grpShips.add(s);
		}

		super.create();
	}

	override public function update(elapsed: Float): Void
	{
		// Selecting ships
		if (FlxG.mouse.justPressed)
		{
			var n = gameMap.findNode(new Vec(FlxG.mouse.x, FlxG.mouse.y));
			if (n == null)
			{
				for (s in grpShips)
				{
					s.isSelected = false;
				}
			}
			else
			{
				trace("Selected node " + n.pos.toString());
				for (s in grpShips)
				{
					s.isSelected = n.contains(s.pos);
				}
			}
		}

		// Ordering ships to move
		if (FlxG.mouse.justPressedRight)
		{
			var n = gameMap.findNode(new Vec(FlxG.mouse.x, FlxG.mouse.y));
			if (n != null)
			{
				trace("Ordered movement to " + n.pos.toString());
				for (s in grpShips)
				{
					if (s.isSelected) {
						s.pathTo(n);
					}
				}
			}
		}

		super.update(elapsed);
	}
}