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

package gameUnits.capturable;

import flash.display.FrameLabel;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import gameUnits.Ship.ShipFactory;
import gameUnits.capturable.Capturable;
import gameUnits.Ship.ShipStat;
import gameUnits.Ship.ShipType;
import gameUnits.capturable.Planet.PlanetStat;
import js.html.svg.AnimatedBoolean;
import map.MapNode;
import faction.Faction;

/**
 * Planet statistic type
 *
 * This defines planet types by specifying thier statistics.  Planet statistics 
 * must be instanitated or cloned before being passed into constructors for planets.
 *
 * @author Drew Reese
 */
class PlanetStat
{
	// Class Constants
	public static inline var MAX_CAPACITY_LEVEL:Int = 5; // default as 5 for now
	public static inline var MAX_TECH_LEVEL:Int = 5; // default as 5 for now

	// General
	public var cap: Int;			// ship capacity
	public var prod: Float;			// ship production rate in seconds
	public var prod_thresh: Float;	// production rate threshold for falloff
	public var ship: ShipStat;      // ship type for production

	// Levels
	public var cap_lvl: Int;		// current capacity level
	public var tech_lvl: Int;		// current tech level

	// Upgrades/costs
	public var base_cost: Int;		// base upgrade cost in ships
	public var cap_per_lvl: Int;	// capacity increase per level
	public var tech_per_lvl: Float;	// tech increase per level

    /**
     * Defines a new Planet Stat.
     * 
     * @param ship = null
     * @param cap = 10
     * @param prod = 5.0
     * @param prod_thresh = 0.5
     * @param cap_lvl = 0
     * @param tech_lvl = 0
     * @param base_cost = 10
     * @param cap_per_lvl=5
     * @param tech_per_lvl=2
     */
	public function new(?ship = null, ?cap = 10, ?prod = 5.0, ?prod_thresh = 0.5,
						?cap_lvl = 0, ?tech_lvl = 0,
						?base_cost = 10,
						?cap_per_lvl=5, ?tech_per_lvl=2.0)
	{

		this.cap = cap;
		this.prod = prod;
		this.prod_thresh = prod_thresh;
		this.ship = ship;
		this.cap_lvl = cap_lvl;
		this.tech_lvl = tech_lvl;
		this.base_cost = base_cost;
		this.cap_per_lvl = cap_per_lvl;
		this.tech_per_lvl = tech_per_lvl;
	}
    
    /**
     * Copies and returns a clone of this planet definition.
     * @return clone of this PlanetStat
     */
    public function clone():PlanetStat {
        return new PlanetStat(this.ship.clone(), this.cap, this.prod, this.prod_thresh, 
                            this.cap_lvl, this.tech_lvl,
                            this.base_cost, 
                            this.cap_per_lvl, this.tech_per_lvl);
    }
}

/**
 * Planets
 * Planets are capturable, and produce ship units once controlled.  They
 * can be upgraded.
 *
 * @author Daisy
 * @author Drew Reese
 *
 * Contains the property of the Planets
 * Stores the faction, capacity, production rate, etc
 */
class Planet extends Capturable
{
	/*
	 * From Capturable Class
	 *
	 * parent node: this.node
	 * faction:     this.faction
	 *
	 */

	public var playState: PlayState;

	// internal fields
	private var pStats: PlanetStat;

	private var numShips:Map<FactionType, Int>;
	private var shipTimer:Float;

	// TODO: Move this to captureHUD in Capturable class
	// progress bar
	private var factionProgress:Int;
	private var currFactionBar:FlxBar;
	private var invadingFactionBar:FlxBar;
	private var invadeFaction:Faction;
    
    // Ship Factory
    private var shipFactory:ShipFactory;

	// levels for the planet
	private var shipText:FlxText;

	public function new(playState: PlayState, location: MapNode, faction: Faction, pstats: PlanetStat)
	{
		// set position of the planet
		//super(location.pos.x - (MapNode.NODE_SIZE / 2), location.pos.y - (MapNode.NODE_SIZE / 2));
		super(location, faction);

		this.playState = playState;

		// Load graphics and any faction specific items
		switch (this.faction.getFaction())
		{
			case PLAYER:
				factionProgress = 100;
			case ENEMY_1:
				factionProgress = -100;
			case ENEMY_2:
				factionProgress = -100;
			case ENEMY_3:
				factionProgress = -100;
			case ENEMY_4:
				factionProgress = -100;
			case ENEMY_5:
				factionProgress = -100;
			case ENEMY_6:
				factionProgress = -100;
			case NEUTRAL:
				factionProgress = 100;
			default:
				factionProgress = 0;
		}

		setSprite();

		// TODO: Move this to captureHUD in Capturable class
		// create capture bar
		currFactionBar = new FlxBar(this.x - this.graphic.width / 4, this.y + this.graphic.height + 2, LEFT_TO_RIGHT, 50, 10);
		currFactionBar.createColoredFilledBar(faction.getColor(), true);
		invadingFactionBar = new FlxBar(this.x - 8, this.y + 36, RIGHT_TO_LEFT, 50, 10);
		currFactionBar.visible = true;
		invadingFactionBar.visible = false;
		invadingFactionBar.createColoredFilledBar(FlxColor.WHITE, true);

		// set levels
		//capacityLevel = capLevel;
		//this.techLevel = techLevel;
		this.pStats = pstats;
        
        this.shipFactory = new ShipFactory(this);
        this.shipFactory.setProduction(this.pStats.ship);

		// set other
		//capacity = capacityLevel * 5;
		//productionRate = 1;
		numShips = new Map<FactionType, Int>();
		numShips.set(FactionType.PLAYER, 0);
		numShips.set(FactionType.ENEMY_1, 0);
		numShips.set(FactionType.NEUTRAL, 0);
		shipTimer = 0;

		currFactionBar.value = Math.abs(factionProgress);
		invadingFactionBar.value = 0;
		FlxG.state.add(currFactionBar);
		FlxG.state.add(invadingFactionBar);
		shipText = new FlxText(this.x, this.y + 40, 0, "0", 16);
		FlxG.state.add(shipText);
	}

	override public function update(elapsed:Float):Void
	{
		var totalShip:Int = 0;
		for (f in numShips.keys())
		{
			totalShip += numShips.get(f);
		}
		shipText.text = "" + totalShip;
		//if (this.faction == Faction.PLAYER) {
		//// draw player planet
		//loadGraphic(AssetPaths.player_planet_1__png, false, 16, 16);
		//} else if (this.faction == Faction.ENEMY_1) {
		//// draw enemy planet
		//loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
		//} else if (this.faction == Faction.NEUTRAL) {
		//// draw neutral planet
		//loadGraphic(AssetPaths.neutral_planet_1__png, false, 16, 16);
		//} else {
		//// draw uncontrolled planet
		//loadGraphic(AssetPaths.uncontrolled_planet_1__png, false, 16, 16);
		//}  these were already set, only need to change on change of possession

		// Take faction action
		/*switch(this.faction) {
			case Faction.NOP:
				trace("Open Planet");
			case Faction.NEUTRAL:
				trace("Neutral Planet");
			case Faction.PLAYER:
				trace("Player Planet");
			default:
				// Not player, neutral, or NOP planet => do enemy stuff
				trace("Enemy Planet: " + this.faction);
		}*/

        var newShip = shipFactory.produceShip(elapsed);
        if (newShip != null) {
            // add new ship to underlying node when api available
        }
        
		capturing();

		// setting which bar is visible
		switch (this.faction.getFaction())
		{
			case PLAYER:
				currFactionBar.visible = factionProgress >= 0;
				invadingFactionBar.color = FlxColor.RED;
				invadingFactionBar.visible = factionProgress < 0;
			case ENEMY_1:
				currFactionBar.visible = factionProgress <= 0;
				invadingFactionBar.color = FlxColor.BLUE;
				invadingFactionBar.visible = factionProgress > 0;
			default:
				currFactionBar.visible = false;
				invadingFactionBar.visible = true;
				if (factionProgress >= 0)
				{
					invadingFactionBar.color = FlxColor.BLUE;
				}
				else
				{
					invadingFactionBar.color = FlxColor.RED;
				}
		}
		if (currFactionBar.visible)
		{
			currFactionBar.value = Math.abs(factionProgress);
		}
		else if (invadingFactionBar.visible)
		{
			invadingFactionBar.value = Math.abs(factionProgress);
		}

		if (factionProgress == 100)
		{
			this.faction.setFaction(PLAYER);
		}
		else if (factionProgress == -100)
		{
			this.faction.setFaction(ENEMY_1);
		}
		setSprite();

		// increment timer
		shipTimer += elapsed;
		super.update(elapsed);
	}

	/**
	 * Returns the underlying graphnode of this Planet
	 * @return  MapNode under this planet
	 */
	public function getNode():MapNode
	{
		return this.node;
	}

	/**
	 * Returns the faction of this planet.
	 * @return  Faction of this planet
	 */
	public function getFaction():Faction
	{
		return this.faction;
	}

	/**
	 * Returns the stats of this planet.
	 * @return  PlanetStats for this planet
	 */
	public function getStats():PlanetStat
	{
		return this.pStats;
	}

	// function that'll control the spousing of ships
	private function canProduceShips():Bool
	{
		// return true if is not an open planet, not a neutral planet, not have reach capacity and if enough time has pass
		return faction.getFaction() != FactionType.NOP && faction.getFaction() != FactionType.NEUTRAL
		&& numShips.get(faction.getFaction()) < this.pStats.cap && shipTimer >= pStats.prod;
	}

	// updates the capacity level and changes teh capacity accordingly
	public function updateCapacity():Void
	{
		if (this.pStats.cap_lvl < PlanetStat.MAX_CAPACITY_LEVEL)
		{
			//capacityLevel++;
			//capacity = capacityLevel * 5;
			this.pStats.cap_lvl++;
			this.pStats.cap *= 5;
		}
	}

	// updates the tech level
	public function updateTech():Void
	{
		//if (techLevel < MAX_TECH_LEVEL) {
		//techLevel++;
		//}
		if (this.pStats.tech_lvl < PlanetStat.MAX_TECH_LEVEL)
		{
			this.pStats.tech_lvl++;
		}
	}

	// get capacity level
	public function getCapacityLevel():Int
	{
		//return capacityLevel;
		return this.pStats.cap_lvl;
	}

	// get tech level
	public function getTechLevel():Int
	{
		//return techLevel;
		return this.pStats.tech_lvl;
	}

	// get the production rate
	public function getProductionRate():Float
	{
		return this.pStats.prod;
	}

	// produce a ship
	public function produceShip(node: MapNode):Ship
	{
		// if can produce a ship, produce a ship
		if (canProduceShips())
		{
			shipTimer = 0.0;
			numShips.set(faction.getFaction(), numShips.get(faction.getFaction()) + 1);
			var stat = new ShipStat(pStats.ship.hull, pStats.ship.speed, pStats.ship.sh, pStats.ship.hp, pStats.ship.as, pStats.ship.ap, pStats.ship.cps);
			//return new Ship(playState, node, faction, stat);
			return new Ship(node, faction, stat);
		}
		// if can't produce ship, return null
		return null;
	}

	// sets the number of ships of the faction to ships
	public function setNumShips(shipFaction:FactionType, ships:Int):Void
	{
		numShips.set(shipFaction, ships);
	}

	// return the position of the planet
	public function getPos():FlxVector
	{
		return new FlxVector(this.x, this.y);
	}

	// progress the capture bar
	private function capturing():Void
	{
		/*var playerShips:Int = numShips.get(faction.Faction.PLAYER);
		var enemyShips:Int = numShips.get(faction.Faction.ENEMY_1);
		var neutralShips:Int = numShips.get(faction.Faction.NEUTRAL);*/

		/*switch(this.faction.getFaction()) {
			case PLAYER:
				if (playerShips == 0) {
					factionProgress += -enemyShips;
				}
			case ENEMY_1:
				if (enemyShips == 0) {
					factionProgress += playerShips;
				}
			case NEUTRAL:
				if (neutralShips == 0) {
					factionProgress += playerShips - enemyShips;
				}
			default:
				factionProgress += playerShips - enemyShips;
		}*/
		if (factionProgress > 0 && factionProgress > 100)
		{
			factionProgress = 100;
		}
		else if (factionProgress < 0 && factionProgress < -100)
		{
			factionProgress = -100;
		}
	}

	private function setSprite():Void
	{
		switch (this.faction.getFaction())
		{
			case PLAYER:
				loadGraphic(AssetPaths.player_planet_1__png, false);
			case ENEMY_1:
				loadGraphic(AssetPaths.enemy_planet_1__png, false);
			case ENEMY_2:
				loadGraphic(AssetPaths.enemy_planet_1__png, false);
			case ENEMY_3:
				loadGraphic(AssetPaths.enemy_planet_1__png, false);
			case ENEMY_4:
				loadGraphic(AssetPaths.enemy_planet_1__png, false);
			case ENEMY_5:
				loadGraphic(AssetPaths.enemy_planet_1__png, false);
			case ENEMY_6:
				loadGraphic(AssetPaths.enemy_planet_1__png, false);
			case NEUTRAL:
				loadGraphic(AssetPaths.neutral_planet_1__png, false);
			default:
				loadGraphic(AssetPaths.uncontrolled_planet_1__png, false);
		}

		x = node.pos.x - origin.x;
		y = node.pos.y - origin.y;
	}
}
