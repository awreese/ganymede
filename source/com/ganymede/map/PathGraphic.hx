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

private class DEFAULTS {
  public static inline var PATH_THICKNESS:Float = 10;
  
  public static var LINE_STYLE:flixel.util.LineStyle = {
    color: Colors.withAlpha(Colors.DEEPSKYBLUE, 0.5),
    thickness: PATH_THICKNESS,
    capsStyle: CapsStyle.ROUND,
    jointStyle: JointStyle.ROUND
  };
  
  public static var DRAW_STYLE:flixel.util.DrawStyle = {
    blendMode: BlendMode.NORMAL,
    smoothing: true
  }
}

/**
 * ...
 * @author Drew Reese
 */
class PathGraphic extends FlxSprite {
  
  public function new(points:Array<FlxPoint>) {
    super();
    
    this.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
    drawPath(points);
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
    
    lineStyle = (lineStyle == null) ? DEFAULTS.LINE_STYLE : lineStyle;
    drawStyle = (drawStyle == null) ? DEFAULTS.DRAW_STYLE : drawStyle;
    
    FlxSpriteUtil.drawPolygon(this, points, FlxColor.TRANSPARENT, lineStyle, drawStyle);
    //var end:FlxPoint = points.pop();
    //FlxSpriteUtil.drawCircle(this, end.x, end.y, 15, lineStyle.color, lineStyle, drawStyle);
    //points.push(end);
  }
  
}