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
import flixel.util.FlxTimer;
import gameUnits.Planet;
import map.GameMap;
import map.MapNode;
import faction.Faction;
//import faction.FactionType;
import gameUnits.Ship;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{

	private var gameMap: GameMap;
	private var grpShips: FlxTypedGroup<gameUnits.Ship>;
	private var grpPlanets: FlxTypedGroup<gameUnits.Planet>;
	private var rand:FlxRandom;

	override public function create(): Void
	{
		rand = new FlxRandom();
		// Initialize the map
		gameMap = new GameMap();
		add(gameMap);

		// create planets
		grpPlanets = new FlxTypedGroup<gameUnits.Planet>();
		add(grpPlanets);
		grpPlanets.add(new gameUnits.Planet(gameMap.nodes[0], new Faction(FactionType.PLAYER), new gameUnits.Planet.PlanetStat()));
		grpPlanets.add(new gameUnits.Planet(gameMap.nodes[1], new Faction(FactionType.ENEMY_1), new gameUnits.Planet.PlanetStat()));

		// Create the ships
		grpShips = new FlxTypedGroup<gameUnits.Ship>();
		add(grpShips);

		/*for (i in 0...1)
		{
			var stat: ShipStat = new ShipStat(ShipType.FRIGATE,
								  gameMap.nodes[0].pos,
								  30,
								  100,
								  100,
								  0,
								  0,
								  0);
			var faction:Faction = new Faction(FactionType.PLAYER);
			var s = new gameUnits.Ship(gameMap.nodes[0], faction, stat);
			grpShips.add(s);
		}*/
		var stat1: ShipStat = new ShipStat();
		stat1.hull = ShipType.FRIGATE;
		stat1.ap = 50;
		var stat2: ShipStat = new ShipStat();
		stat2.hull = ShipType.FRIGATE;
		stat2.ap = 50;
		var stat3: ShipStat = new ShipStat();
		stat3.hull = ShipType.FRIGATE;
		stat3.ap = 50;
		grpShips.add(new Ship(gameMap.nodes[0], new Faction(FactionType.PLAYER), stat1));
		grpShips.add(new Ship(gameMap.nodes[1], new Faction(FactionType.ENEMY_1), stat2));
		grpShips.add(new Ship(gameMap.nodes[3], new Faction(FactionType.PLAYER), stat3));
		super.create();
	}

	/*
	 * This is the main game engine.
	 */
	override public function update(elapsed: Float): Void
	{

		/*
		 * Check and update any game state
		 */

		/*
		 * Handle any mouse/keyboard events
		 */

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
					// only move the ships that are the player's
					if (s.getFaction() == FactionType.PLAYER)
					{
						//s.isSelected = n.contains(s.pos);
						//s.isSelected = n.contains(s.getPos());
						// allows player to select multiple ships on the map
						if (n.contains(s.getPos()))
						{
							s.isSelected = true;
						}
					}
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
					if (s.isSelected)
					{
						s.pathTo(n);
					}
				}
			}
		}

		// check where each ships are and updating each planet
		for (p in grpPlanets)
		{
			var numShips:Map<FactionType, Int> = new Map<FactionType, Int>();
			numShips.set(FactionType.PLAYER, 0);
			numShips.set(FactionType.ENEMY_1, 0);
			numShips.set(FactionType.ENEMY_2, 0);
			numShips.set(FactionType.ENEMY_3, 0);
			numShips.set(FactionType.ENEMY_4, 0);
			numShips.set(FactionType.ENEMY_5, 0);
			numShips.set(FactionType.ENEMY_6, 0);
			numShips.set(FactionType.NEUTRAL, 0);

			var shipsAtNode = new Array<Ship>();

			// determine which ships are within the range of the node
			for (s in grpShips)
			{
				var pPos:FlxVector = p.getPos();
				var sPos:FlxVector = s.getPos();
				var distance:Float = pPos.dist(sPos);
				if (distance < 30 && s.exists)
				{
					numShips.set(s.getFaction(), numShips.get(s.getFaction()) + 1);
					shipsAtNode[shipsAtNode.length] = s;
				}
			}

			var numFactions:Int = 0;
			// checks for number of factions
			for (f in numShips.keys())
			{
				if (numShips.get(f) > 0)
				{
					numFactions++;
				}
			}

			// if there are more than 1 factions in a node
			if (numFactions > 1)
			{
				for (s in shipsAtNode)
				{
					if (s.exists)
					{
						// if the ship is not killed

						// select target
						var target : Ship = shipsAtNode[rand.int(0, shipsAtNode.length - 1)];
						while (target.getFaction() == s.getFaction() || !target.exists)
						{
							// if target is the same faction or target does not exist
							target = shipsAtNode[rand.int(0, shipsAtNode.length - 1)];
						}

						// random chance of hitting
						var hit : Bool = rand.int() % 5 == 0;
						if (hit)
						{
							// if hit, decrease hp
							target.stats.hp -= s.stats.as * s.stats.ap * elapsed * target.stats.sh;
							if (target.stats.hp < 0.0)
							{
								// if run out of hp, kill target
								target.kill();
								target.visible = false;
								// decrease num ships at the planet
								numShips.set(target.getFaction(), numShips.get(target.getFaction()) - 1);
								numFactions = 0;
								// recheck number of factions after killing a ship
								for (f in numShips.keys())
								{
									if (numShips.get(f) > 0)
									{
										numFactions++;
									}
								}
							}
						}
						// if there is less than 2 factions, break out of loop
						if (numFactions < 2) {
							break;
						}
					}
				}
			}

			// update number of ships of each faction in
			for (f in numShips.keys())
			{
				p.setNumShips(f, numShips.get(f));
			}
		}

		super.update(elapsed);
	}
}
