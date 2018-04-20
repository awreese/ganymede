package com.ganymede.map.layers;

import flixel.FlxBasic;
import flixel.group.FlxGroup;
import js.Browser;

/**
 * Object layer holds instances of planet, beacon, and hazzard groups.
 * 
 * @author Drew Reese
 * 
 * - Layer 2 (Game Object Group)
 *   - planets
 *     - upgrade UI
 *     - capture bars
 *   - beacons
 *     - capture bars
 *   - ships???
 *   - hazards
 */
class ObjectLayer extends FlxGroup {
  public var beacons(default, null):FlxGroup;
  public var hazzards(default, null):FlxGroup;
  public var planets(default, null):FlxGroup;
  public var ships(default, null):FlxGroup;

  public function new() {
    super();
    this.beacons = new FlxGroup();
    this.hazzards = new FlxGroup();
    this.planets = new FlxGroup();
    this.ships = new FlxGroup();
    
    super.add(this.beacons);
    super.add(this.hazzards);
    super.add(this.planets);
    super.add(this.ships);
  }
  
  override public function add(Object:FlxBasic):FlxBasic {
    Browser.console.error("Tried adding object to base objects group, this is a non-op. Don't do it again!");
    return null;
  }
  
}
