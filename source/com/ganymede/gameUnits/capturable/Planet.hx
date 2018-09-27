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

package com.ganymede.gameUnits.capturable;

import com.ganymede.blueprint.PlanetBlueprint;
import com.ganymede.faction.Faction;
import com.ganymede.gameUnits.ships.Ship;
import com.ganymede.gameUnits.ships.Ship.BluePrint;
import com.ganymede.gameUnits.ships.Ship.ShipFactory;
import com.ganymede.gameUnits.capturable.Capturable;
import com.ganymede.gameUnits.capturable.Planet.PlanetStat;
import com.ganymede.map.Node;
import flixel.FlxSprite;
import flixel.math.FlxVector;

/**
 * Planet statistic type
 *
 * This defines planet types by specifying thier statistics.  Planet statistics
 * must be instanitated or cloned before being passed into constructors for planets.
 *
 * @author Drew Reese
 */
class PlanetStat {

  // Stores default PlanetStats that can be referenced in level files. This allows for easier
  // creation and editing of game levels, and allows us to change the stats of all planets of
  // a type at once.
  private static var planetTemplateMap = new Map<String, PlanetStat>();

  // Whether or not the templates have been initialized yet
  private static var hasInitialized = false;

  // Guarantees that the values in the template map have been initialized
  private static function checkInitTemplates(): Void {
    if (!hasInitialized) {
      hasInitialized = true;
      planetTemplateMap.set("tutorial", new PlanetStat(null, 1, Math.POSITIVE_INFINITY, 0.5, 0, 0, 10, 5, 2.0));
      planetTemplateMap.set("level1", new PlanetStat(null, 10, 5.0, 0.5, 0, 0, 10, 5, 2.0));
      planetTemplateMap.set("level2", new PlanetStat(null, 15, 3.0, 0.5, 0, 0, 10, 5, 2.0));
    }
  }

  // Returns the planet template with the given name, using clone() to guarantee safety
  public static function getPlanetStat(name: String): PlanetStat {
    checkInitTemplates();
    return planetTemplateMap.get(name).clone();
  }

  // Class Constants
  public static inline var MAX_CAPACITY_LEVEL:Int = 5; // default as 5 for now
  public static inline var MAX_TECH_LEVEL:Int = 5; // default as 5 for now

  // General
  public var cap: Int;			// ship capacity
  public var prod: Float;			// ship production rate in seconds
  public var prod_thresh: Float;	// production rate threshold for falloff
  public var ship: BluePrint;      // ship type for production

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
                      ?cap_per_lvl=5, ?tech_per_lvl=2.0) {

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
    return new PlanetStat(ship == null ? null : this.ship.clone(), this.cap, this.prod, this.prod_thresh,
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
class Planet extends Capturable implements I_Planet {
  /*
   * From Capturable Class
   *
   * parent node: this.node
   * faction:     this.faction
   *
   */

  // internal fields
  private var pStats:PlanetStat;
  
  public var id(default, null):String;
  public var description(default, null):String;
  public var level(default, null):Int;
  public var max_capacity_level(default, null):Int;
  public var max_technology_level(default, null):Int;
  public var ship_capacity(default, null):Int;
  public var production_rate_seconds(default, null):Float;
  public var production_threshold(default, null):Float;
  public var base_upgrade_cost(default, null):Int;
  public var capacity_upgrade_per_level(default, null):Int;
  public var technology_upgrade_per_level(default, null):Int;

  private var numShips:Map<FactionType, Int>;

  // Ship Factory
  private var shipFactory:ShipFactory;
  
  private var planetSprite:FlxSprite;

  //public function new(playState:PlayState, location:Node, faction:Faction, pstats:PlanetStat) {
  public function new(location:Node, faction:Faction, factionType:FactionType, pstats:PlanetStat) {
    // set position of the planet
    super(location, 100.0, faction.getFactionType());

    //this.playState = playState;

    // set sprite
    this.planetSprite = new FlxSprite(0,0);
    setSprite();
    this.planetSprite.setGraphicSize(32, 32); // This scales down the planets from their default size of 48x48

    this.planetSprite.x -= this.planetSprite.origin.x;
    this.planetSprite.y -= this.planetSprite.origin.y;
    
    this.add(planetSprite);
    
    this.pStats = pstats;
    
    //this.id = data.id;
    //this.description = data.description;
    //this.level = data.level;
    //this.max_capacity_level = data.max_capacity_level;
    //this.max_technology_level = data.max_technology_level;
    //this.ship_capacity = data.ship_capacity;
    //this.production_rate_seconds = data.production_rate_seconds;
    //this.production_threshold = data.production_threshold;
    //this.base_upgrade_cost = data.base_upgrade_cost;
    //this.capacity_upgrade_per_level = data.capacity_upgrade_per_level;
    //this.technology_upgrade_per_level = data.technology_upgrade_per_level;

    this.shipFactory = new ShipFactory(this);
    this.shipFactory.setProduction(this.pStats.ship);

    // set number of ships
    numShips = new Map<FactionType, Int>();
    for (f in Faction.getEnums()) {
      numShips.set(f, 0);
    }
    shipsAtPlanet = new Array<Ship>();
    trace("new Planet", this);
  }

  override public function update(elapsed:Float):Void {
    this.shipFactory.produceShip(elapsed);

    super.update(elapsed);
    setSprite();
  }

  /**
   * Returns the underlying graphnode of this Planet
   * @return  MapNode under this planet
   */
  public function getNode():Node {
    return this.node;
  }

  /**
   * Returns the stats of this planet.
   * @return  PlanetStats for this planet
   */
  public function getStats():PlanetStat {
    return this.pStats;
  }

  // function that'll control the spousing of ships
  //private function canProduceShips():Bool {
  //// return true if is not an open planet, not a neutral planet, not have reach capacity and if enough time has pass
  ////return faction.getFactionType() != FactionType.NOP && faction.getFactionType() != FactionType.NEUTRAL
  ////&& numShips.get(faction.getFactionType()) < this.pStats.cap && shipTimer >= pStats.prod;
  //
  //return faction.getFactionType() != FactionType.NOP &&
  //this.node.getShipGroup(this.faction.getFactionType()).members.length < this.pStats.cap &&
  //shipTimer >= pStats.prod;
  //}

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
    return this.pStats.prod;
  }

  // produce a ship
  //public function produceShip(node: MapNode):Ship {
  //// if can produce a ship, produce a ship
  //if (canProduceShips())
  //{
  //shipTimer = 0.0;
  //numShips.set(faction.getFactionType(), numShips.get(faction.getFactionType()) + 1);
  ////var stat = new BluePrint(pStats.ship.hull, pStats.ship.maxVelocity, pStats.ship.shield, pStats.ship.hitPoints, pStats.ship.attackSpeed, pStats.ship.attackDamage, pStats.ship.cps);
  ////return new Ship(playState, node, faction, stat);
  //return new Ship(this.node, faction, pStats.ship.clone());
  //}
  //// if can't produce ship, return null
  //return null;
  //}

  // sets the number of ships of the faction to ships
  public function setNumShips(shipFaction:FactionType, ships:Int):Void {
    numShips.set(shipFaction, ships);
  }

  // return the position of the planet
  public function getPos():FlxVector {
    return new FlxVector(this.planetSprite.x, this.planetSprite.y);
  }

  private function setSprite():Void {
    //switch (this.faction.getFactionType()) {
    switch (this.controllingFaction) {
      case PLAYER:
        this.planetSprite.loadGraphic(AssetPaths.planet_1_player__png, false);
      case ENEMY_1:
        this.planetSprite.loadGraphic(AssetPaths.planet_1_enemy1__png, false);
      case ENEMY_2:
        this.planetSprite.loadGraphic(AssetPaths.planet_1_enemy2__png, false);
      case NEUTRAL:
        this.planetSprite.loadGraphic(AssetPaths.planet_1_neutral__png, false);
      case NOP:
        this.planetSprite.loadGraphic(AssetPaths.planet_1_none__png, false);
      default:
        this.planetSprite.loadGraphic(AssetPaths.planet_1_enemy1__png, false);
    }
  }
}
