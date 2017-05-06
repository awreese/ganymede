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
import map.MapNode;
import faction.Faction;
//import faction.FactionType;
import Ship;

class PlayState extends FlxState
{

	private var gameMap: GameMap;
	private var grpShips: FlxTypedGroup<Ship>;
	private var grpPlanets: FlxTypedGroup<Planet>;
	private var playerPlanet: Planet;
	private var enemyPlanet: Planet;
	private var openPlanet: Planet;
	
	override public function create(): Void
	{
		// Initialize the map
		gameMap = new GameMap();
		add(gameMap);
		
		// create planets
		grpPlanets = new FlxTypedGroup<Planet>();
		add(grpPlanets);
		grpPlanets.add(new Planet(gameMap.nodes[0], new Faction(FactionType.PLAYER), new Planet.PlanetStat()));
		

		// Create the ships
		grpShips = new FlxTypedGroup<Ship>();
		add(grpShips);
		
		for (i in 0...1)
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
			var s = new Ship(gameMap.nodes[0], faction, stat);
			grpShips.add(s);
		}

		super.create();
	}

	/*
	 * This is the main game engine.
	 */
	override public function update(elapsed: Float): Void {
		
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
					//s.isSelected = n.contains(s.pos);
					s.isSelected = n.contains(s.stats.pos);
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
		
		// check where each ships are and updating each planet
		for (p in grpPlanets) {
			var numShips:Map<FactionType, Int> = new Map<FactionType, Int>();
			numShips.set(FactionType.PLAYER, 0);
			numShips.set(FactionType.ENEMY_1, 0);
			numShips.set(FactionType.ENEMY_2, 0);
			numShips.set(FactionType.ENEMY_3, 0);
			numShips.set(FactionType.ENEMY_4, 0);
			numShips.set(FactionType.ENEMY_5, 0);
			numShips.set(FactionType.ENEMY_6, 0);
			numShips.set(FactionType.NEUTRAL, 0);
			for (s in grpShips) {
				var pPos:FlxVector = p.getPos();
				var sPos:FlxVector = s.getPos();
				var distance:Float = Math.sqrt((sPos.x - pPos.x) * (sPos.x - pPos.x) + (sPos.y - pPos.y) * (sPos.y - pPos.y));
				if (distance < 30) {
					numShips.set(s.getFaction(), numShips.get(s.getFaction()) + 1);
				}
			}
			for (f in numShips.keys()) {
				p.setNumShips(f, numShips.get(f));
			}
		}

		super.update(elapsed);
	}
}