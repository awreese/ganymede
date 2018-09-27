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

package com.ganymede.gameUnits.capturable;

import com.ganymede.db.Ganymede;
import com.ganymede.util.Colors;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

/**
 * CaptureBar is displays the control points for its parent Capturable.
 * @author Drew Reese
 */
class CaptureBar extends FlxBar {
  
  private var capturable:Capturable;

  public function new(capturable:Capturable, ?onEmpty:Void->Void, ?onFilled:Void->Void) {
    this.capturable = capturable;
    
    super(
      capturable.x, capturable.y,           // position
      BOTTOM_TO_TOP,                        // fill direction
      10, 50,                               // dimensions
      capturable, "currentControlPoints",   // parent & property
      0, capturable.totalControlPoints,     // min & max
      true                                  // show border/background
    );
    
    this.trackParent( -40, -25);
    this.emptyCallback = onEmpty;
    this.filledCallback = onFilled;
  }
  
  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    this.updateColor();
    this.visible = isContested();
  }
  
  private function updateColor():Void {
    var color:FlxColor;
    if (this.capturable.isControlled) {
      color = Ganymede.getFactionColor(capturable.controllingFaction);
    } else {
      color = Ganymede.getFactionColor(capturable.capturingFaction);
    }
    this.createFilledBar(FlxColor.TRANSPARENT, color, true, Colors.withAlpha(Colors.GREY, 0.5));
  }
  
  private function isContested():Bool {
    return 0 < value && value < this.capturable.totalControlPoints;
  }  
}
