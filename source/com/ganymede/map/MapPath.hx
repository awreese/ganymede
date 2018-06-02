/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2018  Andrew Reese
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
import flash.display.BlendMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

private class Consts {
  public static inline var PATH_THICKNESS:Float = 30;
}

//private class Colors {
  ////public static var PATH_LINE = FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.6);
  ////public static var PATH_HIGHLIGHT = FlxColor.fromRGBFloat(0.7, 0.1, 0.1, 0.3);
  //public static var PATH_LINE = FlxColor.LIME;
//}

private class LineStyles {
  public static var NORMAL:flixel.util.LineStyle = {
    color: Colors.PATH_LINE,
    thickness: Consts.PATH_THICKNESS,
    capsStyle: CapsStyle.ROUND,
    jointStyle: JointStyle.ROUND
  }
  //public static var HIGHLIGHT:flixel.util.LineStyle = {
    //color: Colors.PATH_HIGHLIGHT,
    //thickness: Consts.PATH_THICKNESS * 1.2
  //}
}

private class DRAW_STYLE {
  public static var NORMAL:flixel.util.DrawStyle = {
    blendMode: BlendMode.NORMAL,
    smoothing: true
  }
}

/**
 * ...
 * @author Drew Reese
 */
class MapPath extends FlxSprite {
  
  public function new(points:Array<FlxPoint>) {
    super();
    
    this.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
    drawPath(points, LineStyles.NORMAL, DRAW_STYLE.NORMAL);
    this.visible = false;  // NOTE: Default is false, but setting here to ensure not visible!!
  }
  
  public function toggleOn(): Void {
    this.visible = true;
  }
  
  public function toggleOff():Void {
    this.visible = false;
  }
  
  private function drawPath(
    points:Array<FlxPoint>,
    ?lineStyle:LineStyle,
    ?drawStyle:DrawStyle
  ) {
    //var start:FlxPoint = points.shift();
    //FlxSpriteUtil.drawCircle(this, start.x, start.y, 15, lineStyle.color, lineStyle, drawStyle);
    //points.unshift(start);
    FlxSpriteUtil.drawPolygon(this, points, FlxColor.TRANSPARENT, lineStyle, drawStyle);
    //var end:FlxPoint = points.pop();
    //FlxSpriteUtil.drawCircle(this, end.x, end.y, 15, lineStyle.color, lineStyle, drawStyle);
    //points.push(end);
  }
  
}