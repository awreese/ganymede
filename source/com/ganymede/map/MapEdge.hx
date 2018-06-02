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

package com.ganymede.map;

import com.ganymede.util.Colors;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;

private class Consts {
  public static inline var EDGE_WIDTH:Float = 3;
}

//private class Colors {
  //public static var EDGE_LINE = FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.6);
  //public static var EDGE_HIGHLIGHT = FlxColor.fromRGBFloat(0.7, 0.1, 0.1, 0.3);
//}

private class Styles {
  public static var EDGE_HIGHLIGHT = {color: Colors.EDGE_HIGHLIGHT};
}

/**
 * ...
 * @author Drew Reese
 */
class MapEdge extends FlxObject {

  public var node1id(default, null):Int;
  public var node2id(default, null):Int;
  
  private var highlighted:Bool;
  
  //public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) {
  public function new(node1id:Int, node2id:Int, thickness:Int) {
    //super(X, Y, Width, Height);
		super();
  }
  
  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
  
  public function toggleON():Void {
    this.visible = true;
  }
  
  public function toggleOFF():Void {
    this.visible = false;
  }
}

class EdgeLine extends FlxSprite {

  public function new (
    p1:FlxPoint, 
    p2:FlxPoint,
    ?visible:Bool = true,
    ?lineStyle:LineStyle,
    ?drawStyle:DrawStyle
  ) {
    super();
    
    trace('FlxG.width/height: $FlxG.width, $FlxG.height');

    this.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
    //FlxSpriteUtil.drawLine(this, p1.x, p1.y, p2.x, p2.y, {color: FlxColor.MAGENTA});
    FlxSpriteUtil.drawLine(this, p1.x, p1.y, p2.x, p2.y, {color: Colors.EDGE_LINE});
    FlxSpriteUtil.drawLine(this, p1.x, p1.y, p2.x, p2.y, lineStyle, drawStyle);

    trace('Edge $p1 -> $p2');
    
    this.visible = true;
    FlxG.state.add(this);
  }
}
