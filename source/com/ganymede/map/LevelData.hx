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

package com.ganymede.map;

import com.ganymede.util.graph.Graph;
import flixel.math.FlxPoint;

/**
 * Classes and Typedefs for map level data.
 * 
 * Data is loaded from Ganymede.DB as dynamic objects, these 
 * classes are the typed object equivalent.  The purpose is to
 * have the Genymede.DB accessors build and return useable typed
 * objects for game use instead of dynamic object types so 
 * compile-time type checks happen instead of run-time checks.
 * 
 * The classes are used by Ganymede.DB to construct typed objects 
 * that are returned within a LevelData object for consumption.
 * 
 * @author Drew Reese
 */

class LevelSize {
  public var id(default, null):String;
  public var width(default, null):Int;
  public var height(default, null):Int;
  
  public function new(size:Dynamic) {
    this.id = size.id;
    this.width = size.width;
    this.height = size.height;
  }
}

class LevelNodeArray {
  public var nodes(default, null):Array<LevelNode>;
  
  public function new(nodes:Dynamic) {
    this.nodes = [for (i in 0...nodes.length) new LevelNode(i, nodes[i])];
  }
}

class LevelNode {
  public var id(default, null):Int;
  public var x(default, null):Int;
  public var y(default, null):Int;
  public var edges(default, null):Array<Int>;
  
  public function new(id:Int, node:Dynamic) {
    this.id = id;
    this.x = node.x;
    this.y = node.y;
    this.edges = [for (i in 0...node.edges.length) node.edges[i].edge];
  }
}

typedef PathVertexMap<V> = Map<Int,Map<Int,Array<V>>>;

typedef LevelData = {
  size:LevelSize,
  nodes:Array<LevelNode>,
}

