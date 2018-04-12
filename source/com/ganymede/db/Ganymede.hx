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
import com.ganymede.map.LevelData;
import com.ganymede.util.graph.Graph;
import flixel.math.FlxPoint;

private typedef PathNodeMap = Map<Int, Int>;
//private typedef PathMap<V> = Map<Int,Map<Int,Array<V>>>;
//
//private typedef LevelData = {
  //size:FlxPoint,
  //nodes:Array<FlxPoint>,
  //mapGraph:Graph<Int, Float>,
  //pathPointMap:PathMap<FlxPoint>
//};

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
  
  public static inline function getLevelData(levelIndex:Int):LevelData {
    checkDBLoaded();
    
    var level = Data.levels.all[levelIndex];
    
    var size = new LevelSize(level.size);
    var nodeArray:LevelNodeArray = new LevelNodeArray(level.nodes);
    //trace('getLevelData', level);
    trace('level nodes', nodeArray);
    trace('level size', size);
    
    return {
      size: size,
      //nodes: null,
      nodes: nodeArray,
      //mapGraph: null,
      //pathPointMap: null
    };
  }
  
  // TODO: DEPRECATED, move this functionality into Ganymede::getLevelData
  public static inline function levelByIndex(levelIndex:Int):LevelData {
    checkDBLoaded();
    
    var level = Data.levels.all[levelIndex];
    //trace("parser", Json.stringify(level));
    //trace("nodes", level.nodes[0].edges);
    
    var levelSize = new LevelSize(level.size);
    
    var nodeArray:Array<FlxPoint> = parseNodes(level.nodes);
    trace('level', levelIndex, 'nodeArray', nodeArray);
    
    var mapGraph:Graph<Int, Float> = buildGraph(level.nodes);
    
    //trace('mapGraph: $mapGraph');
    
    var pathNodeMap:PathVertexMap<Int> = getPaths(mapGraph);
    
    var pathPointMap:PathVertexMap<FlxPoint> = getPointPaths(level.nodes, pathNodeMap);
    //trace(' 0->11: ${pathPointMap[0][11]}');
    //trace('11->0 : ${pathPointMap[11][0]}');
    //trace(' 2->7 : ${pathPointMap[2][7]}');
    
    var levelData:LevelData = {
      size: levelSize,
      //nodes: nodeArray,
      nodes: null,
      //nodes2: null,
      //mapGraph: mapGraph,
      //pathPointMap: pathPointMap
    };
    
    return levelData;
  }
  
  /* TODO: All graph/path building functions belong in the classes
   *   that deal with graph/path building (i.e. Graph Layer) and
   *   functionality should be moved there.  Ganymede functions 
   *   should only deal with loading and producing data from the
   *   database (i.e. getLevelData).
   */
  
  /**
   * @deprecated
   */
  private static function parseNodes(nodes:Dynamic):Array<FlxPoint> {
    return [for (n in 0...nodes.length) FlxPoint.weak(nodes[n].x, nodes[n].y)];
  }
  
  /**
   * @deprecated
   */
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
  
  /**
   * @deprecated
   */
  private static function getPaths(graph:Graph<Int, Float>):PathVertexMap<Int> {
  
    var pathNodeMap:PathVertexMap<Int> = [for (v in graph.getVertices()) v => new Map()];
    
    for (source in graph.getVertices()) {
      
      var pathMap:PathNodeMap = graph.getPaths(source);
      
      for (target in graph.getVertices()) {
        var path:Array<Int> = graph.getPath(pathMap, source, target);
        
        pathNodeMap[source][target] = path;
      }
    }
    
    return pathNodeMap;
  }
  
  /**
   * @deprecated
   */
  private static function getPointPaths(nodes:Dynamic, pathNodeMap:PathVertexMap<Int>):PathVertexMap<FlxPoint> {
    
    var pathPointMap:PathVertexMap<FlxPoint> = [for (v in pathNodeMap.keys()) v => new Map()];
    
    for (source in pathNodeMap.keys()) {
      for (target in pathNodeMap[source].keys()) {
        var nodePath:Array<Int> = pathNodeMap[source][target];
        
        pathPointMap[source][target] = [for (i in nodePath) FlxPoint.weak(nodes[i].x, nodes[i].y)];
      }
    }
    
    return pathPointMap;
  }
  
}
