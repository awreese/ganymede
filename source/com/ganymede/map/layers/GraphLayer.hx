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

import com.ganymede.db.DB_Data;
import com.ganymede.map.MapNode;
import com.ganymede.map.PathGraphic;
import com.ganymede.util.graph.Graph;
import com.ganymede.util.Colors;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

private typedef Vertex = DB_LevelNode;
private typedef VertexArray = Array<DB_LevelNode>;
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
  
  private var _path_layer_:FlxSprite;             // Base map layer
  private var _paths_:FlxGroup;                   // Individual paths
  private var _mapNodes_:FlxTypedGroup<MapNode>;  // Nodes on the map
  
  private var _graph_:Graph<Int, Float>;
  private var _path_map_:PathMap;
  
  private var selectedNodeId:Int;
  private var hoveredNodeId:Int;

  public function new () {
    super();
    this._path_layer_ = new FlxSprite();
    this._path_layer_.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true, 'pathLayer');
    
    super.add(this._path_layer_);
    
    this._paths_ = new FlxGroup();
    super.add(this._paths_);
    
    this._mapNodes_ = new FlxTypedGroup();
    super.add(this._mapNodes_);
  }
  
  /**
   * Overridden to prevent adding objects to graph layer group.
   */
  override public function add(Object:FlxBasic):FlxBasic {
    FlxG.log.error("Tried adding object to graph layer group, this is a non-op.  Don't do it again!");
    return null;
  }
  
  public function set_level_data(levelData:LevelData) {
    this.addNodes(levelData.nodes);
    
    this._graph_ = buildGraph(levelData.nodes);
    this._path_map_ = buildPathMap(this._graph_, this._mapNodes_.members);
    
    for (v1 in 0...this._mapNodes_.length) {
      for (v2 in 0...this._mapNodes_.length) {
        this._paths_.add(this._path_map_._entries_[v1][v2].graphic);
      }
    }
    this.selectedNodeId = null;
    this.hoveredNodeId = null;
  }
  
  //public function clear():Void {
    //this._path_layer_ = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true, 'pathLayer');
    //
  //}
  
  private function buildGraph(vertices:Array<DB_LevelNode>):Graph<Int, Float> {
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
        
        // add path line to path layer
        FlxSpriteUtil.drawLine(
          this._path_layer_, 
          src.position.x, src.position.y,
          dest.position.x, dest.position.y, 
          {color: Colors.withAlpha(Colors.WHITE, 0.025), thickness: 20}
        );
      }
    }
    return graph;
  }
  
  private static function buildPathMap(graph:Graph<Int, Float>, vertices:Array<MapNode>):PathMap {
    var pathMap:PathMap = new PathMap();
    
    for (src in graph.getVertices()) {
      for (dst in graph.getVertices()) {
        var pathVertices:Array<Int> = graph.findPath(src, dst);
        var pathPoints:Array<FlxPoint> = [
          //for (v in pathVertices) new FlxPoint(vertices[v].position.x, vertices[v].position.y)
          for (v in pathVertices) vertices[v].position.copyTo() // TODO: deconstruct these points in future?
        ];
        pathMap.addEntry(src, dst, pathVertices, pathPoints);
      }
    }
    
    return pathMap;
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
  
  private static function getPathPoints(vertices:Array<DB_LevelNode>, pathVertexMap:VertexPathMap<Int>):VertexPathMap<FlxPoint> {
    var pathPointMap:VertexPathMap<FlxPoint> = [for (v in pathVertexMap.keys()) v => new Map()];
    
    for (src in pathVertexMap.keys()) {
      for (dest in pathVertexMap[src].keys()) {
        var path:Array<Int> = pathVertexMap[src][dest];
        pathPointMap[src][dest] = [for (v in path) vertices[v].position];
      }
    }
    return pathPointMap;
  }
  
  private function addNodes(nodes:Array<DB_LevelNode>):Void {
    for (node in nodes) {
      this._mapNodes_.add(new MapNode(node.id, node.position.x, node.position.y));
    }
  }
  
  private function addNode(node:DB_LevelNode):Void {
    
  }
  
  private function addEdge(edge:Int):Void {
    
  }
  
  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    
    this.checkSelected();
    this.checkHovered();
    
  }
  
  /**
   * Checks if any nodes are currently selected and sets
   * this.selectedNode accordingly.
   * 
   * Hides any old highlighted paths if new node is selected and sets
   * new selected node.
   */
  private function checkSelected():Void {
    for (src in this._mapNodes_) {
      if (src.isSelected) {
        if (src.id != this.selectedNodeId) {
          this.hidePath(this.selectedNodeId, this.hoveredNodeId);
          this.selectedNodeId = src.id;
        }
        return;
      }
    }
    this.selectedNodeId = null;
  }
  
  /**
   * Checks if any nodes are currently selected and sets
   * this.selectedNode accordingly.
   */
  private function checkHovered():Void {
    for (src in this._mapNodes_) {
      if (src.isMouseover) {
        if (src.id != this.hoveredNodeId) {
          this.hoveredNodeId = src.id;
          this.highlightPath(this.selectedNodeId, this.hoveredNodeId);
        }
        return;
      }
      this.hidePath(this.selectedNodeId, src.id);
    }
    this.hoveredNodeId = null;
  }
  
  private function getMapEntry(n1:Int, n2:Int):PathMapEntry {
    if (n1 == null || n2 == null) return null;
    return this._path_map_._entries_[n1][n2];
  }
  
  private function highlightPath(n1:Int, n2:Int):Void {
    var pathEntry:PathMapEntry = this.getMapEntry(n1, n2);
    if (pathEntry != null) pathEntry.showPath();
  }
  
  private function hidePath(n1:Int, n2:Int):Void {
    var pathEntry:PathMapEntry = this.getMapEntry(n1, n2);
    if (pathEntry != null) pathEntry.hidePath();
  }
  
  private function getPath(n1:Int, n2:Int):Array<FlxPoint> {
    var pathEntry:PathMapEntry = this.getMapEntry(n1, n2);
    return (pathEntry != null) ? pathEntry.points : [];
  }
  
  public function getHighlightedPath():Array<FlxPoint> {
    return this.getPath(this.selectedNodeId, this.hoveredNodeId);
  }
  
}

/**
 * PathMap
 * 
 * Holds mapping entries from source to destination vertices.
 */
private class PathMap {
  public var _entries_:Map<Int, Map<Int, PathMapEntry>>;
  
  public function new() {
    this._entries_ = new Map<Int, Map<Int, PathMapEntry>>();
  }
  
  public function addEntry(
    v1:Int, 
    v2:Int, 
    vertices:Array<Int>, 
    points:Array<FlxPoint>
  ) {
    if (!this._entries_.exists(v1)) {
      this._entries_.set(v1, new Map<Int, PathMapEntry>());
    }
    if (!this._entries_.exists(v2)) {
      this._entries_.set(v2, new Map<Int, PathMapEntry>());
    }
    
    var pathGraphic:PathGraphic = new PathGraphic(points);
    
    this._entries_[v1][v2] = new PathMapEntry(vertices, points, pathGraphic);
  }
}

/**
 * PathMapEntry
 * 
 * Contains single path map entry comprising of:
 *  - Array of vertix ids
 *  - Array of vertex coordinates
 *  - Path sprite
 */
private class PathMapEntry {
  public var vertices:Array<Int>;
  public var points:Array<FlxPoint>;
  public var graphic:PathGraphic;
  
  public function new(
    vertices:Array<Int>,
    points:Array<FlxPoint>,
    graphic:PathGraphic
  ) {
    this.vertices = vertices;
    this.points = points;
    this.graphic = graphic;
  }
  
  public function showPath():Void {
    this.graphic.toggleOn();
  }
  
  public function hidePath():Void {
    this.graphic.toggleOff();
  }
}