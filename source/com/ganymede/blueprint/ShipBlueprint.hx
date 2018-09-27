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

package com.ganymede.blueprint;

/**
 * Blueprint for a single ship.
 * @author Drew Reese
 */
class ShipBlueprint {
  public var id(default, null):String;
  public var description(default, null):String;
  public var hull_class(default, null):String;
  public var orbit_velocity(default, null):Float;
  public var warp_velocity(default, null):Float;
  public var angular_velocity(default, null):Float;
  public var hit_points(default, null):Float;
  public var shield_strength(default, null):Float;
  public var hp_regen(default, null):Float;
  public var capture_points_per_second(default, null):Float;
  public var sensor_range(default, null):Float;
  public var turret_hardpoints(default, null):Int;
  public var launcher_hardpoints(default, null):Int;
  public var turrets(default, null):Array<String>;
  public var launchers(default, null):Array<String>;

  public function new(
    id:String,
    description:String,
    hull_class:String,
    orbit_velocity:Float,
    warp_velocity:Float,
    angular_velocity:Float,
    hit_points:Float,
    shield_strength:Float,
    hp_regen:Float,
    capture_points_per_second:Float,
    sensor_range:Float,
    turret_hardpoints:Int,
    launcher_hardpoints:Int,
    turrets:Array<String>,
    launchers:Array<String>
  ) {
    this.id = id;
    this.description = description;
    this.hull_class = hull_class;
    this.orbit_velocity = orbit_velocity;
    this.warp_velocity = warp_velocity;
    this.angular_velocity = angular_velocity;
    this.hit_points = hit_points;
    this.shield_strength = shield_strength;
    this.hp_regen = hp_regen;
    this.capture_points_per_second = capture_points_per_second;
    this.sensor_range = sensor_range;
    this.turret_hardpoints = turret_hardpoints;
    this.launcher_hardpoints = launcher_hardpoints;
    this.turrets = turrets;
    this.launchers = launchers;
  }
}
