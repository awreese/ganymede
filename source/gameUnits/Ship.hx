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

package gameUnits;

import faction.Faction;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import gameUnits.Ship.ShipStat;
import gameUnits.capturable.Planet;
import map.MapEdge;
import map.MapNode;

/**
 * Various ship types that exist in-game.
 *
 * @author Drew Reese
 */
enum ShipType {
	FRIGATE;
	DESTROYER;
	CRUISER;
	BATTLECUISER;
	BATTLESHIP;
	FIGHTER;
	CORVETTE;
	CAPITAL;
	PATROL_CRAFT;
}

/**
 * ShipGroup is a group of ships
 */
typedef ShipGroup = FlxTypedGroup<Ship>;

/**
 * Ship statistic type.
 *
 * This defines ship types by specifying the ShipType and statistics.  Ship
 * statistics must be instanited or cloned before being passed into
 * constructors for ships
 *
 * @author Drew Reese
 */
class ShipStat {
	// General
	public var hull: ShipType;	// ship type
	public var speed: Float;	// speed

	/*
	 * Defense
	 *
	 * Damage recieved is (incoming attack power ) x hp
	 *  dmg = enemy.ap * sh
	 * 	hp -= dmg
	 */
	public var sh: Float;		// shields [0.1, 0.9]
	public var hp: Float;		// hitpoints

	/*
	 * Offense
	 *
	 * Damage sent is (attack power) every (attack speed) seconds.
	 * 	dps = as * ap
	 *
	 * Capturing is structure capture points per second
	 */
	public var as: Float;		// attack speed (attacks per second)
	public var ap: Float;		// attack power (damage per attack)
	public var cps: Float;		// capture power (capture points per second)

	/**
	 * Defines a new Ship type.
	 * - Combines ShipType with a list of specs
	 *
	 * @param hull = null
	 * @param speed = 20.0
	 * @param sh = 0.5 shields
	 * @param hp = 100.0 hitpoints
	 * @param as = 2.0 attacks/second
	 * @param ap = 10.0 damage/attack
	 * @param cps = 5.0 capture points/second
	 */
	public function new(?hull = null,
						?speed = 20.0,
						?sh = 0.5,
						?hp = 100.0,
						?as = 2.0,
						?ap = 10.0,
						?cps = 5.0)
	{
		this.hull = (hull == null) ? FRIGATE : hull;
		this.speed = speed;
		this.sh = sh;
		this.hp = hp;
		this.as = as;
		this.ap = ap;
		this.cps = cps;
	}

	/**
	 * Copies and returns a clone of this ship definition.
	 * @return clone of this ShipStat
	 */
	public function clone():ShipStat {
		return new ShipStat(this.hull, this.speed, this.sh, this.hp, this.as, this.ap, this.cps);
	}
}

/**
 *
 * @author Daisy
 * @author Rory Soiffer
 * @author Drew Reese
 */
class Ship extends FlxSprite {

	//private var playState: PlayState; // NO, this is bad style.  If anything access what you want via getter.  I'm trying to push all these calls like this down to the node that everything sits on.  Way too much coupling going on!!

	// Parent/Faction Info
	private var homePlanet:Planet;
	private var faction:Faction;

	public var pos:FlxVector;
	public var vel:FlxVector = new FlxVector(0,0);  // current velocity
	public var stats:ShipStat; // General stats (should be split into type-specific vs. ship-specific)

	public var destination:MapNode; // The node this ship is moving towards
	public var nodePath:Array<MapEdge> = []; // The path this ship is moving along (if any)
	public var progress:Float; // How far along the path this ship has traveled

	public var isSelected:Bool; // Whether the player has currently selected this ship (should ideally be moved to a Player class in the future)

	public var listOfAllShips:Array<Ship> = []; // The list of all ships, which is needed for flocking

	private var hpBar:FlxText;

	//public function new(playState: PlayState, destination: MapNode, faction: Faction, shipStats: ShipStat) 	{
	public function new(destination: MapNode, faction: Faction, shipStats: ShipStat) {
		super();
		//this.playState = playState;
		this.destination = destination;
		this.faction = faction;
		this.stats = shipStats;
		this.pos = destination.getPos();

		loadGraphic("assets/images/ship_1.png", false, 32, 32);

		hpBar = new FlxText(this.x, this.y - this.height, 0, "" + stats.hp, 16);
		//FlxG.state.add(hpBar);
	}

	// Moves the ship, following flocking behavior
	public function flock(elapsed: Float): Void {
		// All the forces acting on the ship
		var toDest = idealPos().subtractNew(this.pos);
		var desiredSpeed = this.vel.normalize().scaleNew(stats.speed).subtractNew(this.vel);
		var noise = new FlxVector(Math.random() - .5, Math.random() - .5);
		var seperation = new FlxVector(0, 0);
		var alignment = new FlxVector(0, 0);
		var cohesion = new FlxVector(0, 0);

		for (s in listOfAllShips) {
			// Only flock with other ships of your faction
			if (s != this && getFaction() == s.getFaction()) {
				var d: FlxVector = this.pos.subtractNew(s.pos);
				if (d.length < 30) {
					seperation = seperation.addNew(d.scaleNew(1/d.lengthSquared));
					alignment = alignment.addNew(s.vel.subtractNew(this.vel));
					cohesion = cohesion.addNew(d.normalize());
				}
			}
		}

		// Compute the net acceleration, scaling each component by a constant to make the final motion look good
		var acceleration = new FlxVector(0, 0)
		.addNew(toDest.scaleNew(.05 * toDest.length))
		.addNew(desiredSpeed.scaleNew(50))
		.addNew(noise.scaleNew(10))
		.addNew(seperation.scaleNew(100))
		.addNew(alignment.scaleNew(.5))
		.addNew(cohesion.scaleNew(0.5));

		// Update the position and velocity
		this.vel = this.vel.addNew(acceleration.scaleNew(elapsed));
		this.pos = this.pos.addNew(this.vel.scaleNew(elapsed));
	}

	// Returns where along its path the ship should be right now if it weren't for flocking behavior
	public function idealPos(): FlxVector {
		if (isMoving()) {
			return nodePath[0].interpDist(progress);
		} else {
			return destination.getPos();
		}
		//return nodePath[0].interpDist(progress);
	}

	// Returns whether the ship is currently moving between nodes or is at a node
	public function isMoving(): Bool {
		return nodePath.length > 0;
	}

	// Orders the ship to follow the shortest possible path to a given node
	public function pathTo(n: MapNode): Void {
		if (isMoving()) {
			var e = nodePath[0];
			nodePath = nodePath[0].pathTo(n, progress);
			if (nodePath[0].n1 != e.n1) {
				progress = e.length() - progress;
			}
		} else {
			nodePath = destination.pathTo(n);
		}
		destination = n;
	}

	override public function update(elapsed:Float):Void {
		// check faction, take appropriate actions, etc..
		/*switch (this.faction.getFaction())  {
			case NOP:
				trace("NOP Ship " + this.faction.getColor().toWebString);
			case PLAYER:
				trace("Player Ship " + this.faction.getColor().toWebString);
			case NEUTRAL:
				trace("Neutral Ship " + this.faction.getColor().toWebString);
			default:
				trace("Enemy Ship #" + this.faction.getColor().toWebString);
		}*/

		// Change the sprite to show when the ship is selected
		if (isSelected) {
			loadGraphic("assets/images/ship_1_selected.png", false, 32, 32);
		} else {
			loadGraphic("assets/images/ship_1.png", false, 32, 32);
		}

		//
		// TODO: Handle Combat here
		//

		// Whether the ship is currently stationed at one node or is moving between nodes
		if (isMoving()) {
			// Update the ship's movement along an edge
			progress += stats.speed * elapsed;
			if (progress > nodePath[0].length()) {
				// If needed, move to the next edge
				progress -= nodePath[0].length();
				nodePath.shift();
			}
		} else {
			progress = 0;
		}

		// Moving the ship itself, either with or without flocking
		var USE_FLOCKING = false;
		if (USE_FLOCKING) {
			// Accelerate the ship correctly
			flock(elapsed);
			// Rotate the sprite to match the velocity
			angle = this.vel.degrees;
		} else {
			// Move the ship to the correct position
			this.pos = idealPos();
			if (isMoving()) {
				// If the ship is moving, rotate it to face along the direction of movement
				angle = nodePath[0].delta().degrees;
			}
		}

		// Set the sprite's position (x,y) to match the actual position (pos)
		x = this.pos.x - origin.x;
		y = this.pos.y - origin.y;

		hpBar.x = this.x;
		hpBar.y = this.y - this.height / 2 + 5;
		hpBar.text = "" + Math.round(stats.hp);

		super.update(elapsed);
	}

	// Returns the position of the ship
	public function getPos(): FlxVector {
		return this.pos;
	}

	// Returns this ship's faction
	public function getFaction(): FactionType {
		return faction.getFactionType();
	}
}

/**
 * ShipFactory
 *
 * Fairly self-explanitory, this produces specified ships.
 *
 * @author Drew Reese
 */
class ShipFactory {

	private var _planet:Planet;
	private var _timeSinceLast:Float;
	private var _producedShip:ShipStat;

	/**
	 * Instantiates new ShipFactory registered to specified Planet.
	 * @param planet    Planet this factory produces ships from
	 */
	public function new(planet:Planet) {
		this._planet = planet;
		this._timeSinceLast = Math.NaN;
	}

	/**
	 * Sets the ship type procduced by this factory.
	 * @param producedShip  ShipStat of ship to produce
	 */
	public function setProduction(producedShip:ShipStat):Void {
		this._producedShip = producedShip;
	}

	/**
	 * Produces ship after enough production time has elapsed.  Call this on every
	 * loop of update() of the parant planet.
	 * @param elapsed   time(ms) from the last call
	 * @return new specified ship, or null
	 */
	public function produceShip(elapsed:Float):Ship {
		this._timeSinceLast += elapsed;
		if (initial() || canProduce()) {
			this._timeSinceLast = 0.0;
			//this._planet.playState.add(new Ship(_planet.getNode(), _planet.getFaction(), _producedShip.clone()));
			return new Ship(_planet.getNode(), _planet.getFaction(), _producedShip.clone());
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
	private function initial():Bool {
		return Math.isNaN(this._timeSinceLast);
	}

	/**
	 * Returns true if a ship can be produced.  A ship can be produced time elapsed
	 * from last production is greater than or equal to production time.
	 * @return true iff a ship is producable
	 */
	private function canProduce(): Bool {
		return this._timeSinceLast >= productionTime();
	}

	/**
	 * Returns the prudction time.
	 * @return  production time
	 */
	private function productionTime():Float {
		// TODO: Incorporate global capacity into this factory's production line
		return this._planet.getStats().prod;
	}

}
