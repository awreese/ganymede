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
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxWaveEffect.FlxWaveDirection;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import gameUnits.Ship.ShipStat;
import gameUnits.capturable.Planet;
import haxe.Serializer;
import map.MapEdge;
import map.MapNode;

/**
 * Various ship types that exist in-game.
 *
 * @author Drew Reese
 */
enum ShipType
{
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
 * Ship statistic type.
 *
 * Ship statistics must be instanited and passed into constructors for ships
 *
 * @author Drew Reese
 */
class ShipStat {
	// General
	public var hull: ShipType;	// ship type
	//public var pos: FlxVector;	// position
	//public var vel: FlxVector;  // current velocity
	public var vmax: Float;	// max velocity

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
	public var cp: Float;		// capture power (capture points per second)

	public function new(?hull = null,
						?vmax = 20.0,
						?sh = 0.5,
						?hp = 100.0,
						?as = 2.0,
						?ap = 10.0,
						?cp = 5.0)
	{
		this.hull = hull;
		this.vmax = vmax;
		this.sh = sh;
		this.hp = hp;
		this.as = as;
		this.ap = ap;
		this.cp = cp;
        
        this.clone();
	}
    
    public function clone():ShipStat {
        var serializer = new Serializer();
        serializer.serialize(this);
        
        var s = serializer.toString();
        trace("shipStat: " + s);
        
        return null;
    }
    
    
}

/**
 *
 * @author Daisy
 * @author Rory Soiffer
 * @author Drew Reese
 */
class Ship extends FlxSprite
{

	private var playState: PlayState;

	// Parent/Faction Info
	private var homePlanet: gameUnits.capturable.Planet;
	private var faction: Faction;

    //private var position:FlxPoint; FlxObject already has x, y coordinate
    private var vel:FlxVector;  // We should really look into using FlxObject's velocity field instead, why re-invent the wheel?
    
	public var stats: ShipStat; // General stats (should be split into type-specific vs. ship-specific)
    
    /*
     * Ok, I see what you mean here (above).
     * 
     * Agreed.
     * 
     * Ship should have position, velocity, and speed (which is really just velocity.length) fields
     * ShipStat should just be statistics about classes of ships
     * 
     */
    

	public var destination: MapNode; // The node this ship is moving towards
	public var nodePath: Array<MapEdge> = []; // The path this ship is moving along (if any)
	public var progress: Float; // How far along the path this ship has traveled

	public var isSelected: Bool; // Whether the player has currently selected this ship (should ideally be moved to a Player class in the future)

	private var hpBar :FlxText;

	public function new(playState: PlayState, destination: MapNode, faction: Faction, shipStats: ShipStat)
	{
		super();
		this.playState = playState; // why is playstate stuff here?  play state is level stuff, not ship stuff
		this.destination = destination;
		this.faction = faction;
		this.stats = shipStats;
        
		//stats.pos = destination.pos;
        
        //this.position = destination.pos;
        this.x = destination.pos.x;
        this.y = destination.pos.y;
        
        this.vel = new FlxVector(0, 0);

		loadGraphic("assets/images/ship_1.png", false, 32, 32);

		hpBar = new FlxText(this.x, this.y - this.height, 0, "" + stats.hp, 16);
		FlxG.state.add(hpBar);
	}

	// Moves the ship, following flocking behavior
	public function flock(elapsed: Float): Void
	{
		//var toDest = idealPos().subtractNew(this.getPosition());
        var p = idealPos().subtractPoint(this.getPosition());
		var toDest = new FlxVector(p.x, p.y);
		//var desiredSpeed = stats.vel.normalize().scaleNew(stats.speed).subtractNew(stats.vel);
		var desiredSpeed = this.vel.normalize().scaleNew(this.vel.length).subtractNew(this.vel);
		var noise = new FlxVector(Math.random() - .5, Math.random() - .5);
		var seperation = new FlxVector(0, 0);
		var alignment = new FlxVector(0, 0);
		var cohesion = new FlxVector(0, 0);

		for (s in playState.grpShips)
		{
			if (s != this && getFaction() == s.getFaction())
			{
				//var d: FlxVector = stats.pos.subtractNew(s.stats.pos);
                var p = this.getPosition().subtractPoint(s.getPosition());
				var d: FlxVector = new FlxVector(p.x, p.y);
				if (d.length < 30)
				{
					seperation = seperation.addNew(d.scaleNew(1/d.lengthSquared));
					//alignment = alignment.addNew(s.stats.vel.subtractNew(stats.vel));
					alignment = alignment.addNew(s.vel.subtractNew(this.vel));
					cohesion = cohesion.addNew(d.normalize());
				}
			}
		}

		var mod = new FlxVector(0, 0)
		.addNew(toDest.scaleNew(.05 * toDest.length))
		.addNew(desiredSpeed.scaleNew(50))
		.addNew(noise.scaleNew(10))
		.addNew(seperation.scaleNew(100))
		.addNew(alignment.scaleNew(.5))
		.addNew(cohesion.scaleNew(0.5));

		//stats.vel = stats.vel.addNew(mod.scaleNew(elapsed));
		//stats.pos = stats.pos.addNew(stats.vel.scaleNew(elapsed));
        this.vel = this.vel.addNew(mod.scaleNew(elapsed));
		var newpos = this.getPosition().addPoint(this.vel.scaleNew(elapsed));
        this.x = newpos.x;
        this.y = newpos.y;
	}

	// Returns where along its path the ship should be right now if it weren't for flocking behavior
	public function idealPos(): FlxPoint
	{
		if (isMoving())
		{
			return nodePath[0].interpDist(progress);
		}
		else {
			return new FlxPoint(destination.pos.x, destination.pos.y);
		}
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
		// check faction, take appropriate actions, etc..
		switch (this.faction.getFaction())
		{
			case NOP:
				trace("NOP Ship " + this.faction.getColor().toWebString);
			case PLAYER:
				trace("Player Ship " + this.faction.getColor().toWebString);
			case NEUTRAL:
				trace("Neutral Ship " + this.faction.getColor().toWebString);
			default:
				trace("Enemy Ship #" + this.faction.getColor().toWebString);
		}

		// Change the sprite to show when the ship is selected
		if (isSelected)
		{
			loadGraphic("assets/images/ship_1_selected.png", false, 32, 32);
		}
		else {
			loadGraphic("assets/images/ship_1.png", false, 32, 32);
		}

		//
		// TODO: Handle Combat here
		//

		flock(elapsed);

		// Whether the ship is currently stationed at one node or is moving between nodes
		if (isMoving())
		{
			//stats.pos = idealPos();
			//angle = nodePath[0].delta().degrees;

			// Update the ship's movement along an edge
			//progress += stats.speed * elapsed;
			progress += this.vel.length * elapsed;
			if (progress > nodePath[0].length())
			{
				progress -= nodePath[0].length();
				nodePath.shift();
			}
		}
		else {
			//stats.pos = destination.pos;

			progress = 0;
		}

		// Set the sprite's position (x,y) to match the actual position (pos)
		x = this.x - origin.x;
		y = this.y - origin.y;

		// Rotate the ship to match its velocity
		angle = this.vel.degrees;

		hpBar.x = this.x;
		hpBar.y = this.y - this.height / 2 + 5;
		hpBar.text = "" + Math.round(stats.hp);

		super.update(elapsed);
	}

	// Returns the position of the ship
	public function getPos(): FlxPoint
	{
		//return stats.pos;
        return new FlxPoint(this.x, this.y);
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
 * Fairly self-explanitory, this produces specific ships.
 *
 * @author Drew Reese
 */
class ShipFactory
{

	private var _planet:Planet;
	private var _producedShip:ShipStat;

	// TODO: Finish this class

	public function new(planet:Planet)
	{
		this._planet = planet;

	}

	public function setProduction(producedShip:ShipStat):Void
	{
		this._producedShip = producedShip;
	}

}
