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

package com.ganymede.map.layers;

import com.ganymede.db.DB_Data;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup;

using Lambda;

private typedef NodeArray = Array<DB_LevelNode>;
private typedef PlanetArray = Array<DB_LevelPlanet>;
private typedef BeaconArray = Array<DB_LevelBeacon>;
private typedef HazzardArray = Array<DB_LevelHazzard>;
private typedef PowerupArray = Array<DB_LevelPowerup>;

/**
 * Object layer holds instances of planet, beacon, and hazzard groups.
 * 
 * @author Drew Reese
 * 
 * - Layer 2 (Game Object Group)
 *   - planets
 *     - upgrade UI (move to UI layer)
 *     - capture bars (move to UI layer)
 *   - beacons
 *     - capture bars (move to UI layer)
 *   - ships
 *   - hazards
 */
class ObjectLayer extends FlxGroup {
  public var beacons(default, null):FlxGroup;
  public var hazzards(default, null):FlxGroup;
  public var planets(default, null):FlxGroup;
  public var ships(default, null):FlxGroup;

  public function new() {
    super();
    this.beacons = new FlxGroup();
    this.hazzards = new FlxGroup();
    this.planets = new FlxGroup();
    this.ships = new FlxGroup();
    
    super.add(this.planets);
    super.add(this.beacons);
    super.add(this.ships);
    super.add(this.hazzards);
  }
  
  /**
   * Overridden to prevent adding objects to object layer group container.
   */
  override public function add(Object:FlxBasic):FlxBasic {
    FlxG.log.error("Tried adding object to base objects group, this is a non-op. Don't do it again!");
    return null;
  }
  
  public function set_object_data(levelData:LevelData) {
    trace('Set Object Level Data', levelData);
    var nodes:NodeArray = levelData.nodes;
    
    function addPlanet(planetData) {
      trace('Planet in FN', planetData);
    }
    function addBeacon(beaconData) {
      trace('Beacon in FN', beaconData);
    }
    function addHazzard(hazzardData) {
      trace('Hazzard in FN', hazzardData);
    }
    
    this.addObjects(levelData.planets, addPlanet);
    this.addObjects(levelData.beacons, addBeacon);
    this.addObjects(levelData.hazzards, addHazzard);
  }
  
  private function addObjects<T>(objects:Iterable<T>, cb:T -> Void):Void {
    Lambda.iter(objects, cb);
  }
}
