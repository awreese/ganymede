package;

import flash.display.FrameLabel;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import js.html.svg.AnimatedBoolean;
import map.MapNode;

/**
 * ...
 * @author Daisy
 * 
 * Contains the property of the Planets
 * Stores the faction, capacity, production rate, etc
 */
class Planet extends FlxSprite
{
	// fields
	private var faction:Faction;
	private var capacity:Int;
	private var productionRate:Int;
	private var numShips:Int;
	private var idleTimer:Float;
	
	// levels for the planet
	private var capacityLevel:Int;
	private var MAX_CAPACITY_LEVEL:Int = 5; // default as 5 for now
	private var techLevel:Int;
	private var MAX_TECH_LEVEL:Int = 5; // default as 5 for now
	
	public function new(location: MapNode, faction:Faction, capLevel:Int, techLevel:Int) 
	{
		// set position of the planet
		super(location.pos.x - (MapNode.NODE_SIZE / 2), location.pos.y - (MapNode.NODE_SIZE / 2));
		
		// set faction
		this.faction = faction;
		
		if (this.faction == Faction.PLAYER) {
			// draw player planet
			loadGraphic(AssetPaths.player_planet_1__png, false, 16, 16);
		} else if (this.faction == Faction.ENEMY_1) {
			// draw enemy planet
			loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
		} else if (this.faction == Faction.NEUTRAL) {
			// draw neutral planet
			loadGraphic(AssetPaths.neutral_planet_1__png, false, 16, 16);
		} else {
			// draw uncontrolled planet
			loadGraphic(AssetPaths.uncontrolled_planet_1__png, false, 16, 16);
		}
		
		// set levels
		capacityLevel = capLevel;
		this.techLevel = techLevel;
		
		// set other
		capacity = capacityLevel * 5;
		productionRate = 5;
		numShips = 0;
		idleTimer = 0;
	}
	
	override public function update(elapsed:Float):Void {
		if (this.faction == Faction.PLAYER) {
			// draw player planet
			loadGraphic(AssetPaths.player_planet_1__png, false, 16, 16);
		} else if (this.faction == Faction.ENEMY_1) {
			// draw enemy planet
			loadGraphic(AssetPaths.enemy_planet_1__png, false, 16, 16);
		} else if (this.faction == Faction.NEUTRAL) {
			// draw neutral planet
			loadGraphic(AssetPaths.neutral_planet_1__png, false, 16, 16);
		} else {
			// draw uncontrolled planet
			loadGraphic(AssetPaths.uncontrolled_planet_1__png, false, 16, 16);
		}
		super.update(elapsed);
	}
	
	// function that'll control the spousing of ships
	public function canProduceShips():Bool {
		if (idleTimer < 5) {
			// if it's time to produce ship, produce if can
			idleTimer = 0;
			if (numShips < capacity) {
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
		if (capacityLevel < MAX_CAPACITY_LEVEL) {
			capacityLevel++;
			capacity = capacityLevel * 5;
		}
	}
	
	// updates the tech level
	public function updateTech():Void {
		if (techLevel < MAX_TECH_LEVEL) {
			techLevel++;
		}
	}
	
	// get capacity level
	public function getCapacityLevel():Int {
		return capacityLevel;
	}
	
	// get tech level
	public function getTechLevel() {
		return techLevel;
	}
	
	// set the planet faction to new faction if captured
	public function captured(faction:Faction) {
		this.faction = faction;
	}
	
	// sets the number of ships at this planet
	public function setNumShips(ships:Int):Void {
		numShips = ships;
	}
}