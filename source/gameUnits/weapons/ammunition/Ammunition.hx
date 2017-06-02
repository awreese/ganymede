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

/**
 * Generic ammunition class.  All munitions used in-game
 * extend this class.
 * @author Drew Reese
 */
class Ammunition extends FlxBullet {

    public var target:Ship;
	private var damage:Float;
    
    private function new(damage:Float) {
        super();
		this.damage = damage;
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        // check if target exists & test collision
		if (target.exists && this.overlaps(target)) {
            
            // Do damage to target & destroy missile
            target.hurt(damage);
            // maybe show explosion animation?
            this.kill();
		}
    }
    
}

/**
 * Charges are used for turrets.
 */
class Charge extends Ammunition {
    private function new(damage:Float) {
        super(damage);
        this.accelerates = false;
    }
}
