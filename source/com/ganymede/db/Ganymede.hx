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
    
    trace('mapGraph: $mapGraph');
    
    var a:Int = 0, b:Int = 11;
    var path:Array<Int> = mapGraph.findPath(a, b);
    trace('path $a->$b: $path');
    
    var pathPoints:Array<FlxPoint> = new Array();
    for (i in path) {
      var node = level.nodes[i];
      pathPoints.push(new FlxPoint(node.x, node.y));
    }
    trace('pathPoints $a->$b: $pathPoints');
    
    var pathMap:Map<Int, Int> = mapGraph.dijkstras(0);
    trace('pathMap: $pathMap');
    
    getPaths(level.nodes, mapGraph);
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
  
  private static function getPaths(nodes:Dynamic, graph:Graph<Int, Float>):Void {
  
    var pathMap:Map<Int,Int>;
    
    function getPathTo(target:Int):Void {
      
      trace('test: ${graph.getPath(pathMap, 0, 11)}');
      
      return null;
    }
    
    trace('getPaths graph nodes: ${graph.getVertices()}');
    
    for (vertex in graph.getVertices()) {
      trace('vertex: $vertex');
      pathMap = graph.dijkstras(vertex);
      getPathTo(11);
    }
    
    
    return null;
  }
  
  
  
}
