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

import com.ganymede.map.LevelData;

/**
 * Parses Ganymede.DB dynamic objects into typed game objects.
 * 
 * @author Drew Reese
 */
class Parser {
  public static var parse(default, null):Parser = new Parser();
  private function new() {}
  
  public function size(data:Dynamic):LevelSize {
    return new LevelSize(data);
  }
  
  public function nodes(data:Dynamic):Array<LevelNode> {
    return LevelNode.createArray(data);
  }
  
  public function planets(data:Dynamic):Array<LevelPlanet> {
    return LevelPlanet.createArray(data);
  }
  
  public function beacons(data:Dynamic):Array<LevelBeacon> {
    return LevelBeacon.createArray(data);
  }
  
  public function hazzards(data:Dynamic):Array<LevelHazzard> {
    return LevelHazzard.createArray(data);
  }
  
  public function powerups(data:Dynamic):Array<LevelPowerup> {
    return LevelPowerup.createArray(data);
  }
}
