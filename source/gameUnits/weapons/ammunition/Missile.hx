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
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.util.helpers.FlxBounds;
import gameUnits.Ship;
import gameUnits.weapons.WeaponSize;

/**
 * Missiles are used for launchers.
 * @author Drew Reese
 */
class Missile extends Ammunition  {
    
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    private var _velocity:Float;
    private var _acceleration:Float;
	
	private function new(missileSize:WeaponSize, damage:Float, velocity:Float, acceleration:Float)  {
		super(missileSize, damage);
		this.accelerates = true;
        
        this._velocity = velocity;
        this._acceleration = acceleration;
        
        loadGraphic(AssetPaths.missile__png, true, 61, 9);
        animation.add("fire", [1, 2, 3, 2], 2, true);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		// check if target exists & track target's position
		if (target.exists) {
			
			// adjust trajectory to target
            adjustTrajectory();
			
			// check for collision
			if (this.overlaps(target)) {
				// Do damage to target & destroy missile
				target.hurt(_damage);
				// maybe show explosion animation?
				this.kill();
			}
		}
        
        adjustAngle();
		
	}
    
    public function start(a:Bool, b:Float):Void {
        
    }
    
    private function adjustTrajectory():Void {
        var p1 = this.getMidpoint();
        var p2 = target.getMidpoint();
        
        var dx = p2.x - p1.x;
        var dy = p2.y - p1.y;
        
        p1.put();
        p2.put();
        
        var angle = Math.atan2(dy, dx);
        
        FlxVelocity.accelerateFromAngle(this, angle, _acceleration, _velocity, false);
    }
    
    private function adjustAngle():Void {
        this.angle = pointToVector(this.velocity).degrees;
    }
    
    private static inline function pointToVector(point:FlxPoint):FlxVector {
        return FlxVector.get(point.x, point.y);
    }
	
}

class Missile_Small extends Missile {
    public static var FLIGHT_TIME:FlxBounds<Float> = new FlxBounds(3.0);
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    public function new(?damage:Float = 5.0, ?velocity:Float = 120.0, ?acceleration:Float = 100.0) {
        super(SMALL, damage, velocity, acceleration);
        this.setGraphicSize(16, 0);
        this.updateHitbox();
    }
}
