/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
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

package com.ganymede.gameUnits.combat;

import com.ganymede.faction.Faction.FactionType;
import com.ganymede.gameUnits.Ship;
import flixel.math.FlxRandom;

/**
 * Radar
 * Represents the ships that can be interacted with.
 * Friends are ships that can be flocked with.
 * Foes are ships that can be targeted through combat.
 *
 * @author Drew Reese
 */
class Radar {

  private var faction:FactionType;
  private var friend:Array<Ship>;
  private var foe:Array<Ship>;

  private var rand:FlxRandom = new FlxRandom();

  /**
   * Creates new RADAR object for specified faction object.
   * @param faction   faction of the owner of this shiney new radar
   */
  public function new(faction:FactionType) {
    this.faction = faction;
    this.friend = new Array<Ship>();
    this.foe = new Array<Ship>();
  }

  public function setRadar(ships:Array<Ship>):Void {
    this.friend.splice(0, friend.length);
    this.foe.splice(0, foe.length);

    for (ship in ships) {
      if (this.faction.equals(ship.getFactionType())) {
        this.friend.push(ship);
      } else {
        this.foe.push(ship);
      }
    }
  }

  /**
   * Returns friendly group of ships.
   * @return  friendlies
   */
  public function getFriends():Array<Ship> {
    return this.friend.copy();
  }

  /**
   * Returns enemy group of ships.
   * @return  foes
   */
  public function getFoes():Array<Ship> {
    return this.foe.copy();
  }

  /**
   * Selects target ship at random.
   * @return  randomly chosen enemy ship
   */
  public function selectTarget():Ship {
    return rand.getObject(this.foe, 0);
  }
}
