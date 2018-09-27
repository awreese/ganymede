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
 * Blueprint for a single planet.
 * @author Drew Reese
 */
class PlanetBlueprint {
  public var id(default, null):String;
  public var description(default, null):String;
  public var level(default, null):Int;
  public var max_capacity_level(default, null):Int;
  public var max_technology_level(default, null):Int;
  public var ship_capacity(default, null):Int;
  public var production_rate_seconds(default, null):Float;
  public var production_threshold(default, null):Float;
  public var base_upgrade_cost(default, null):Int;
  public var capacity_upgrade_per_level(default, null):Int;
  public var technology_upgrade_per_level(default, null):Int;
  
  public function new(
    id:String,
    description:String,
    level:Int,
    max_capacity_level:Int,
    max_technology_level:Int,
    ship_capacity:Int,
    production_rate_seconds:Float,
    production_threshold:Float,
    base_upgrade_cost:Int,
    capacity_upgrade_per_level:Int,
    technology_upgrade_per_level:Int
  ) {
    this.id = id;
    this.description = description;
    this.level = level;
    this.max_capacity_level = max_capacity_level;
    this.max_technology_level = max_technology_level;
    this.ship_capacity = ship_capacity;
    this.production_rate_seconds = production_rate_seconds;
    this.production_threshold = production_threshold;
    this.base_upgrade_cost = base_upgrade_cost;
    this.capacity_upgrade_per_level = capacity_upgrade_per_level;
    this.technology_upgrade_per_level = technology_upgrade_per_level;
  }
}
