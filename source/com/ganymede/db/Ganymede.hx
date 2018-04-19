/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017-2018 Andrew Reese
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

import com.ganymede.db.Data;
import com.ganymede.db.Parser;
import com.ganymede.map.LevelData;

/**
 * Ganymede.DB in-memory database.
 * 
 * @author Drew Reese
 */
class Ganymede {

  private static var _dbLoaded:Bool = false;

  /**
   * Load Ganymede Database.
   */
  private static function loadDB() {
    #if js
    Data.load(haxe.Resource.getString(AssetPaths.ganymedeDB__cdb));
    _dbLoaded = true;
    #else
    Data.load(null));
    #end
	}
  
  /**
   * Checks if database is loaded.  If it is not currently loaded, then
   * it will be loaded.  All DB functions call this function to ensure
   * database is loaded before trying to access.  This also means the
   * very first DB function call will initially load the Ganymede DB.
   */
  private static function checkDBLoaded():Void {
    if (!_dbLoaded) {
      //throw "not connected to GanymedeDB";
      loadDB();
    }
  }
  
  public static inline function getLevelData(levelIndex:Int):LevelData {
    checkDBLoaded();
    
    var data = Data.levels.all[levelIndex];
    
    return {
      size: Parser.parse.size(data.size),
      nodes: Parser.parse.nodes(data.nodes),
      planets: Parser.parse.planets(data.planets),
      beacons: Parser.parse.beacons(data.beacons),
      hazzards: Parser.parse.hazzards(data.hazzards),
      powerups: Parser.parse.powerups(data.powerups),
    };
  }
  
}
