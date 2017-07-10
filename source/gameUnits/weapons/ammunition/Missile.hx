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

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;
import gameUnits.weapons.WeaponSize;
import gameUnits.weapons.ammunition.Ammunition.I_Ammunition;

/**
 * Missile.hx is an ammunition type for use in launchers.
 * @author Drew Reese
 * 
 * This file contains:
 *  - Missile Interface
 *  - Missile Class
 *  - Sub-classes
 *      - Small
 *      - Medium
 *      - Large
 *      - Capital
 *  - Missile Exhaust Class
 *  - Missile Explosion Class
 */

/**
 * Missile Interface.
 */
interface I_Missile extends I_Ammunition{
    private var _size(default, null):Int;
    private var _velocity:Float;
    private var _acceleration:Float;
    private var _exhaust:FlxEmitter;
    
    public function start():Void;
    public function explode():Void;
}

/**
 * Missiles are used for launchers.
 */
class Missile extends Ammunition implements I_Missile {
    
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    /* length in pixels for sizes */
    private static var _SIZE_SML_:Int = 16;
    private static var _SIZE_MED_:Int = 32;
    private static var _SIZE_LRG_:Int = 48;
    private static var _SIZE_CAP_:Int = 64;
    
    public var _size(default, null):Int;
    private var _velocity:Float;
    private var _acceleration:Float;
    private var _exhaust:FlxEmitter;
	
	private function new(missileSize:WeaponSize, damage:Float, velocity:Float, acceleration:Float)  {
		super(missileSize, damage);
		this.accelerates = true;
        
        loadGraphic(AssetPaths.missile__png, true, 61, 9);
        animation.add("fire", [1, 2, 3, 2], 2, true);
        
        switch(missileSize) {
            case SMALL:
                this._size = _SIZE_SML_;
            case MEDIUM:
                this._size = _SIZE_MED_;
            case LARGE:
                this._size = _SIZE_LRG_;
            case CAPITAL:
                this._size = _SIZE_CAP_;
        }
        this.setGraphicSize(_size, 0);
        this.updateHitbox();
        
        this._velocity = velocity;
        this._acceleration = acceleration;
        
        this._exhaust = new MissileExhaust(this);
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
				this.kill();
                explode();
			}
		}
        
        adjustAngle();
		
	}
    
    /**
     * Overridden to kill missile exhaust.
     */
    override public function kill():Void {
        super.kill();
        _exhaust.kill();
        //explode();
    }
    
    /**
     * Starts up the missile.  This implementation starts the exhaust only.
     */
    public function start():Void {
        _exhaust.start(false, 0.025);
    }
    
    /**
     * Displays emitted particle explosion.
     */
    public function explode():Void {
        new MissileExplosion(this);
    }
    
    /**
     * Adjusts this missile's velocity towards the currently set target.
     */
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
    
    /**
     * Adjusts this missile's angle to match its velocity vector.
     */
    private function adjustAngle():Void {
        this.angle = pointToVector(this.velocity).degrees;
    }
    
    /**
     * Returns weak vector representation of specified FlxPoint point.  Remember to call put() when done with vector.
     * @param point to return vector of
     * @return FlxVector of specified point
     */
    private static inline function pointToVector(point:FlxPoint):FlxVector {
        return FlxVector.get(point.x, point.y);
    }
	
}

class Missile_Small extends Missile {
    public static var FLIGHT_TIME:FlxBounds<Float> = new FlxBounds(2.0);
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    public function new(?damage:Float = 50.0, ?velocity:Float = 120.0, ?acceleration:Float = 100.0) {
        super(SMALL, damage, velocity, acceleration);
    }
}
class Missile_Medium extends Missile {
    public static var FLIGHT_TIME:FlxBounds<Float> = new FlxBounds(2.0);
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    public function new(?damage:Float = 50.0, ?velocity:Float = 120.0, ?acceleration:Float = 100.0) {
        super(MEDIUM, damage, velocity, acceleration);
    }
}
class Missile_Large extends Missile {
    public static var FLIGHT_TIME:FlxBounds<Float> = new FlxBounds(2.0);
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    public function new(?damage:Float = 50.0, ?velocity:Float = 120.0, ?acceleration:Float = 100.0) {
        super(LARGE, damage, velocity, acceleration);
    }
}
class Missile_Capital extends Missile {
    public static var FLIGHT_TIME:FlxBounds<Float> = new FlxBounds(2.0);
    public static var LAUNCH_SPEED:FlxBounds<Float> = new FlxBounds(30.0);
    
    public function new(?damage:Float = 50.0, ?velocity:Float = 120.0, ?acceleration:Float = 100.0) {
        super(CAPITAL, damage, velocity, acceleration);
    }
}

/**
 * Missile exhaust particle emitter.
 */
class MissileExhaust extends FlxEmitter {
    private static var MAX_PARTICLES:Int = 15;
    
    private var _missile:Missile;
    
    public function new(missile:Missile) {
        super(missile.x, missile.y, MAX_PARTICLES);
        
        this._missile = missile;
        
        var psize:Int;
        switch(_missile.get__ammoSize()) {
            case SMALL:
                psize = 1;
            case MEDIUM:
                psize = 2;
            case LARGE:
                psize = 3;
            case CAPITAL:
                psize = 4;
        }
        
        makeParticles(psize, psize, FlxColor.WHITE, MAX_PARTICLES);
        
        lifespan.set(0.5);
        
        launchMode = FlxEmitterMode.CIRCLE;
        launchAngle.set( -180.0, 180.0);
        speed.set(0.0, 0.0, 1.0, 1.0);
        angle.set( -90.0, 90.0);
        angularVelocity.set( -180.0, -90.0, 90.0, 180.0);
        alpha.set(1.0, 1.0, 0.0, 0.0);
        color.set(FlxColor.WHITE, FlxColor.WHITE, FlxColor.BLACK, FlxColor.BLACK);
        
        FlxG.state.add(this);
    }
    
    /**
     * Overriding in order to emit particles at the correct position
     * taking into account the missile's position and angle.
     */
    override public function update(elapsed:Float):Void {
        var h = _missile._size / 2;
        var theta = FlxAngle.asRadians(_missile.angle);
        
        var dx = h * Math.cos(theta);
        var dy = h * Math.sin(theta);
        
        var mp = _missile.getMidpoint();
        setPosition(mp.x - dx, mp.y - dy);
        mp.put();
        
        super.update(elapsed);
    }
}

/**
 * Missile explosion particle emitter.
 */
class MissileExplosion extends FlxEmitter {
    
    public function new(missile:Missile) {
        
        var num_particles:Int;
        switch(missile.get__ammoSize()) {
            case SMALL:
                num_particles = 5;
            case MEDIUM:
                num_particles = 10;
            case LARGE:
                num_particles = 15;
            case CAPITAL:
                num_particles = 20;
        }
        super(missile.x, missile.y, num_particles);
        makeParticles(2, 2, FlxColor.WHITE, num_particles);
        
        lifespan.set(0.3);
        
        launchMode = FlxEmitterMode.CIRCLE;
        launchAngle.set( -180.0, 180.0);
        alpha.set(1.0, 1.0, 0.0, 0.0);
        color.set(FlxColor.YELLOW, FlxColor.YELLOW, FlxColor.WHITE, FlxColor.BLACK);
        velocity.set(0.5, 0.5, 1.0, 1.0);
        angle.set( -90.0, 90.0);
        
        FlxG.state.add(this);
        
        start(true);
    }
}
