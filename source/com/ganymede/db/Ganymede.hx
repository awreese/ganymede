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
import flixel.math.FlxPoint;
import haxe.Json;

private typedef PathNodeMap = Map<Int, Int>;
private typedef PathMap<V> = Map<Int,Map<Int,Array<V>>>;

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
    
    //trace(Data.levelSize, Data.levelSize.all[0], Data.levelSize.get(SMALL));
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
    
    
    var mapGraph:Graph<Int, Float> = buildGraph(level.nodes);
    
    //trace('mapGraph: $mapGraph');
    
    var pathNodeMap:PathMap<Int> = getPaths(mapGraph);
    
    //trace('pathNodeMap: $pathNodeMap');
    //trace(' 0->11: ${pathNodeMap[0][11]}');
    //trace('11->0 : ${pathNodeMap[11][0]}');
    //trace(' 2->7 : ${pathNodeMap[2][7]}');
    
    var pathPointMap:PathMap<FlxPoint> = getPointPaths(level.nodes, pathNodeMap);
    //trace('pathPointMap: $pathPointMap');
    trace(' 0->11: ${pathPointMap[0][11]}');
    trace('11->0 : ${pathPointMap[11][0]}');
    trace(' 2->7 : ${pathPointMap[2][7]}');
    
  }
  
  private static function buildGraph(nodes:Dynamic):Graph<Int, Float> {
    
    var graph:Graph<Int, Float> = new Graph();
    
    // Add nodes
    for (i in 0...nodes.length) {
      graph.add(i);
    }
    
    // Add edges
    for (fromNode in 0...nodes.length) {
      var currentNode = nodes[fromNode];
      for (e in 0...nodes[fromNode].edges.length) {
        var toNode:Int = nodes[fromNode].edges[e].edge;
        var destNode = nodes[toNode];
        
        var p1:FlxPoint = FlxPoint.weak(currentNode.x, currentNode.y);
        var p2:FlxPoint = FlxPoint.weak(destNode.x, destNode.y);
        var dist:Float = p1.distanceTo(p2);
        
        graph.connect(fromNode, toNode, dist);
      }
    }
    
    return graph;
  }
  
  private static function getPaths(graph:Graph<Int, Float>):PathMap<Int> {
  
    var pathNodeMap:PathMap<Int> = [for (v in graph.getVertices()) v => new Map()];
    
    for (source in graph.getVertices()) {
      
      var pathMap:PathNodeMap = graph.getPaths(source);
      
      for (target in graph.getVertices()) {
        var path:Array<Int> = graph.getPath(pathMap, source, target);
        
        pathNodeMap[source][target] = path;
      }
    }
    
    return pathNodeMap;
  }
  
  private static function getPointPaths(nodes:Dynamic, pathNodeMap:PathMap<Int>):PathMap<FlxPoint> {
    
    var pathPointMap:PathMap<FlxPoint> = [for (v in pathNodeMap.keys()) v => new Map()];
    
    for (source in pathNodeMap.keys()) {
      for (target in pathNodeMap[source].keys()) {
        var nodePath:Array<Int> = pathNodeMap[source][target];
        
        pathPointMap[source][target] = [for (i in nodePath) FlxPoint.weak(nodes[i].x, nodes[i].y)];
      }
    }
    
    return pathPointMap;
  }
  
}
