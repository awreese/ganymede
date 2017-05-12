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

package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameUnits.capturable.Planet;
import gameUnits.capturable.Planet.PlanetStat;
import map.GameMap;
import map.MapNode;
import faction.Faction;
import gameUnits.Ship;
import Main;
import flixel.math.FlxRandom;
import npc.Enemy;
import tutorial.FinishGameState;

class PlayState extends FlxState
{
	private var grpMap: FlxTypedGroup<GameMap>;
	private var gameMap: GameMap;
	public var grpShips: FlxTypedGroup<gameUnits.Ship>;
	private var grpPlanets: FlxTypedGroup<gameUnits.capturable.Planet>;
	private var rand:FlxRandom;
	private var numPlayerFaction:Int;
	private var enemy1: Enemy;

	override public function create(): Void
	{
		rand = new FlxRandom();
		enemy1 = new Enemy(FactionType.ENEMY_1, 10);
		// Initialize the map
		grpMap = new FlxTypedGroup<GameMap>();
		add(grpMap);
		gameMap = new GameMap(this, Main.LEVEL);
		grpMap.add(gameMap);
		//add(gameMap);

		// Create the ships
		grpShips = new FlxTypedGroup<gameUnits.Ship>();
		add(grpShips);

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
		
		// Update each ship's list of all ships
		for (s in grpShips) {
			s.listOfAllShips = grpShips.members;
		}

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
				trace("Selected node " + n.getPosition().toString());
				for (s in grpShips)
				{
					// only move the ships that are the player's
					if (s.getFaction() == FactionType.PLAYER)
					{
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
				trace("Ordered movement to " + n.getPosition().toString());
				for (s in grpShips)
				{
					if (s.isSelected)
					{
						s.isSelected = false;
						s.pathTo(n);
					}
				}
			}
		}
		
		// enemy turn
		enemy1.makeMove(gameMap.getControlledNodes(enemy1.getFaction()));

		// check where each ships are and updating each planet, and battle if there's opposing factions
		nodeUpdate(elapsed);
		
		// produce ships
		produceShips(elapsed);
		
		// if captured all the planets, progress
		if (gameMap.getNumPlayerPlanets() == gameMap.getNumPlanets()) {
			if (Main.LEVEL == 3) {
				FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
				FlxG.switchState(new FinishGameState());
				});
			}
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new NextLevelState());
			});
		}
		
		// if player lose all planets, gameover
		if (gameMap.getNumPlayerPlanets() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new GameOverState());
			});
		}

		super.update(elapsed);
	}
	
    // TODO: Most (if not all) of this should be moved to GameMap and Ship
	private function nodeUpdate(elapsed : Float):Void {
		for (n in gameMap.nodes)
		{
			var p : Planet = n.containPlanet() ? cast(n.getCaptureable(), Planet) : null;
			var numShips:Map<FactionType, Int> = new Map<FactionType, Int>();
			for (f in Faction.getEnums()) {
				numShips.set(f, 0);
			}

			var shipsAtNode = new Array<Ship>();
			
			var nPos:FlxVector = new FlxVector(n.x, n.y);

			// determine which ships are within the range of the node
			for (s in grpShips)
			{
				var sPos:FlxVector = s.getPos();
				var distance:Float = nPos.dist(sPos);
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
						var hit : Bool = rand.int() % 2 == 0;
						if (hit)
						{
							// if hit, decrease hp
							target.stats.hitPoints -= s.stats.attackSpeed * s.stats.attackDamage * elapsed * target.stats.shield;
							if (target.stats.hitPoints < 0.0)
							{
								// if run out of hp, kill target
								target.kill();
								target.visible = false;
								// decrease num ships at the planet
								numShips.set(target.getFaction(), numShips.get(target.getFaction()) - 1);
								numFactions = numShips.get(target.getFaction()) > 0 ? numFactions : numFactions - 1;
							}
						}
						// if there is less than 2 factions, break out of loop
						if (numFactions < 2) {
							break;
						}
					}
				}
			}
						// if there's a planet here
			if (p != null) 
			{
				// update number of ships of each faction in
				for (f in numShips.keys())
				{
					p.setNumShips(f, numShips.get(f));
				}
				p.setShips(shipsAtNode);
			}
		}
	}
	
    // TODO: Move this into PlanetFactory
	// produce ships for each planet (if they can)
	private function produceShips(elapsed: Float):Void {
		for (n in gameMap.nodes) {
			// checks if there's a planet at n
			if (!n.containPlanet()) {
				continue;
			}
			// get the planet
			var p = cast(n.getCaptureable(), Planet);
			var pPos = p.getPos();
			// find the MapNode for the planet
			var node = gameMap.findNode(new FlxVector(pPos.x + (MapNode.NODE_SIZE / 2), pPos.y + (MapNode.NODE_SIZE / 2)));
			var ship:Ship = p.produceShip(node);
			if (ship != null) {
				grpShips.add(ship);
				node.addShip(ship);
			}
		}
	}
}
