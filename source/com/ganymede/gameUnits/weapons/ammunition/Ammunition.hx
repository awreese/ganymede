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

package com.ganymede.gameUnits.weapons.ammunition;

import com.ganymede.gameUnits.combat.ICombatant;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxBullet;
import com.ganymede.gameUnits.weapons.WeaponSize;

/**
 * Interface for in-game ammunition.
 * @author Drew Reese
 */
interface I_Ammunition {
  private var _target:FlxSprite;
  private var _damage:Float;

  public var _size(default, null):Int;
  public var _ammoSize(default, null):WeaponSize;
  
  public function target(target:ICombatant):Void;
}

/**
 * Generic ammunition class.  All munitions used in-game
 * extend this class.
 * @author Drew Reese
 */
class Ammunition extends FlxBullet implements I_Ammunition {

  private var _target:FlxSprite;

  public var _ammoSize(default, null):WeaponSize;
  public var _size(default, null):Int;
  private var _damage:Float;

  private function new(ammoSize:WeaponSize, damage:Float) {
    super();
    this._ammoSize = ammoSize;
    this._damage = damage;
  }

  override public function update(elapsed:Float):Void {

    // check if target exists & test collision
    if (_target.exists && this.overlaps(_target)) {

      // Do damage to target & destroy missile
      _target.hurt(_damage);
      this.kill();
    }

    super.update(elapsed);
  }
  
  public function target(target:ICombatant):Void {
    //this._target = cast(target, FlxSprite);
    this._target = cast target;
  }
  
  public function get__ammoSize():WeaponSize {
    return this._ammoSize;
  }

}

/**
 * Charges are used for turrets.
 */
class Charge extends Ammunition {
  private function new(ammoSize:WeaponSize, damage:Float) {
    super(ammoSize, damage);
    this.accelerates = false;
  }
}