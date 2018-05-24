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

import com.ganymede.db.LevelData;

/**
 * Parses Ganymede.DB dynamic objects into typed game objects.
 * 
 * @author Drew Reese
 */
class Parser {
  public static var parse(default, null):Parser = new Parser();
  private function new() {}
  
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
}
