package;

/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
 * 
 * This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxVector;
import map.GameMap;
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
			var s = new Ship(gameMap.nodes[0], Faction.PLAYER);
			grpShips.add(s);
		}

		super.create();
	}

	override public function update(elapsed: Float): Void
	{
		// Selecting ships
		if (FlxG.mouse.justPressed)
		{
			var n = gameMap.findNode(new FlxVector(FlxG.mouse.x, FlxG.mouse.y));
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
			var n = gameMap.findNode(new FlxVector(FlxG.mouse.x, FlxG.mouse.y));
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