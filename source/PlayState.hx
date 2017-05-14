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
	private var enemies: Array<Enemy>;

	override public function create(): Void
	{
		rand = new FlxRandom();
		enemies = new Array<Enemy>();
		// Initialize the map
		grpMap = new FlxTypedGroup<GameMap>();
		add(grpMap);
		gameMap = new GameMap(this, Main.LEVEL);
		grpMap.add(gameMap);
		//add(gameMap);

		// Create the ships
		grpShips = new FlxTypedGroup<gameUnits.Ship>();
		add(grpShips);

		// add the enemies
		for (faction in Faction.getEnums()) {
			if (faction == null || faction == FactionType.PLAYER || faction ==  FactionType.NOP || faction == FactionType.NEUTRAL) {
				continue;
			}
			if (gameMap.getControlledNodes(faction).length > 0) {
				enemies.push(new Enemy(faction, 10));
			}
		}
		
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
		for (enemy in enemies) {
			var nodes = gameMap.getControlledNodes(enemy.getFaction());
			if (nodes.length > 0) {
				// make a move if there are controlling factions
				enemy.makeMove(nodes);
			}
		}
		//enemy1.makeMove(gameMap.getControlledNodes(enemy1.getFaction()));
		
		// Make ships move by flocking
		shipFlocking(elapsed);
		
		// Make ships fight one another
		shipCombat(elapsed);

		// check where each ships are and updating each planet, and battle if there's opposing factions
		//nodeUpdate(elapsed);
		
		// produce ships
		produceShips(elapsed);
		
		// if captured all the planets, progress
		if (gameMap.getNumPlayerPlanets() == gameMap.getNumPlanets()) {
			if (Main.LEVEL == Main.FINAL_LEVEL) {
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
	
	
	/*
	 * This function handles all the flocking behavior of the ships. It does so by iterating
	 * through all the ships, comparing their position and velocity to the position and velocity
	 * of nearby ships, and then setting each ship's velocity.
	 * 
	 * This flocking algorithm is based primarily off of the Boid algorithm described here:
	 * https://en.wikipedia.org/wiki/Boids
	 */
	private function shipFlocking(elapsed: Float): Void {
		// Iterates through all the ships
		for (s1 in grpShips) {
			
			// Defines all the forces acting on the ship
			var toDest = s1.idealPos().subtractNew(s1.pos); // This force pulls the ship towards its destination
			var desiredSpeed = s1.vel.normalize().scaleNew(s1.stats.maxVelocity).subtractNew(s1.vel); // This force accelerates the ship to its desired speed
			var noise = new FlxVector(Math.random() - .5, Math.random() - .5); // This force provides a bit of noise to make the motion look nicer
			var seperation = new FlxVector(0, 0); // This force prevents ships from getting too close together
			var alignment = new FlxVector(0, 0); // This force makes ships tend to point the same direction
			var cohesion = new FlxVector(0, 0); // This force makes ships tend to group together in clusters
			
			// Iterate through all other ships that this ship might flock with
			for (s2 in grpShips) {
				// Only flock with other ships of your faction
				if (s2 != s1 && s1.getFaction() == s2.getFaction()) {
					var d: FlxVector = s1.pos.subtractNew(s2.pos);
					// Only flock with nearly ships
					if (d.length < 30) {
						seperation = seperation.addNew(d.scaleNew(1/d.lengthSquared));
						alignment = alignment.addNew(s2.vel.subtractNew(s1.vel));
						cohesion = cohesion.addNew(d.normalize());
					}
				}
			}

			// Compute the net acceleration, scaling each component by an arbitrary constant
			// The constants to scale by were determined partially by trial and error until the motion looked good
			var acceleration = new FlxVector(0, 0)
			.addNew(toDest.scaleNew(.1 * toDest.length))
			.addNew(desiredSpeed.scaleNew(50))
			.addNew(noise.scaleNew(10))
			.addNew(seperation.scaleNew(100))
			.addNew(alignment.scaleNew(.5))
			.addNew(cohesion.scaleNew(0.5));

			// Update the velocity
			s1.vel = s1.vel.addNew(acceleration.scaleNew(elapsed));
		}
	}
	
	
	/*
	 * This function handles combat between different ships. It iterates through all the ships,
	 * checks if any ship has enemies nearby that it should attack, and orders ships to fire at
	 * enemies if needed.
	 * 
	 * This function does not handle damaging or destroying ships. That will be handled by the
	 * ShipAttack class, which represents a single attack by one ship against one ship.
	 */
	private function shipCombat(elapsed: Float): Void {
				
		// Iterate through each of the ships
		for (s1 in grpShips) {
			
			// If the ship is dead, remove it from the group
			if (!s1.exists) {
				trace("Ship dead");
				grpShips.remove(s1);
			}
			
			// Iterate through each of the potential targets
			// TODO: Iterate through the potential targets in a random order
			for (s2 in grpShips) {
				if (s1.getFaction() != s2.getFaction()) {
					if (s1.getPos().distanceTo(s2.getPos()) < 50) {
						if (s1.weapon.fireAtTarget(s2)) {
							s1.weapon.currentBullet.target = s2;
							add(s1.weapon.currentBullet);
						}
					}
				}
			}
		}
	}
	
    // TODO: Most (if not all) of this should be moved to GameMap and Ship
	private function nodeUpdate(elapsed : Float):Void {
		//for (n in gameMap.nodes)
		for (n in gameMap.getNodeList())
		{
			var p : Planet = n.isPlanet() ? cast(n.getCaptureable(), Planet) : null;
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

			// TODO: Replace this combat code with updated combat code in the shipCombat() function
			/*// if there are more than 1 factions in a node
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
			}*/
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
		//for (n in gameMap.nodes) {
		for (n in gameMap.getNodeList()) {
			// checks if there's a planet at n
			if (!n.isPlanet()) {
				continue;
			}
			// get the planet
			var p = cast(n.getCaptureable(), Planet);
			var pPos = p.getPos();
			// find the MapNode for the planet
			var node = gameMap.findNode(new FlxVector(pPos.x + (MapNode.NODE_RADIUS / 2), pPos.y + (MapNode.NODE_RADIUS / 2)));
			var ship:Ship = p.produceShip(node);
			if (ship != null) {
				grpShips.add(ship);
				node.addShip(ship);
			}
		}
	}
}
