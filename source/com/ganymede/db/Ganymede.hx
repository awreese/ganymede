/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese
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
import com.ganymede.util.graph.Graph;
import haxe.Json;

/**
 * ...
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
    
    trace(Data.levelSize, Data.levelSize.all[0], Data.levelSize.get(SMALL));
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
  
  
  public static inline function levelByIndex(levelIndex:Int):Void {
    checkDBLoaded();
    
    var level = Data.levels.all[levelIndex];
    //trace("parser", Json.stringify(level));
    //trace("nodes", level.nodes[0].edges);
    
    
    buildGraph(level.nodes);
  }
  
  private static function buildGraph(nodes:Dynamic):Graph<Int, Float> {
    //trace(
      //"nodes", 
      //Type.typeof(nodes), 
      //Type.typeof(nodes[0].edges[0].edge),
      //nodes[0].edges.length
    //);
    
    var mapGraph:Graph<Int, Float> = new Graph();
    
    for (i in 0...nodes[0].edges.length) {
      trace(nodes[0].edges[i].edge, Type.typeof(nodes[0].edges[i].edge));
    }
    
    return null;
  }
  
}