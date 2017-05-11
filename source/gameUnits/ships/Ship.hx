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

package gameUnits.ships;

import faction.Faction;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import gameUnits.capturable.Planet;
import source.gameUnits.ships.ShipTypes.ShipType;
import source.gameUnits.ships.ShipTypes.ShipStats;
import map.MapEdge;
import map.MapNode;

/**
 * Various ship types that exist in-game.
 *
 * @author Drew Reese
 */
//enum ShipType
//{
	//FRIGATE;
	//DESTROYER;
	//CRUISER;
	//BATTLECUISER;
	//BATTLESHIP;
	//FIGHTER;
	//CORVETTE;
	//CAPITAL;
	//PATROL_CRAFT;
//}

/**
 * ShipGroup is a group of ships
 */
typedef ShipGroup = FlxTypedGroup<Ship>;

/**
 *
 * @author Daisy
 * @author Rory Soiffer
 * @author Drew Reese
 */
class Ship extends FlxSprite
{

	//private var playState: PlayState; // NO, this is bad style.  If anything access what you want via getter.  I'm trying to push all these calls like this down to the node that everything sits on.  Way too much coupling going on!!

	// Parent/Faction Info
	private var homePlanet: gameUnits.capturable.Planet;
	private var faction: Faction;

	public var pos: FlxVector;
	public var vel: FlxVector = new FlxVector(0,0);  // current velocity
	public var type: ShipType; // What type of ship this ship is

	public var destination: MapNode; // The node this ship is moving towards
	public var nodePath: Array<MapEdge> = []; // The path this ship is moving along (if any)
	public var progress: Float; // How far along the path this ship has traveled

	public var isSelected: Bool; // Whether the player has currently selected this ship (should ideally be moved to a Player class in the future)

	public var listOfAllShips: Array<Ship> = []; // The list of all ships, which is needed for flocking

	private var hpBar: FlxText;

	//public function new(playState: PlayState, destination: MapNode, faction: Faction, shipStats: ShipStat) 	{
	public function new(destination: MapNode, faction: Faction, type: ShipType)
	{
		super();
		//this.playState = playState;
		this.destination = destination;
		this.faction = faction;
		this.type = type;
		this.pos = destination.getPos();

		switch (this.faction.getFaction())
		{
			case PLAYER:
				loadGraphic(AssetPaths.ship_1__png, false);
			case ENEMY_1:
				loadGraphic(AssetPaths.enemyship_1__png, false);
			case ENEMY_2:
				loadGraphic(AssetPaths.enemyship_1__png, false);
			case ENEMY_3:
				loadGraphic(AssetPaths.enemyship_1__png, false);
			case ENEMY_4:
				loadGraphic(AssetPaths.enemyship_1__png, false);
			case ENEMY_5:
				loadGraphic(AssetPaths.enemyship_1__png, false);
			case ENEMY_6:
				loadGraphic(AssetPaths.enemyship_1__png, false);
			case NEUTRAL:
				loadGraphic(AssetPaths.ship_1__png, false);
			default:
		}

		hpBar = new FlxText(this.x, this.y - this.height, 0, "" + ShipStats.getMaxHP(type), 16);
		//FlxG.state.add(hpBar);
	}

	// Returns the acceleration of the ship, following flocking behavior
	public function flock(elapsed: Float): FlxVector
	{
		// All the forces acting on the ship
		var toDest = idealPos().subtractNew(this.pos);
		var desiredSpeed = this.vel.normalize().scaleNew(ShipStats.getSpeed(type)).subtractNew(this.vel);
		var noise = new FlxVector(Math.random() - .5, Math.random() - .5);
		var seperation = new FlxVector(0, 0);
		var alignment = new FlxVector(0, 0);
		var cohesion = new FlxVector(0, 0);

		for (s in listOfAllShips)
		{
			// Only flock with other ships of your faction
			if (s != this && getFaction() == s.getFaction())
			{
				var d: FlxVector = this.pos.subtractNew(s.pos);
				if (d.length < 30)
				{
					seperation = seperation.addNew(d.scaleNew(1/d.lengthSquared));
					alignment = alignment.addNew(s.vel.subtractNew(this.vel));
					cohesion = cohesion.addNew(d.normalize());
				}
			}
		}

		// Compute the net acceleration, scaling each component by a constant to make the final motion look good
		return new FlxVector(0, 0)
			   .addNew(toDest.scaleNew(.05 * toDest.length))
			   .addNew(desiredSpeed.scaleNew(50))
			   .addNew(noise.scaleNew(10))
			   .addNew(seperation.scaleNew(100))
			   .addNew(alignment.scaleNew(.5))
			   .addNew(cohesion.scaleNew(0.5));
	}

	// Returns where along its path the ship should be right now if it weren't for flocking behavior
	public function idealPos(): FlxVector
	{
		if (isMoving())
		{
			return nodePath[0].interpDist(progress);
		}
		else {
			return destination.getPos();
		}
		//return nodePath[0].interpDist(progress);
	}

	// Returns whether the ship is currently moving between nodes or is at a node
	public function isMoving(): Bool
	{
		return nodePath.length > 0;
	}

	// Orders the ship to follow the shortest possible path to a given node
	public function pathTo(n: MapNode): Void
	{
		if (isMoving())
		{
			var e = nodePath[0];
			nodePath = nodePath[0].pathTo(n, progress);
			if (nodePath[0].n1 != e.n1)
			{
				progress = e.length() - progress;
			}
		}
		else {
			nodePath = destination.pathTo(n);
		}
		destination = n;
	}

	override public function update(elapsed:Float):Void
	{

		//
		// SHIP MOVEMENT
		//

		// Whether the ship is currently stationed at one node or is moving between nodes
		if (isMoving())
		{
			// Update the ship's movement along an edge
			progress += ShipStats.getSpeed(type) * elapsed;
			if (progress > nodePath[0].length())
			{
				// If needed, move to the next edge
				progress -= nodePath[0].length();
				nodePath.shift();
			}
		}
		else {
			progress = 0;
		}

		// Moving the ship itself, either with or without flocking
		var USE_FLOCKING = true;
		if (USE_FLOCKING)
		{
			// Get the ship's acceleration
			var acceleration = flock(elapsed);
			// Update the position and velocity
			this.vel = this.vel.addNew(acceleration.scaleNew(elapsed));
			this.pos = this.pos.addNew(this.vel.scaleNew(elapsed));
			// Rotate the sprite to match the velocity
			angle = this.vel.degrees;
		}
		else {
			// Move the ship to the correct position
			this.pos = idealPos();
			if (isMoving())
			{
				// If the ship is moving, rotate it to face along the direction of movement
				angle = nodePath[0].delta().degrees;
			}
		}

		//
		// SHIP COMBAT
		//

		for (s in listOfAllShips)
		{
			// Only fight ships of opposing factions
			if (getFaction() != s.getFaction())
			{
				var d: FlxVector = this.pos.subtractNew(s.pos);
				if (d.length < 30)
				{
					
				}
			}
		}

		//
		// SHIP GRAPHICS
		//

		// Change the sprite to show when the ship is selected
		if (isSelected)
		{
			loadGraphic("assets/images/ship_1_selected.png", false, 32, 32);
		}
		else {
			loadGraphic("assets/images/ship_1.png", false, 32, 32);
		}

		// Set the sprite's position (x,y) to match the actual position (pos)
		x = this.pos.x - origin.x;
		y = this.pos.y - origin.y;

		hpBar.x = this.x;
		hpBar.y = this.y - this.height / 2 + 5;
		hpBar.text = "" + Math.round(ShipStats.getMaxHP(type));

		super.update(elapsed);
	}

	// Returns the position of the ship
	public function getPos(): FlxVector
	{
		return this.pos;
	}

	// Returns this ship's faction
	public function getFaction(): FactionType
	{
		return faction.getFaction();
	}
}

/**
 * ShipFactory
 *
 * Fairly self-explanitory, this produces specified ships.
 *
 * @author Drew Reese
 */
class ShipFactory
{

	private var _planet: Planet;
	private var _timeSinceLast: Float;
	private var _producedShip: ShipType;

	/**
	 * Instantiates new ShipFactory registered to specified Planet.
	 * @param planet    Planet this factory produces ships from
	 */
	public function new(planet: Planet)
	{
		this._planet = planet;
		this._timeSinceLast = Math.NaN;
	}

	/**
	 * Sets the ship type procduced by this factory.
	 * @param producedShip  ShipStat of ship to produce
	 */
	public function setProduction(producedShip: ShipType): Void
	{
		this._producedShip = producedShip;
	}

	/**
	 * Produces ship after enough production time has elapsed.  Call this on every
	 * loop of update() of the parant planet.
	 * @param elapsed   time(ms) from the last call
	 * @return new specified ship, or null
	 */
	public function produceShip(elapsed: Float): Ship
	{
		this._timeSinceLast += elapsed;
		if (initial() || canProduce())
		{
			this._timeSinceLast = 0.0;
			//this._planet.playState.add(new Ship(_planet.getNode(), _planet.getFaction(), _producedShip.clone()));
			return new Ship(_planet.getNode(), _planet.getFaction(), _producedShip);
		}
		return null;
	}

	/**
	 * There are three rules to Ship Factory:
	 *  Rule #1: You do not talk about Ship Factory
	 *  Rule #2: You do NOT talk about Ship Factory
	 *  Rule #3: If this is your first time at Ship Factory, you have to produce a ship.
	 *
	 * @return true if first time at Ship Factory
	 */
	private function initial(): Bool
	{
		return Math.isNaN(this._timeSinceLast);
	}

	/**
	 * Returns true if a ship can be produced.  A ship can be produced time elapsed
	 * from last production is greater than or equal to production time.
	 * @return true iff a ship is producable
	 */
	private function canProduce(): Bool
	{
		return this._timeSinceLast >= productionTime();
	}

	/**
	 * Returns the prudction time.
	 * @return  production time
	 */
	private function productionTime(): Float
	{
		// TODO: Incorporate global capacity into this factory's production line
		return this._planet.getStats().prod;
	}

}
