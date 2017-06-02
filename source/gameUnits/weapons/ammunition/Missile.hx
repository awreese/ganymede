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

package gameUnits.weapons.ammunition;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import gameUnits.Ship;

/**
 * Missiles are used for launchers.
 * @author Drew Reese
 */
class Missile extends Ammunition  {
	
	private function new(damage:Float)  {
		super(damage);
		this.accelerates = true;
        
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		// check if target exists & track target's position
		if (target.exists) {
			
			// adjust trajectory to target
			
			// check for collision
			if (this.overlaps(target)) {
				// Do damage to target & destroy missile
				target.hurt(damage);
				// maybe show explosion animation?
				this.kill();
			}
		}
		
	}
	
}
