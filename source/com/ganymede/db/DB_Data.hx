/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2018 Andrew Reese
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

package com.ganymede.db;

import com.ganymede.blueprint.PlanetBlueprint;
import com.ganymede.blueprint.ShipBlueprint;
import com.ganymede.db.DB_Data.DB_Faction;
import com.ganymede.db.DB_Data.DB_LevelBeacon;
import com.ganymede.db.DB_Data.DB_LevelHazzard;
import com.ganymede.db.DB_Data.DB_LevelNode;
import com.ganymede.db.DB_Data.DB_LevelPlanet;
import com.ganymede.db.DB_Data.DB_LevelPowerup;
import com.ganymede.db.DB_Data.DB_PlanetBlueprint;
import com.ganymede.db.DB_Data.DB_ShipClass;
import com.ganymede.faction.Faction;
//import com.ganymede.faction.Factions;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * Classes and Typedefs for game data.
 * 
 * Data is loaded from Ganymede.DB as dynamic objects, these 
 * classes are the typed object equivalent.  The purpose is to
 * have the Ganymede.DB accessors build and return useable typed
 * objects for game use instead of dynamic object types so 
 * compile-time type checks happen instead of run-time checks.
 * 
 * The classes are used by Ganymede.DB to construct typed objects 
 * that are returned within a typed object for consumption.
 * 
 * @author Drew Reese
 */

typedef VertexPathMap<V> = Map<Int,Map<Int,Array<V>>>;

class DB_Data {
  /**
   * Maps the values of array @{arr} to new array using map function callback @{mapFn}.
   * Map function callback signature is (object: Dynamic, index: Int).
   */
  public static function createArray<T>(arr:Array<Dynamic>, mapFn:Dynamic->Int->T):Array<T> {
    return [for (i in 0...arr.length) mapFn(arr[i], i)];
  }
  
  /**
   * Maps the values of array @{arr} to new map using map function callback @{mapFn}.
   * Map function callback signature is (object: Dynamic, index: Int).
   */
  public static function createMap<T>(arr:Array<Dynamic>, mapFn:Dynamic->Int->T):Map<String, T> {
    return [for (i in 0...arr.length) arr[i].id => mapFn(arr[i], i)];
  }
}

// L E V E L   D A T A

class DB_LevelSize {
  public var id(default, null):String;
  public var width(default, null):Int;
  public var height(default, null):Int;
  
  public function new(size:Dynamic) {
    this.id = size.id;
    this.width = size.width;
    this.height = size.height;
  }
}

class DB_LevelNode {
  public var id(default, null):Int;
  public var position(default, null):FlxPoint;
  public var edges(default, null):Array<Int>;
  
  public function new(id:Int, node:Dynamic) {
    this.id = id;
    this.position = new FlxPoint(node.x, node.y);
    this.edges = [for (i in 0...node.edges.length) node.edges[i].edge];
  }
  
  public static function createArray(nodes:Dynamic):Array<DB_LevelNode> {
    return DB_Data.createArray(nodes, function(node, i){ return new DB_LevelNode(i, node); });
  }
}

class DB_LevelPlanet {
  public var nodeId(default, null):Int;
  public var planetId(default, null):String;
  public var faction(default, null):Faction;
  public var capturable(default, null):Bool;
  public var shipFactory(default, null):String;
  
  public function new(planet:Dynamic) {
    this.nodeId = planet.node;
    this.planetId = planet.planet;
    this.faction = planet.faction;
    this.capturable = planet.capturable;
    this.shipFactory = planet.shipFactory;
  }
  
  public static function createArray(planets:Dynamic):Array<DB_LevelPlanet> {
    return DB_Data.createArray(planets, function(planet, i) { return new DB_LevelPlanet(planet); });
  }
}

class DB_LevelBeacon {
  public var nodeId(default, null):Int;
  public var beaconId(default, null):String;
  public var faction(default, null):Faction;
  public var capturable(default, null):Bool;
  
  public function new(beacon:Dynamic) {
    this.nodeId = beacon.node;
    this.beaconId = beacon.beacon;
    this.faction = beacon.faction;
    this.capturable = beacon.capturable;
  }
  
  public static function createArray(beacons:Dynamic):Array<DB_LevelBeacon> {
    function mapFn(beacon, index) {
      return new DB_LevelBeacon(beacon);
    }
    return DB_Data.createArray(beacons, mapFn);
  }
}

class DB_LevelHazzard {
  public var nodeId(default, null):Int;
  public var hazzardId(default, null):String;
  
  public function new(hazzard:Dynamic) {
    this.nodeId = hazzard.node;
    this.hazzardId = hazzard.hazzard;
  }
  
  public static function createArray(hazzards:Dynamic):Array<DB_LevelHazzard> {
    function mapFn(hazzard, index) {
      return new DB_LevelHazzard(hazzard);
    }
    return DB_Data.createArray(hazzards, mapFn);
  }
}

class DB_LevelPowerup {
  public var powerupId(default, null):String;
  
  public function new(powerup:Dynamic) {
    this.powerupId = powerup.powerup;
  }
  
  public static function createArray(powerups:Dynamic):Array<DB_LevelPowerup> {
    function mapFn(powerup, index) {
      return new DB_LevelPowerup(powerup);
    }
    return DB_Data.createArray(powerups, mapFn);
  }
}

typedef LevelData = {
  size:DB_LevelSize,
  nodes:Array<DB_LevelNode>,
  planets:Array<DB_LevelPlanet>,
  beacons:Array<DB_LevelBeacon>,
  hazzards:Array<DB_LevelHazzard>,
  powerups:Array<DB_LevelPowerup>,
}

// F A C T I O N   D A T A

class DB_Faction {
  //public var faction(default, null):FactionType;
  //public var color(default, null):FlxColor;
  //public var faction(default, null):Factions;

  //public function new(faction:Dynamic) {
    ////this.faction = faction.faction;
    ////this.color = faction.color;
    //this.faction = Factions.Faction(faction.faction, faction.color);
  //}
  
  //public static function createArray(factions:Dynamic):Array<Factions> {
    //function mapFn(faction, index) {
      ////return new DB_Faction(faction);
      //return Factions.Faction(faction.faction, faction.color);
    //}
    //return DB_Data.createArray(factions, mapFn);
  //}
  
  public static function createMap(factions:Dynamic):FactionData {
    //function mapFn(faction, index) {
      //return Factions.Faction(faction.faction, faction.color);
    //}
    //return DB_Data.createMap(factions, mapFn);
    return [for (i in 0...factions.length) factions[i].faction => factions[i].color];
  }
  
}

typedef FactionData = Map<FactionType, FlxColor>;

// S H I P   C L A S S   D A T A

class DB_ShipClass {
  public var className(default, null):String;
  
  public function new(shipClass:Dynamic) {
    this.className = shipClass.className;
  }
  
  public static function createArray(shipClasses:Dynamic):Array<DB_ShipClass> {
    return DB_Data.createArray(shipClasses, function(shipClass, i) {return new DB_ShipClass(shipClass);});
  }
  
}

typedef ShipClassData = {
  classes: Array<DB_ShipClass>,
}

// P L A N E T   B L U E P R I N T S

class DB_ShipBlueprint {
  private static function createBlueprint(bp, index) {
    return new ShipBlueprint(
      bp.id,
      bp.description,
      bp.hull_class,
      bp.orbit_velocity,
      bp.warp_velocity,
      bp.angular_velocity,
      bp.hit_points,
      bp.shield_strength,
      bp.hp_regen,
      bp.capture_points_per_second,
      bp.sensor_range,
      bp.turret_hardpoints,
      bp.launcher_hardpoints,
      bp.turrets,
      bp.launchers
    );
  }
  
  public static function createMap(blueprints:Dynamic):Map<String, ShipBlueprint> {
    return DB_Data.createMap(blueprints, createBlueprint);
  }
}

typedef ShipBlueprintsMap = Map<String, ShipBlueprint>;

// P L A N E T   B L U E P R I N T S

class DB_PlanetBlueprint {
  private static function createBlueprint(bp, index) {
    return new PlanetBlueprint(
      bp.id,
      bp.description,
      bp.level,
      bp.max_capacity_level,
      bp.max_tech_level,
      bp.ship_capacity,
      bp.production_rate_seconds,
      bp.production_threshold,
      bp.base_upgrade_cost,
      bp.capacity_per_level,
      bp.tech_per_level
    );
  }
  
  public static function createArray(blueprints:Dynamic):Array<PlanetBlueprint> {
    return DB_Data.createArray(blueprints, createBlueprint);
  }
  
  public static function createMap(blueprints:Dynamic):Map<String, PlanetBlueprint> {
    return DB_Data.createMap(blueprints, createBlueprint);
  }
}

typedef PlanetBlueprintsArray = Array<PlanetBlueprint>;
typedef PlanetBlueprintsMap = Map<String, PlanetBlueprint>;
