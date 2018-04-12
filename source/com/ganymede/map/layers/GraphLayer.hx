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

typedef PathMapPoint = PathVertexMap<FlxPoint>;
private typedef Vertex = LevelNode;
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
  
  private var _size_:LevelSize;
  private var _graph_:Graph<Int, Float>;
  private var _node_array_:LevelNodeArray;
  //private var _path_map_:PathMapFlxPoint;

  public function new(levelData:LevelData) {
    super();
    this._size_ = levelData.size;
    //this._graph_ = levelData.mapGraph;
    this._graph_ = buildGraph(levelData.nodes.nodes);
    this._node_array_ = levelData.nodes;
    //this._path_map_ = levelData.pathPointMap;
    trace('built graph', this._graph_);
    trace(this._graph_.getVertices(0));
  }
  
  private static function buildGraph(vertices:Array<LevelNode>):Graph<Int, Float> {
    
    function distance(src:LevelNode, dst:LevelNode):Float {
      var dx = src.x - dst.x;
      var dy = src.y - dst.y;
      return Math.sqrt(dx * dx + dy * dy);
    }
    
    
    var graph:Graph<Int, Float> = new Graph();
    
    // Add nodes by index
    for (i in 0...vertices.length) {
      graph.add(vertices[i].id);
    }
    
    // Add edges
    for (n in 0...vertices.length) {
      var src:Vertex = vertices[n];
      var edges:Array<Int> = src.edges;
      
      for (e in 0...edges.length) {
        var dst:Vertex = vertices[edges[e]];
        var distance = distance(src, dst);
        
        graph.connect(src.id, dst.id, distance);
      }
    }
    
    return graph;
  }
  
  private static function getPaths(graph:Graph<Int, Float>):PathVertexMap<Int> {
    var pathVertexMap:PathVertexMap<Int> = [for (v in graph.getVertices()) v => new Map()];
    
    for (src in graph.getVertices()) {
      var vertexMap:VertexMap = graph.getPaths(src);
      
      for (dst in graph.getVertices()) {
        pathVertexMap[src][dst] = graph.getPath(vertexMap, src, dst);
      }
    }
    
    return pathVertexMap;
  }
  
  private static function getPathPoints() {
    
  }
  
  private function addNode(node:Int):Void {
    
  }
  
  private function addEdge(edge:Int):Void {
    
  }
  
  public function highlightPath(n1:Int, n2:Int):Void {
    
  }
  
}