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

package com.ganymede.gameUnits.weapons.launchers;

import com.ganymede.gameUnits.combat.I_Combatant;
import com.ganymede.gameUnits.weapons.I_Weapon;
import com.ganymede.gameUnits.weapons.WeaponSize;
import com.ganymede.gameUnits.weapons.ammunition.Missile;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import flixel.system.FlxSound;
import flixel.util.helpers.FlxBounds;

/**
 * This class represents the in-game missile launchers.
 * @author Drew Reese
 */
class Launcher extends FlxTypedWeapon<Missile> implements I_Weapon {

  private var source:I_Combatant;
  public var size(default, null):WeaponSize;

  public function new(source:FlxSprite, name:String, bulletFactory:FlxTypedWeapon<Missile> -> Missile, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
    super(name, bulletFactory, fireFrom, speedMode);

    // load missile loading and firing sounds
    var load_snd:FlxSound;
    var launch_snd:FlxSound;
    #if flash
    load_snd = FlxG.sound.load(AssetPaths.missile_load__mp3);
    launch_snd = FlxG.sound.load(AssetPaths.missile_fire__mp3);
    #else
    load_snd = FlxG.sound.load(AssetPaths.missile_load__ogg);
    launch_snd = FlxG.sound.load(AssetPaths.missile_fire__ogg);
    #end
    load_snd.looped = false;
    this.onPreFireSound = load_snd;
    launch_snd.looped = false;
    this.onPostFireSound = launch_snd;

    // finish settings
    this.rotateBulletTowardsTarget = false;
    this.source = cast(source, I_Combatant);
    FlxG.state.add(this.group);
  }

  /**
   * Returns the size of this weapon.
   * @return size of this weapon
   */
  public function get_size():WeaponSize {
    return this.size;
  }

  /**
   * Fires missile at selected target.
   */
  public function fire():Void {
    var target = source.selectTarget();
    if (target != null && fireFromParentAngle(new FlxBounds(-10.0, 10.0))) {
      //currentBullet.target = cast(target, FlxSprite);
      
      currentBullet.target(target);
      
      //currentBullet.start(false, 0.025);
      //currentBullet.start();
      //currentBullet.start(false, 0.05);
    }
  }

}

class Launcher_Rocket extends Launcher {

  public function new(source:FlxSprite) {
    super(source, "Rocket Launcher",
    function(d) {
      var rocket = new Missile_Small(50.0);
      return rocket;
    },
    FlxWeaponFireFrom.PARENT(source, new FlxBounds(source.origin), true),
    //FlxWeaponSpeedMode.SPEED(new FlxBounds(65.0))
    FlxWeaponSpeedMode.SPEED(Missile_Small.LAUNCH_SPEED)
         );
    //this.bulletLifeSpan = new FlxBounds(3.0);
    this.bulletLifeSpan = Missile_Small.FLIGHT_TIME;
    this.fireRate = 3000;
    this.size = WeaponSize.SMALL;
  }
}
