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

import flixel.util.helpers.FlxBounds;
import gameUnits.weapons.WeaponSize;

/**
 * Projectiles represent a projectile ammo type (think actual bullets) used
 * by Projectile turrets. Projectiles have a medium velocity but do higher 
 * damage.
 * 
 * @author Drew Reese
 * 
 * This file contains:
 * 	+ Projectile Class
 * 		- Small
 * 		- Medium
 * 		- Large
 * 		- Capital
 */

/**
 * Projectiles are used in Projectile turrets.
 */
class Projectile extends Charge {
	
	public static var SPEED:FlxBounds<Float> = new FlxBounds(250.0, 350.0);

	/* dianmeter in pixels for projectile sizes */
    private static var _SIZE_SML_:Int = 3;
    private static var _SIZE_MED_:Int = 5;
    private static var _SIZE_LRG_:Int = 7;
    private static var _SIZE_CAP_:Int = 9;
    
    public var _size(default, null):Int;
	
    private function new(chargeSize:WeaponSize, damage:Float) {
        super(chargeSize, damage);
		
		// load graphic
		/* load graphic here */
		switch(chargeSize) {
            case SMALL:
                this._size = _SIZE_SML_;
            case MEDIUM:
                this._size = _SIZE_MED_;
            case LARGE:
                this._size = _SIZE_LRG_;
            case CAPITAL:
                this._size = _SIZE_CAP_;
        }
        this.setGraphicSize(0, _size);
        this.updateHitbox();
        
    }
    
}

class Projectile_Small extends Projectile {
	
	public function new(?damage:Float = 60.0) {
		super(SMALL, damage);
	}
}
class Projectile_Medium extends Projectile {
	
	public function new(?damage:Float = 60.0) {
		super(MEDIUM, damage);
	}
}
class Projectile_Large extends Projectile {
	
	public function new(?damage:Float = 60.0) {
		super(LARGE, damage);
	}
}
class Projectile_Capital extends Projectile {
	
	public function new(?damage:Float = 60.0) {
		super(CAPITAL, damage);
	}
}
