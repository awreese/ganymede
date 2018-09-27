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

package com.ganymede.factory;

import com.ganymede.gameUnits.ships.HullType;
import com.ganymede.gameUnits.ships.I_Ship;

/**
 * @author Drew Reese
 */
interface I_ShipFactory extends I_Factory {
  public var productionCheck:Void->Bool;
  
  public function produceShip(hullType:HullType):I_Ship;
}