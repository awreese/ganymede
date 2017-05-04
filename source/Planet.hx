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

import flash.display.FrameLabel;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import js.html.svg.AnimatedBoolean;
import map.MapNode;

/**
 * Planet statistic type
 * 
 * Planet statistics must be instanitated and passed into constructors
 * for planets.
 * 
 * @author Drew Reese
 */
class PlanetStat {
	// Class Constants
	public static inline var MAX_CAPACITY_LEVEL:Int = 5; // default as 5 for now
	public static inline var MAX_TECH_LEVEL:Int = 5; // default as 5 for now
	
	// General
	public var cap: Int;			// ship capacity
	public var prod: Float;			// ship production rate
	public var prod_thresh: Float;	// production rate threshold for falloff
	
	// Levels
	public var cap_lvl: Int;		// current capacity level
	public var tech_lvl: Int;		// current tech level
	
	// Upgrades/costs
	public var base_cost: Int;		// base upgrade cost in ships
	public var cap_per_lvl: Int;	// capacity increase per level
	public var tech_per_lvl: Float;	// tech increase per level
	
	public function new(?cap = 10, ?prod = 5.0, ?prod_thresh = 0.5,
						?cap_lvl = 0, ?tech_lvl = 0,
						?base_cost = 10,
						?cap_per_lvl=5, ?tech_per_lvl=2) {
							
							this.cap = cap;
							this.prod = prod;
							this.prod_thresh = prod_thresh;
							this.cap_lvl = cap_lvl;
							this.tech_lvl = tech_lvl;
							this.base_cost = base_cost;
							this.cap_per_lvl = cap_per_lvl;
							this.tech_per_lvl = tech_per_lvl;
						}
}

/**
 * ...
 * @author Daisy
 * 
 * Contains the property of the Planets
 * Stores the faction, capacity, production rate, etc
 */
class Planet extends FlxSprite
{
	// parent node and faction control fields
	private var node: MapNode;
	private var faction:Faction;
	
	// internal fields
	//private var capacity:Int;
	//private var productionRate:Float;
	private var pStats: PlanetStat;
	private var numShips:Int;
	private var idleTimer:Float;
	
	// levels for the planet
	//private var capacityLevel:Int;
	//private var techLevel:Int;
	
	//public static inline var MAX_CAPACITY_LEVEL:Int = 5; // default as 5 for now
	//public static inline var MAX_TECH_LEVEL:Int = 5; // default as 5 for now
	
	//public function new(location: MapNode, faction:Faction, capLevel:Int, techLevel:Int) 
	public function new(location: MapNode, faction: Faction, pstats: PlanetStat)
	{
		// set position of the planet
		super(location.pos.x - (MapNode.NODE_SIZE / 2), location.pos.y - (MapNode.NODE_SIZE / 2));
		
		// set faction
		this.faction = faction;
		
		// Load graphics and any faction specific items
		switch(this.faction) {
			case Faction.PLAYER:
				loadGraphic(AssetPaths.player_planet_1__png, false, 16, 16);
			case Faction.ENEMY_1:
				loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
			case Faction.ENEMY_2:
				loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
			case Faction.ENEMY_3:
				loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
			case Faction.ENEMY_4:
				loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
			case Faction.ENEMY_5:
				loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
			case Faction.ENEMY_6:
				loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
			default:
				loadGraphic(AssetPaths.uncontrolled_planet_1__png, false, 16, 16);
		}
		
		// set levels
		//capacityLevel = capLevel;
		//this.techLevel = techLevel;
		this.pStats = pstats;
		
		// set other
		//capacity = capacityLevel * 5;
		//productionRate = 1;
		numShips = 0;
		idleTimer = 0;
	}
	
	override public function update(elapsed:Float):Void {
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
		switch(this.faction) {
			case Faction.NOP:
				trace("Open Planet");
			case Faction.NEUTRAL:
				trace("Neutral Planet");
			case Faction.PLAYER:
				trace("Player Planet");
			default:
				// Not player, neutral, or NOP planet => do enemy stuff
				trace("Enemy Planet: " + this.faction);
		}
		
		
		super.update(elapsed);
	}
	
	// function that'll control the spousing of ships
	public function canProduceShips():Bool {
		if (idleTimer < 5) {
			// if it's time to produce ship, produce if can
			idleTimer = 0;
			if (numShips < this.pStats.cap) {
				return true;
			}	
			// reset timer
			return false;
		} else {
			// else, don't produce ship
			idleTimer++;
			return false;
		}
	}
	
	// updates the capacity level and changes teh capacity accordingly
	public function updateCapacity():Void {
		if (this.pStats.cap_lvl < PlanetStat.MAX_CAPACITY_LEVEL) {
			//capacityLevel++;
			//capacity = capacityLevel * 5;
			this.pStats.cap_lvl++;
			this.pStats.cap *= 5;
		}
	}
	
	// updates the tech level
	public function updateTech():Void {
		//if (techLevel < MAX_TECH_LEVEL) {
			//techLevel++;
		//}
		if (this.pStats.tech_lvl < PlanetStat.MAX_TECH_LEVEL) {
			this.pStats.tech_lvl++;
		}
	}
	
	// get capacity level
	public function getCapacityLevel():Int {
		//return capacityLevel;
		return this.pStats.cap_lvl;
	}
	
	// get tech level
	public function getTechLevel():Int {
		//return techLevel;
		return this.pStats.tech_lvl;
	}
	
	// get the production rate
	public function getProductionRate():Float {
		// need to adjust production rate //
		// currently return default production rate //
		//return productionRate;
		return this.pStats.prod;
	}
	
	// set the planet faction to new faction if captured
	public function captured(faction:Faction):Void {
		this.faction = faction;
	}
	
	// sets the number of ships at this planet
	public function setNumShips(ships:Int):Void {
		numShips = ships;
	}
}