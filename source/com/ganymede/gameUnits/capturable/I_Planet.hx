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

/**
 * @author Drew Reese
 */
interface I_Planet extends I_Capturable {
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
}
