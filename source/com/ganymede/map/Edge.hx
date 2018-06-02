/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
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

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * EdgeGroup is a group of MapEdges
 */
//typedef EdgeGroup = FlxTypedGroup<map.MapEdge>;

class EdgeLine extends FlxSprite {

  public function new (id:Int, p1:FlxPoint, p2:FlxPoint) {
    super();
    
    //trace('FlxG.width/height: ${FlxG.width}, ${FlxG.height}');

    this.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
    var fill = FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.6);
    FlxSpriteUtil.drawLine(this, p1.x, p1.y, p2.x, p2.y, {color: fill, thickness: 5});

    //trace('Edge $p1 -> $p2');
    
    this.visible = true;
    //FlxG.state.add(this);
  }
}

/**
 * Edge connects two nodes in a graph.
 *
 * @author Rory Soiffer
 * @author Drew Reese
 */
//class MapEdge extends FlxBasic {
class Edge {

  public var n1:Node;
  public var n2:Node;
  private var distance:Float;

  public function new(n1:Node, n2:Node) {
    //if (n1.pos.equals(n2.pos)) {
    if (n1.getPosition().equals(n2.getPosition())) {
      return;
    }

    this.n1 = n1;
    this.n2 = n2;
    //this.distance = n1.pos.dist(n2.pos);
    this.distance = n1.getPosition().distanceTo(n2.getPosition());
    new EdgeLine(0, n1.getPosition(), n2.getPosition());
  }

  public function delta():FlxVector {
    //return n2.pos.subtractNew(n1.pos);
    return n2.getPos().subtractNew(n1.getPos());
  }

  public function interpDist(d:Float):FlxVector {
    return (length() != 0) ? interpPerc(d / length()) : new FlxVector(0,0); // check division by 0!!
  }

  public function interpPerc(i:Float):FlxVector {
    //return n1.pos.addNew(delta().scale(i));
    return n1.getPos().addNew(delta().scale(i));
  }

  public function length():Float {
    return n1.distanceTo(n2);
  }

  public function pathTo(n:Node, d:Float):Array<Edge> {
    var path1 = n1.pathTo(n);
    var d1: Float = d;
    for (e in path1) {
      d1 += e.length();
    }

    var path2 = n2.pathTo(n);
    var d2: Float = length() - d;
    for (e in path2) {
      d2 += e.length();
    }

    if (d1 > d2) {
      path2.unshift(this);
      return path2;
    } else {
      path1.unshift(new Edge(n2, n1));
      return path1;
    }
  }
}
