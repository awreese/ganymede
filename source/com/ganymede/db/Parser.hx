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

import com.ganymede.db.DB_Data;
import com.ganymede.blueprint.PlanetBlueprint;
import com.ganymede.blueprint.ShipBlueprint;

/**
 * Parses Ganymede.DB dynamic objects into typed game objects.
 * 
 * @author Drew Reese
 */
class Parser {
  public static var parse(default, null):Parser = new Parser();
  private function new() {}
  
  /**
   * L E V E L   D A T A
   */
  
  public function size(data:Dynamic):DB_LevelSize {
    return new DB_LevelSize(data);
  }
  
  public function nodes(data:Dynamic):Array<DB_LevelNode> {
    return DB_LevelNode.createArray(data);
  }
  
  public function planets(data:Dynamic):Array<DB_LevelPlanet> {
    return DB_LevelPlanet.createArray(data);
  }
  
  public function beacons(data:Dynamic):Array<DB_LevelBeacon> {
    return DB_LevelBeacon.createArray(data);
  }
  
  public function hazzards(data:Dynamic):Array<DB_LevelHazzard> {
    return DB_LevelHazzard.createArray(data);
  }
  
  public function powerups(data:Dynamic):Array<DB_LevelPowerup> {
    return DB_LevelPowerup.createArray(data);
  }
  
  /**
   * F A C T I O N   D A T A
   */
  
  public function factions(data:Dynamic):FactionData {
    return DB_Faction.createMap(data);
  }
  
  /**
   * S H I P   C L A S S   D A T A
   */
  
  public function shipClasses(data:Dynamic):Array<DB_ShipClass> {
    return DB_ShipClass.createArray(data);
  }
  
  /**
   * P L A N E T   B L U E P R I N T S
   */
  
  public function planetBlueprintsArray(data:Dynamic):PlanetBlueprintsArray {
    return DB_PlanetBlueprint.createArray(data);
  }
  
  public function planetBlueprintsMap(data:Dynamic):PlanetBlueprintsMap {
    return DB_PlanetBlueprint.createMap(data);
  }
  
  /**
   * S H I P   B L U E P R I N T S
   */
  
  public function shipBlueprintsMap(data:Dynamic):ShipBlueprintsMap {
    return DB_ShipBlueprint.createMap(data);
  }
}
