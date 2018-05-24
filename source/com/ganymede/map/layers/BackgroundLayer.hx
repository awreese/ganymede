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

import flixel.FlxBasic;
import flixel.group.FlxGroup;

/**
 * Background layer holds instance of background image.
 * 
 * @author Drew Reese
 * 
 * - Layer 0 (Background Group)
 *    - background image
 */
class BackgroundLayer extends FlxGroup {

  private var background:FlxBasic;
  
  public function new() {
    super();
  }
  
  /**
   * Overridden to allow only adding a single background image.
   * 
   * Adding new object replaces existing object in group.
   * 
   * @param Object
   * @return Added Object
   */
  override public function add(Object:FlxBasic):FlxBasic {
    this.remove(this.background, true);
    this.background = Object;
    return super.add(Object);
  }
  
}
