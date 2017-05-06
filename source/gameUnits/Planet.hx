package gameUnits;

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
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import js.html.svg.AnimatedBoolean;
import map.MapNode;
import faction.Faction;


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
	private var numShips:Map<FactionType, Int>;
	private var idleTimer:Float;
	
	// progress bar
	private var factionProgress:Int;
	private var currFactionBar:FlxBar;
	private var invadingFactionBar:FlxBar;
	private var invadeFaction:Faction;
	
	// levels for the planet
	//private var capacityLevel:Int;
	//private var techLevel:Int;
	private var shipText:FlxText;
	
	public function new(location: MapNode, faction: Faction, pstats: PlanetStat)
	{
		// set position of the planet
		super(location.pos.x - (MapNode.NODE_SIZE / 2), location.pos.y - (MapNode.NODE_SIZE / 2));
		
		// set faction
		this.faction = faction;
		
		// Load graphics and any faction specific items
		switch(this.faction.getFaction()) {
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
		
		// set other
		//capacity = capacityLevel * 5;
		//productionRate = 1;
		numShips = new Map<FactionType, Int>();
		numShips.set(FactionType.PLAYER, 0);
		numShips.set(FactionType.ENEMY_1, 0);
		numShips.set(FactionType.NEUTRAL, 0);
		//idleTimer = 0;
		
		currFactionBar.value = Math.abs(factionProgress);
		invadingFactionBar.value = 0;
		FlxG.state.add(currFactionBar);
		FlxG.state.add(invadingFactionBar);
		shipText = new FlxText(this.x, this.y + 40, 0, "0", 16);
		FlxG.state.add(shipText);
	}
	
	override public function update(elapsed:Float):Void {
		var totalShip:Int = 0;
		for (f in numShips.keys()) {
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
		
		capturing();
		
		// setting which bar is visible
		switch (this.faction.getFaction()) {
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
				if (factionProgress >= 0) {
					invadingFactionBar.color = FlxColor.BLUE;
				} else {
					invadingFactionBar.color = FlxColor.RED;
				}
		}
		if (currFactionBar.visible) {
			currFactionBar.value = Math.abs(factionProgress);
		} else if (invadingFactionBar.visible) {
			invadingFactionBar.value = Math.abs(factionProgress);
		}
		
		if (factionProgress == 100) {
			this.faction.setFaction(PLAYER);
		} else if (factionProgress == -100) {
			this.faction.setFaction(ENEMY_1);
		}
		setSprite();
		
		super.update(elapsed);
	}
	
	// function that'll control the spousing of ships
	public function canProduceShips():Bool {
		if (idleTimer < 5) {
			// if it's time to produce ship, produce if can
			idleTimer = 0;
			if (numShips.get(faction.getFaction()) < this.pStats.cap) {
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
	
	// sets the number of ships of the faction to ships
	public function setNumShips(shipFaction:FactionType, ships:Int):Void {
		numShips.set(shipFaction, ships);
	}
	
	// return the position of the planet
	public function getPos():FlxVector {
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
		if (factionProgress > 0 && factionProgress > 100) {
			factionProgress = 100;
		} else if (factionProgress < 0 && factionProgress < -100) {
			factionProgress = -100;
		}
	}
	
	private function setSprite():Void {
		switch(this.faction.getFaction()) {
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
	}
}
