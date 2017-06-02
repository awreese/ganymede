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

package gameUnits.weapons.launchers;

import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import gameUnits.weapons.ammunition.Missile;

/**
 * ...
 * @author Drew Reese
 */
class Launcher extends FlxTypedWeapon<Missile> {

    private var launcherSize:WeaponSize;
    
    public function new(name:String, bulletFactory:FlxTypedWeapon<Missile> -> Missile, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
        super(name, bulletFactory, fireFrom, speedMode);
		
    }
    
    public function getSize():WeaponSize {
        return this.launcherSize;
    }
    
}
