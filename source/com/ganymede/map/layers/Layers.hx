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

import flixel.group.FlxGroup;

/**
 * Game map layers container.
 * 
 * These layers represent the different layers in which
 * game graphic objects are added to.  Groups are instantiated
 * and added here to preserve proper rendering order (objects
 * are rendered in monotonically increasing order in which they
 * are added).  This allows objects to be added to these groups
 * later and will be rendered in order within each layer group.
 * 
 * Graphics Load Order
 *  - Layer 0 (Background Group)
 *    - background image
 *  - Layer 1 (Map Graph Group)
 *    - map node objects
 *    - map edge objects
 *    - path highlighting
 *  - Layer 2 (Game Object Group)
 *    - planets
 *      - upgrade UI
 *      - capture bars
 *    - beacons
 *      - capture bars
 *    - hazards
 *  - Layer 3 (HUD/UI Group)
 *    - game HUD
 *    - other various UI components
 * 
 * @author Drew Reese
 */
class Layers extends FlxGroup {
  public var background:FlxGroup;
  public var graph:GraphLayer;
  public var objects:FlxGroup;
  public var interfaces:FlxGroup;

  public function new() {
    super();
    this.background = new BackgroundLayer();
    this.graph = new GraphLayer();
    this.objects = new FlxGroup();
    this.interfaces = new FlxGroup();
    
    this.add(this.background);
    this.add(this.graph);
    this.add(this.objects);
    this.add(this.interfaces);
  }
  
}
