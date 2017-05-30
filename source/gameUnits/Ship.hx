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
import flixel.FlxObject;
import flixel.FlxSprite;
import gameUnits.weapons.turrets.Turret.Energy;
import gameUnits.weapons.turrets.Turret.GatlingPulseLaser;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.util.helpers.FlxBounds;
import gameUnits.Ship.BluePrint;
import gameUnits.capturable.Planet;
import map.MapEdge;
import map.MapNode;
import flixel.math.FlxRandom;

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
	
	// Stores default BluePrints that can be referenced in level files. This allows for easier
	// creation and editing of game levels, and allows us to change the stats of all ships of
    // a type at once.
	private static var shipTemplateMap = new Map<String, BluePrint>();
	
	// Whether or not the templates have been initialized yet
	private static var hasInitialized = false;
	
	// Guarantees that the values in the template map have been initialized
	private static function checkInitTemplates(): Void {
		if (!hasInitialized) {
			hasInitialized = true;
			shipTemplateMap.set("frigate", new BluePrint(null, 60.0, 0.5, 100.0, 2.0, 10.0, 5.0));
		}
	}
	
	// Returns the ship template with the given name, using clone() to guarantee safety
	public static function getBluePrint(name: String): BluePrint {
		checkInitTemplates();
		return shipTemplateMap.get(name).clone();
	}
	
	
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
    private var friend:Array<Ship>;
    private var foe:Array<Ship>;
    
    private var rand:FlxRandom = new FlxRandom();
    
    /**
     * Creates new RADAR object for specified faction object.
     * @param faction   faction of the owner of this shiney new radar
     */
    public function new(faction:FactionType) {
        this.faction = faction;
        this.friend = new Array<Ship>();
        this.foe = new Array<Ship>();
    }
    
    public function setRadar(ships:Array<Ship>):Void {
        this.friend.splice(0, friend.length);
        this.foe.splice(0, foe.length);
        
        for (ship in ships) {
            if (this.faction.equals(ship.getFactionType())) {
                this.friend.push(ship);
            } else {
                this.foe.push(ship);
            }
        }
    }
    
    /**
     * Returns friendly group of ships.
     * @return  friendlies
     */
    public function getFriends():Array<Ship> {
        return this.friend.copy();
    }
    
    /**
     * Returns enemy group of ships.
     * @return  foes
     */
    public function getFoes():Array<Ship> {
        return this.foe.copy();
    }
    
    /**
     * Selects target ship at random.
     * @return  randomly chosen enemy ship
     */
    public function selectTarget():Ship {
        return rand.getObject(this.foe, 0);
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
    
    // TODO: move these stats to weapons class
    private var attackSpeed:Float;
    private var attackDamage:Float;
    
    private var sensorRange:Float;
    
    private var capturePerSecond:Float;
    
    // Radar (list of ships this ship can "interact with")
    private var radar:Radar;

    // TODO: convert these to the inherited object fields
	public var pos:FlxVector;
	public var vel:FlxVector = new FlxVector(0, 0);  // current velocity
    
    // current base node in game map
    private var node:MapNode;

    // TODO: Convert below to use inherited path field
	public var destination:MapNode; // The node this ship is moving towards
	public var nodePath:Array<MapEdge> = []; // The path this ship is moving along (if any)
	public var progress:Float; // How far along the path this ship has traveled

	public var isSelected:Bool; // Whether the player has currently selected this ship (should ideally be moved to a Player class in the future)

	//private var hpBar :FlxText;
	
	public var weapon:Energy; // This weapon is used to create ShipAttacks

	public function new(destination:MapNode, faction:Faction, blueprint:BluePrint) {
		super();
		
		// set sprite graphic (to set proper width & height for hitbox)
		switch (faction.getFactionType()) {
			case PLAYER:
				loadGraphic(AssetPaths.ship_1_player__png, false);
			case NEUTRAL:
				loadGraphic(AssetPaths.ship_1_neutral__png, false);
			default:
				loadGraphic(AssetPaths.ship_1_enemy1__png, false);
		}
        
        // Faction info
        this.faction = faction;
        
        // ship stats
        this.hull = blueprint.hull;
        this.maxVel = blueprint.maxVelocity;
        this.shield = blueprint.shield;
        this.health = blueprint.hitPoints;
        
        this.attackSpeed = blueprint.attackSpeed;
        this.attackDamage = blueprint.attackDamage;
        
        this.sensorRange = 50.0;
        this.capturePerSecond = blueprint.cps;
        
        // initialize ship radar
        this.radar = new Radar(this.faction.getFactionType());
        
        
        // TODO: organize other stuff
        
		this.destination = destination;
		
        this.node = destination;
        
		this.pos = destination.getPos();
        this.x = node.x;
        this.y = node.y;
		
        // TODO: Move weapon definition into a Weapons Class, just instantiate here
		// Creates the weapon that creates bullets
        
        this.weapon = new GatlingPulseLaser(this);
        
		//this.weapon = new FlxTypedWeapon<ShipAttack>("Laser mk. I", 
            //function(w) { return new ShipAttack(this.attackDamage, 500.0); }, 
            //FlxWeaponFireFrom.PARENT(this, new FlxBounds(this.origin, this.origin)),
			//FlxWeaponSpeedMode.SPEED(new FlxBounds(450.0, 550.0))
        //);
        //this.weapon.bulletLifeSpan = new FlxBounds(0.5, 0.5);
		//this.weapon.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
		//// firerate = (attacks/second)^-1 * (1000 ms/second) = (second/attack) * 1000 (ms/second) = 1000/attackspeed
		//this.weapon.fireRate = Math.round(1000 / this.attackSpeed);
        //FlxG.state.add(this.weapon.group); // Add weapon group here, all bullets part of this group
		
		//hpBar = new FlxText(this.x, this.y - this.height, 0, "" + stats.hitPoints, 16);
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
		switch (this.faction.getFactionType()) {
			case PLAYER:
				if (isSelected)
					loadGraphic(AssetPaths.ship_1_player_selected__png, false);
				else
					loadGraphic(AssetPaths.ship_1_player__png, false);
			//case ENEMY_1:
				//loadGraphic(AssetPaths.ship_1_enemy1__png, false);
			//case NEUTRAL:
				//loadGraphic(AssetPaths.ship_1_neutral__png, false);
			default:
				//loadGraphic(AssetPaths.ship_1_enemy1__png, false);
		}

		// Whether the ship is currently stationed at one node or is moving between nodes
		if (isMoving()) {
			// Update the ship's movement along an edge
			progress += this.maxVel * elapsed;
			if (progress > nodePath[0].length()) {
				// If needed, move to the next edge
				progress -= nodePath[0].length();
				//node.removeShip(this);
				node = nodePath.shift().n2;
				node.addShip(this);
			//} else if (node != null && this.getPosition().distanceTo(node.getPosition()) > 20) {
			} else if (node != null && !this.inSensorRange(node)) {
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
			//this.weapon.currentBullet.source = this;
            this.weapon.currentBullet.target = targetShip;
        }
        
        //*******************

		// Set the sprite's position (x,y) to match the actual position (pos)
		x = this.pos.x - origin.x;
		y = this.pos.y - origin.y;

		//hpBar.x = this.x;
		//hpBar.y = this.y - this.height / 2 + 5;
		//hpBar.text = "" + Math.round(stats.hitPoints);

		super.update(elapsed);
	}
    
    /**
     * Applies incoming damage/health regeneration to this ship.
     * If damage is less than 0, it is applied as a health bonus, if greater
     * than 0, it is applied against this ship's shields first, then applied
     * as damage.
     * @param Damage    incoming damage/health regen
     */
    override public function hurt(Damage:Float):Void {
        if (Damage > 0.0) {
            Damage *= this.shield;  // reduce damage by shield amount
        }
        //trace(this.toString() + " took " + Damage + " damage.");
        super.hurt(Damage);
    }
    
    override public function destroy():Void {
        //trace("ship destroyed: " + this.toString());
        if (this.node != null) {
            this.node.removeShip(this);
            //trace("\tremoved from node: " + this.node.toString());
        }
        super.destroy();
    }
    
    public function getMaxVelocity():Float {
        return this.maxVel;
    }
    
    // RADAR Functions
    
    public function inSensorRange(object:FlxObject):Bool {
        //if (this == ship) {
        if (object == null || this == object) {
            return false;
        }
        return this.getPosition().distanceTo(object.getPosition()) <= this.sensorRange;
    }
    
    public function setRadar(ships:Array<Ship>):Void {
        this.radar.setRadar(ships);
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
