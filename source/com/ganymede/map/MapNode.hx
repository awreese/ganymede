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

import com.ganymede.gameUnits.capturable.Capturable;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

private class Consts {
  public static inline var NODE_RADIUS:Int = 30;
}

private class Colors {
  public static inline var NODE_DISK = FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.6);
  public static inline var NODE_SELECTED = FlxColor.fromRGBFloat(0.9, 0.4, 0.5, 0.5);
  public static inline var NODE_HIGHLIGHT = FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.3);
}

private class Styles {
  public static inline var NODE_SELECTED = {color: FlxColor.YELLOW};
}

/**
 * Graphical game object representation of an underlying map's graph node.
 * @author Drew Reese
 */
class MapNode extends FlxObject {

  // Fields
  private var radius:Int;
  private var node_disk:MapNodeRing;
  private var node_selected:MapNodeRing;
  private var node_highlight:MapNodeRing;

  private var isSelected:Bool = false;

  // Game objects at this node
  private var capturable:Capturable;

  public function new(id:Int, x:Float, y:Float, ?radius:Int = Consts.NODE_RADIUS) {

    this.ID = id;
    this.radius = radius;
    var diameter:Int = 2 * radius + 1;
    super(x, y, diameter, diameter);

    this.node_disk = new MapNodeRing(x, y, radius, true, Colors.NODE_DISK);
    this.node_selected = new MapNodeRing(x, y, radius, false, Colors.NODE_SELECTED, Styles.NODE_SELECTED);
    this.node_highlight = new MapNodeRing(x, y, radius * 2, false, Colors.NODE_HIGHLIGHT);

    this.capturable = null;
  }

  override public function update(elapsed:Float):Void {

    var mouse:FlxMouse = FlxG.mouse;
    var mousePos:FlxPoint = mouse.getPosition();

    node_highlight.visible = mouseOver(node_highlight, mousePos);

    if (mouse.justPressed) {
      node_selected.visible = mouseOver(node_selected, mousePos);
    }
    super.update(elapsed);
  }

  private static function mouseOver(o:FlxObject, p:FlxPoint):Bool {
    return o.getHitbox().containsPoint(p);
  }

  /**
   * Sets the capturable object at this node.
   * @param capturable capturable object to set at this node
   */
  public function setCapturable(capturable:Capturable):Bool {
    if (capturable != null) {
      this.capturable = capturable;
      return true;
    }
    return false;
  }

  /**
   * Returns true if capturable object exists on this node, false otherwise.
   * @return true iff a capturable object exists at this node, false otherwise
   */
  public function isCapturable():Bool {
    return this.capturable != null;
  }

  /**
   * Returns capturable object at this node, or null if none exists.
   * @return capturableobject stored at this node
   */
  public function getCaptureable(): Capturable {
    return capturable;
  }

}

class MapNodeRing extends FlxSprite {

  public function new (
    x:Float, y:Float,
    ?radius:Int = Consts.NODE_RADIUS,
    ?visible:Bool = true,
    ?fill:FlxColor = FlxColor.TRANSPARENT,
    ?lineStyle:LineStyle,
    ?drawStyle:DrawStyle
  ) {
    super(x, y);

    var diameter:Int = 2 * radius + 1;

    this.makeGraphic(diameter, diameter, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(this, -1, -1, radius, fill, lineStyle, drawStyle);
    this.setPosition(x - radius, y - radius);
    this.visible = visible;
    FlxG.state.add(this);
  }
}
