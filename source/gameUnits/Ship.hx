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
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.util.helpers.FlxBounds;
import gameUnits.Ship.BluePrint;
import gameUnits.capturable.Planet;
import map.MapEdge;
import map.MapNode;

/**
 * Various ship hull types that exist in-game.
 *
 * @author Drew Reese
 */
enum HullType {
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
 * Ship blueprint type.
 *
 * This defines ship types by specifying the HullType and statistics.
 *
 * @author Drew Reese
 */
class BluePrint {
	// General
	public var hull:HullType;	    // ship hull type
	public var maxVelocity:Float;	// maximum ship velocity

	/*
	 * Defense
	 *
	 * Damage recieved is (incoming attack power ) x hp
	 *  dmg = enemy.ap * sh
	 * 	hp -= dmg
	 */
	public var shield:Float;	// shields [0.1, 0.9]
	public var hitPoints:Float;	// hitpoints

	/*
	 * Offense
	 *
	 * Damage sent is (attack damage) every (attack speed) seconds.
	 * 	dps = attackSpeed * attackDamage
	 *
	 * Capturing is structure capture points per second
	 */
	public var attackSpeed:Float;	// attack speed (attacks per second)
	public var attackDamage:Float;	// attack power (damage per attack)
	public var cps: Float;		    // capture power (capture points per second)

	/**
	 * Defines a new ship blueprint.
	 * - Combines HullType with a list of specs
	 *
	 * @param hull = null
	 * @param maxVelocity = 20.0
	 * @param sh = 0.5 shields
	 * @param hp = 100.0 hitpoints
	 * @param as = 2.0 attacks/second
	 * @param ap = 10.0 damage/attack
	 * @param cps = 5.0 capture points/second
	 */
	public function new(?hull = null,
						?maxVel = 20.0,
						?sh = 0.5,
						?hp = 100.0,
						?as = 2.0,
						?ad = 10.0,
						?cps = 5.0)
	{
		this.hull = (hull == null) ? FRIGATE : hull;
		this.maxVelocity = maxVel;
		this.shield = sh;
		this.hitPoints = hp;
		this.attackSpeed = as;
		this.attackDamage = ad;
		this.cps = cps;
	}

	/**
	 * Copies and returns a clone of this ship blueprint.
	 * @return clone of this ShipStat
	 */
	public function clone():BluePrint {
		return new BluePrint(this.hull, this.maxVelocity, this.shield, this.hitPoints, this.attackSpeed, this.attackDamage, this.cps);
	}
}

/**
 * Radar
 * Represents the ships that can be interacted with.
 * Friends are ships that can be flocked with.
 * Foes are ships that can be targeted through combat.
 * 
 * @author Drew Reese
 */
private class Radar {
    
    private var faction:FactionType;
    private var range:Float;
    private var friend:ShipGroup;
    private var foe:ShipGroup;
    
    /**
     * Creates new RADAR object for specified faction object.
     * @param faction   faction of the owner of this shiney new radar
     */
    public function new(faction:FactionType, range:Float = 50.0) {
        this.faction = faction;
        this.range = range;
        this.friend = new ShipGroup();
        this.foe = new ShipGroup();
    }
    
    /**
     * Adds specified ship to this ship's RADAR.
     * @param ship  ship to add to this RADAR
     */
    public function addShip(ship:Ship):Void {
        if (this.faction.equals(ship.getFactionType())) {
            this.friend.add(ship);
        } else {
            this.foe.add(ship);
        }
    }
    
    /**
     * Removes specifiec ship from this ship's RADAR.
     * @param ship  ship to remove from this RADAR
     */
    public function removeShip(ship:Ship):Void {
        if (this.faction.equals(ship.getFactionType())) {
            this.friend.remove(ship);
        } else {
            this.foe.remove(ship, true);
        }
    }
    
    /**
     * Returns the range of this radar.
     * @return  rage of this radar
     */
    public function getRadarRange():Float {
        return this.range;
    }
    
    /**
     * Returns friendly group of ships.
     * @return  friendlies
     */
    public function getFriends():ShipGroup {
        return this.friend;
    }
    
    /**
     * Returns enemy group of ships.
     * @return  foes
     */
    public function getFoes():ShipGroup {
        return this.foe;
    }
    
    /**
     * Selects target ship at random.
     * @return  randomly chosen enemy ship
     */
    public function selectTarget():Ship {
        return this.foe.getRandom();
    }
}

/**
 *
 * @author Daisy
 * @author Rory Soiffer
 * @author Drew Reese
 */
class Ship extends FlxSprite {

	// Parent/Faction Info
	private var homePlanet:Planet; // probably not needed
	private var faction:Faction;
    
    // Ship specs
    private var hull:HullType;
    private var maxVel:Float;
    private var shield:Float;
    // health takes hitpoints
    private var attackSpeed:Float;
    private var attackDamage:Float;
    private var capturePerSecond:Float;
    
    // Radar (list of ships this ship can "interact with")
    private var radar:Radar;

    // TODO: convert these to the inherited object fields
	public var pos:FlxVector;
	public var vel:FlxVector = new FlxVector(0, 0);  // current velocity
    
    // TODO: fields stored internally, no need to hold reference to BP
	public var stats:BluePrint; // General stats (should be split into type-specific vs. ship-specific)
    
    // current base node in game map
    private var node:MapNode;

    // TODO: Convert below to use inherited path field
	public var destination:MapNode; // The node this ship is moving towards
	public var nodePath:Array<MapEdge> = []; // The path this ship is moving along (if any)
	public var progress:Float; // How far along the path this ship has traveled

	public var isSelected:Bool; // Whether the player has currently selected this ship (should ideally be moved to a Player class in the future)

	private var hpBar :FlxText;
	
	public var weapon:FlxTypedWeapon<ShipAttack>; // This weapon is used to create ShipAttacks

	public function new(destination:MapNode, faction:Faction, blueprint:BluePrint) {
		super();
        
        // Faction info
        this.faction = faction;
        
        // ship stats
        this.hull = blueprint.hull;
        this.maxVel = blueprint.maxVelocity;
        this.shield = blueprint.shield;
        this.health = blueprint.hitPoints;
        this.attackSpeed = blueprint.attackSpeed;
        this.attackDamage = blueprint.attackDamage;
        this.capturePerSecond = blueprint.cps;
        
        // initialize ship radar
        this.radar = new Radar(this.faction.getFactionType(), 50.0);
        
        
        // TODO: organize other stuff
        
		this.destination = destination;
		
        this.node = destination;
        
		this.stats = blueprint;
		this.pos = destination.getPos();
        this.x = node.x;
        this.y = node.y;

		// Creates the weapon that creates bullets
		this.weapon = new FlxTypedWeapon<ShipAttack>("Laser mk. I", 
            function(w) { return new ShipAttack(stats.attackDamage, 500.0); }, 
            FlxWeaponFireFrom.PARENT(this, new FlxBounds(this.origin, this.origin)),
			FlxWeaponSpeedMode.SPEED(new FlxBounds(500.0, 500.0))
        );
		this.weapon.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
		this.weapon.fireRate = Math.round(1000 / stats.attackSpeed);
        FlxG.state.add(this.weapon.group); // Add weapon group here, all bullets part of this group
		
		switch (this.faction.getFactionType()) {
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

		hpBar = new FlxText(this.x, this.y - this.height, 0, "" + stats.hitPoints, 16);
		//FlxG.state.add(hpBar);
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
		// Change the sprite to show when the ship is selected
		if (isSelected) {
			loadGraphic("assets/images/ship_1_selected.png", false, 32, 32);
		} else {
			if (this.faction.getFactionType() == FactionType.PLAYER) {
				loadGraphic(AssetPaths.ship_1__png, false);
			}
		}

		// Whether the ship is currently stationed at one node or is moving between nodes
		if (isMoving()) {
			// Update the ship's movement along an edge
			progress += stats.maxVelocity * elapsed;
			if (progress > nodePath[0].length()) {
				// If needed, move to the next edge
				progress -= nodePath[0].length();
				//node.removeShip(this);
				node = nodePath.shift().n2;
				node.addShip(this);
			} else if (node != null && this.getPosition().distanceTo(node.getPosition()) > 20) {
				node.removeShip(this); // detach this ship from node if distance is > than 20
				node = null; // set node to null
			}
		} else {
			progress = 0;
		}

		// Updates the ship's position and angle based on its velocity
		this.pos = this.pos.addNew(this.vel.scaleNew(elapsed));
		angle = this.vel.degrees;
        
        //*******************
        // combat
        var targetShip = this.radar.selectTarget();
        if (targetShip != null && this.weapon.fireAtTarget(targetShip)) {
            this.weapon.currentBullet.target = targetShip;
        }
        
        //*******************

		// Set the sprite's position (x,y) to match the actual position (pos)
		x = this.pos.x - origin.x;
		y = this.pos.y - origin.y;

		hpBar.x = this.x;
		hpBar.y = this.y - this.height / 2 + 5;
		hpBar.text = "" + Math.round(stats.hitPoints);

		super.update(elapsed);
	}
    
    // RADAR Functions
    
    public function withinRadarRange(ship:Ship):Bool {
        return this.getPosition().distanceTo(ship.getPosition()) <= this.radar.getRadarRange();
    }
    
    public function addToRadar(ship:Ship):Void {
        this.radar.addShip(ship);
    }
    
    public function removeFromRadar(ship:Ship):Void {
        this.radar.removeShip(ship);
    }
    
    public function getRandomTarget():Ship {
        return this.radar.selectTarget();
    }
    
    
    
    public function getCPS():Float {
        return this.capturePerSecond;
    }
    
    

	// Returns the position of the ship
	public function getPos(): FlxVector {
		return this.pos;
	}

	// Returns this ship's faction
	public function getFactionType(): FactionType {
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
	private var _producedShip:BluePrint;

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
	public function setProduction(producedShip:BluePrint):Void {
		this._producedShip = producedShip;
	}

	/**
	 * Produces ship after enough production time has elapsed.  Call this on every
	 * loop of update() of the parant planet.
	 * @param elapsed   time(ms) from the last call
	 * @return new specified ship, or null
	 */
	public function produceShip(elapsed:Float):Bool {
		this._timeSinceLast += elapsed;
		if (initial() || canProduce()) {
			this._timeSinceLast = 0.0;
			//this._planet.playState.add(new Ship(_planet.getNode(), _planet.getFaction(), _producedShip.clone()));
			var ship:Ship =  new Ship(_planet.getNode(), _planet.getFaction(), _producedShip.clone());
            
            // TODO: add ship to state's shipgroupByFaction map to be rendered
            // TODO: add ship to node for tracking
            //FlxG.state.
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
