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
import gameUnits.Ship;
import gameUnits.weapons.ammunition.Ammunition.Charge;

/**
 * Represents laser projectile ammo type.
 * @author Drew Reese
 */
class Laser extends Charge {
	
	private function new(damage:Float)  {
		super(damage);
		this.maxVelocity.set(500.0, 500.0);
	}
	
}

/**
 * Pulse lasers
 * Faster tracking, shorter range, higher rate of fire, less damage per shot
 */
class Pulse extends Laser {
    
    public static var PULSE_SPEED:Float = 500.0;
	
	public function new(damage:Float) {
		super(damage);
        loadGraphic("assets/images/pulse_laser.png", false);
		this.lifespan = 0.5;
	}
	
}

/**
 * Beam lasers
 * Slower tracking, longer range, lower rate of fire, more damage per shot
 */
class Beam extends Laser {
	
	private var source:Ship;
	
	public function new(damage:Float) {
		super(damage);
		this.lifespan = 1.0;
		
	}
	
}
