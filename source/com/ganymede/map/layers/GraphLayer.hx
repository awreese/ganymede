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

import com.ganymede.map.LevelData;
import com.ganymede.map.Node.NodeGroup;
import com.ganymede.util.graph.Graph;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

typedef PathMapPoint = VertexPathMap<FlxPoint>;
private typedef Vertex = LevelNode;
private typedef VertexArray = Array<LevelNode>;
private typedef VertexMap = Map<Int, Int>;

/**
 * Graph layer holds instance of level data.
 * 
 * @author Drew Reese
 * 
 * - Layer 1 (Map Graph Group)
 *   - map node objects
 *   - map edge objects
 *   - path highlighting
 * 
 */
class GraphLayer extends FlxGroup {
  
  private var _level_data_:LevelData;
  
  private var _graph_:Graph<Int, Float>;

  public function new () {
    super();
  }
  public function set(levelData:LevelData) {
    this._level_data_ = levelData;
    
    this._graph_ = buildGraph(this._level_data_.nodes);
    trace('built graph', this._graph_);
    
    var vertexMap:VertexPathMap<Int> = parsePaths(this._graph_);
    var pointMap:VertexPathMap<FlxPoint> = getPathPoints(this._level_data_.nodes, vertexMap);
    
    trace(pointMap[0]);
    
  }
  
  private static function buildGraph(vertices:Array<LevelNode>):Graph<Int, Float> {
    
    var graph:Graph<Int, Float> = new Graph();
    
    // Add nodes by index
    for (i in 0...vertices.length) {
      graph.add(vertices[i].id);
    }
    
    // Add edges
    for (n in 0...vertices.length) {
      var src:Vertex = vertices[n];
      var edges:Array<Int> = src.edges;

      for (e in edges) {
        var dest:Vertex = vertices[e];
        var distance = src.position.distanceTo(dest.position);
        
        graph.connect(src.id, dest.id, distance);
      }
    }
    return graph;
  }
  
  private static function parsePaths(graph:Graph<Int, Float>):VertexPathMap<Int> {
    var pathVertexMap:VertexPathMap<Int> = [for (v in graph.getVertices()) v => new Map()];
    
    for (src in graph.getVertices()) {
      var vertexMap:VertexMap = graph.getPaths(src);
      
      for (dst in graph.getVertices()) {
        pathVertexMap[src][dst] = graph.getPath(vertexMap, src, dst);
      }
    }
    return pathVertexMap;
  }
  
  private static function getPathPoints(vertices:Array<LevelNode>, pathVertexMap:VertexPathMap<Int>):VertexPathMap<FlxPoint> {
    var pathPointMap:VertexPathMap<FlxPoint> = [for (v in pathVertexMap.keys()) v => new Map()];
    
    for (src in pathVertexMap.keys()) {
      for (dest in pathVertexMap[src].keys()) {
        var path:Array<Int> = pathVertexMap[src][dest];
        //pathPointMap[src][dest] = [for (v in path) FlxPoint.weak(vertices[v].x, vertices[v].y)];
        pathPointMap[src][dest] = [for (v in path) vertices[v].position];
      }
    }
    return pathPointMap;
  }
  
  private function addNode(node:LevelNode):Void {
    
  }
  
  private function addEdge(edge:Int):Void {
    
  }
  
  public function highlightPath(n1:Int, n2:Int):Void {
    
  }
  
}