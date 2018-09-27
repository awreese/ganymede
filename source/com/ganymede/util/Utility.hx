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

package com.ganymede.util;

class FloatTools {

  /**
   * Rounds a float value @number to N digits of @precision.
   * @param number
   * @param precision
   * @return float rounded to N digits
   */
  static public function roundN(number:Float, precision:Int):Float {
    var p = Math.pow(10, precision);
    return Math.round(number * p) / p;
  }
  
  /**
   * Bouonds @number to inclusive range @min and @max.
   * @param number
   * @param min
   * @param max
   * @return bounded float
   */
  static public function bound(number:Float, min:Float, max:Float):Float {
    return Math.max(min, Math.min(number, max));
  }
  
}
