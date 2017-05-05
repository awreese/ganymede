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
		/*grpPlanets = new FlxTypedGroup<Planet>();
		add(grpPlanets);*/
		
		//grpPlanets.add(new Planet(gameMap.nodes[0], Faction.PLAYER, new Planet.PlanetStat()));
		//grpPlanets.add(new Planet(gameMap.nodes[1], Faction.NOP, new Planet.PlanetStat()));
		
		//playerPlanet = new Planet(gameMap.nodes[0], Faction.PLAYER, new Planet.PlanetStat());
		enemyPlanet = new Planet(gameMap.nodes[1], Faction.ENEMY_1, new Planet.PlanetStat());
		//openPlanet = new Planet(gameMap.nodes[2], Faction.NOP, new Planet.PlanetStat());
		
		//add(playerPlanet);
		add(enemyPlanet);
		//add(openPlanet);
		
		//playerPlanet.setNumShips(Faction.ENEMY_1, 1);
		enemyPlanet.setNumShips(Faction.PLAYER, 2);
		//openPlanet.setNumShips(Faction.PLAYER, 2);
		//openPlanet.setNumShips(Faction.ENEMY_1, 1);

		// Create the ships
		grpShips = new FlxTypedGroup<Ship>();
		add(grpShips);
		
		for (i in 0...10)
		{
			var stat: ShipStat = { hull: ShipType.FRIGATE,
								   pos: gameMap.nodes[0].pos, 
								   vel: 100, 
								   sh: 100, 
								   hp: 100, 
								   as: 0, 
								   ap: 0, 
								   cp: 0 };
			var s = new Ship(gameMap.nodes[0], Faction.PLAYER, stat);
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
		
		

		super.update(elapsed);
	}
}