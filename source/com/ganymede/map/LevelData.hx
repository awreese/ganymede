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

package com.ganymede.map;

import com.ganymede.faction.Faction;
import com.ganymede.util.graph.Graph;
import flixel.math.FlxPoint;

/**
 * Classes and Typedefs for map level data.
 * 
 * Data is loaded from Ganymede.DB as dynamic objects, these 
 * classes are the typed object equivalent.  The purpose is to
 * have the Genymede.DB accessors build and return useable typed
 * objects for game use instead of dynamic object types so 
 * compile-time type checks happen instead of run-time checks.
 * 
 * The classes are used by Ganymede.DB to construct typed objects 
 * that are returned within a LevelData object for consumption.
 * 
 * @author Drew Reese
 */

class LevelSize {
  public var id(default, null):String;
  public var width(default, null):Int;
  public var height(default, null):Int;
  
  public function new(size:Dynamic) {
    this.id = size.id;
    this.width = size.width;
    this.height = size.height;
  }
}

class LevelNode {
  public var id(default, null):Int;
  public var position(default, null):FlxPoint;
  public var edges(default, null):Array<Int>;
  
  public function new(id:Int, node:Dynamic) {
    this.id = id;
    this.position = FlxPoint.weak(node.x, node.y);
    this.edges = [for (i in 0...node.edges.length) node.edges[i].edge];
  }
  
  public static function createArray(nodes:Dynamic):Array<LevelNode> {
    return [for (i in 0...nodes.length) new LevelNode(i, nodes[i])];
  }
}

typedef VertexPathMap<V> = Map<Int,Map<Int,Array<V>>>;

class LevelPlanet {
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
  
  public static function createArray(planets:Dynamic):Array<LevelPlanet> {
    return [for (i in 0...planets.length) new LevelPlanet(planets[i])];
  }
}

class LevelBeacon {
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
  
  public static function createArray(beacons:Dynamic):Array<LevelBeacon> {
    return [for (i in 0...beacons.length) new LevelBeacon(beacons[i])];
  }
}

class LevelHazzard {
  public var nodeId(default, null):Int;
  public var hazzardId(default, null):String;
  
  public function new(hazzard:Dynamic) {
    this.nodeId = hazzard.node;
    this.hazzardId = hazzard.hazzard;
  }
  
  public static function createArray(hazzards:Dynamic):Array<LevelHazzard> {
    return [for (i in 0...hazzards.length) new LevelHazzard(hazzards[i])];
  }
}

class LevelPowerup {
  public var powerupId(default, null):String;
  
  public function new(powerup:Dynamic) {
    this.powerupId = powerup.powerup;
  }
  
  public static function createArray(powerups:Dynamic):Array<LevelPowerup> {
    return [for (i in 0...powerups.length) new LevelPowerup(powerups[i])];
  }
}

typedef LevelData = {
  size:LevelSize,
  nodes:Array<LevelNode>,
  planets:Array<LevelPlanet>,
  beacons:Array<LevelBeacon>,
  hazzards:Array<LevelHazzard>,
  powerups:Array<LevelPowerup>,
}
