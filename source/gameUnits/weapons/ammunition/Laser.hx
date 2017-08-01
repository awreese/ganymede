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
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;
import gameUnits.combat.I_Combatant;
import gameUnits.weapons.WeaponSize;
import gameUnits.weapons.ammunition.Ammunition.Charge;
import gameUnits.weapons.ammunition.Laser.Pulse;

/**
 * Lasers represent an energy projectile ammo type used by 
 * laser turrets.  Lasers strike (or miss) their target 
 * nearly instantly.
 * 
 * @author Drew Reese
 * 
 * This file contains:
 * 	+ Laser Class
 * 		+ Pulse Class
 * 			- Small
 * 			- Medium
 * 			- Large
 * 			- Capital
 * 		+ Beam Class
 * 			- Small
 * 			- Medium
 * 			- Large
 * 			- Capital
 */

/**
 * Lasers are used in Energy turrets.
 */
class Laser extends Charge {
	
    //public static var PULSE_SPEED:FlxBounds<Float> = new FlxBounds(500.0);
    //public static var BEAM_SPEED:FlxBounds<Float> = new FlxBounds(0.0);
    
    public static var RED:FlxColor = 0xff0000;      // red laser ~650nm
    public static var YELLOW:FlxColor = 0xffd500;   // yellow laser ~593nm
    public static var GREEN:FlxColor = 0x65ff00;    // green laser ~532nm
    public static var BLUE:FlxColor = 0x0028ff;     // blue laser ~445nm
    
	private function new(chargeSize:WeaponSize, damage:Float)  {
		super(chargeSize, damage);
	}
	
}

/**
 * Pulse lasers
 * Faster tracking, shorter range, higher rate of fire, less damage per shot
 */
class Pulse extends Laser {
    public static var SPEED:FlxBounds<Float> = new FlxBounds(500.0);
	
	private function new(chargeSize:WeaponSize, damage:Float, ?dual:Bool = false) {
		super(chargeSize, damage);
        if (dual) {
            loadGraphic(AssetPaths.pulse_laser_dual__png, false);
        } else {
            loadGraphic(AssetPaths.pulse_laser__png, false);
        }
        this.alpha = 0.75;
	}
}

class Pulse_Small extends Pulse {
    public static var LIFESPAN:FlxBounds<Float> = new FlxBounds(0.3);
    
    public function new(?damage:Float = 50.0, ?dual:Bool = false) {
        super(SMALL, damage, dual);
        if (dual) {
            this.setGraphicSize(16, 3);
        } else {
            this.setGraphicSize(16, 1);
        }
        this.updateHitbox();
        this.color = Laser.RED;
    }
}

class Pulse_Medium extends Pulse {
    public static var LIFESPAN:FlxBounds<Float> = new FlxBounds(0.4);
    
    public function new(?damage:Float = 75.0, ?dual:Bool = false) {
        super(MEDIUM, damage, dual);
        if (dual) {
            this.setGraphicSize(24, 5);
        } else {
            this.setGraphicSize(24, 3);
        }
        this.updateHitbox();
        this.color = Laser.YELLOW;
    }
}

class Pulse_Large extends Pulse {
    public static var LIFESPAN:FlxBounds<Float> = new FlxBounds(0.5);
    
    public function new(?damage:Float = 100.0, ?dual:Bool = false) {
        super(LARGE, damage, dual);
        if (dual) {
            this.setGraphicSize(32, 6);
        } else {
            this.setGraphicSize(32, 4);
        }
        this.updateHitbox();
        this.color = Laser.GREEN;
    }
}

class Pulse_Capital extends Pulse {
    public static var LIFESPAN:FlxBounds<Float> = new FlxBounds(0.6);
    
    public function new(?damage:Float = 125.0, ?dual:Bool = false) {
        super(CAPITAL, damage, dual);
        if (dual) {
            this.setGraphicSize(40, 7);
        } else {
            this.setGraphicSize(40, 5);
        }
        this.updateHitbox();
        this.color = Laser.BLUE;
    }
}

/**
 * Beam lasers
 * Slower tracking, longer range, lower rate of fire, more damage per shot
 */
class Beam extends Laser {
	
	public static var SPEED:FlxBounds<Float> = new FlxBounds(10.0);
	public static var LIFESPAN:FlxBounds<Float> = new FlxBounds(1.0);
	
	//private var _source:I_Combatant;
	//private var _source:FlxSprite;
    
	private function new(chargeSize:WeaponSize, damage:Float, ?dual:Bool = false) {
		super(chargeSize, damage);
		
		if (dual) {
            loadGraphic(AssetPaths.pulse_laser_dual__png, false);
        } else {
            loadGraphic(AssetPaths.pulse_laser__png, false);
        }
		
        //this._source = source;
		
        //this._source = cast(source, FlxSprite);
	}
	
	//override public function update(elapsed:Float):Void {
        //
        //if (target != null && target.exists && this.overlaps(target)) {
            //target.hurt(_damage);
        //}
        //
		//adjustBeam();
		//
        ////var srcSprt = cast(source, FlxSprite);
        ////
        ////if (srcSprt == null || !srcSprt.exists || this.lifespan <= 0.0) {
            ////this.kill();
        ////}
        //
        //super.update(elapsed);
    //}
	
	//private function adjustBeam():Void {
		//var p1 = cast(this._source, FlxSprite).getMidpoint();
		//var p2 = this.target.getMidpoint();
		////var p2 = FlxG.mouse.getPosition();
		//
		//
		//var dx = p2.x - p1.x;
        //var dy = p2.y - p1.y;
         //
        //var newAngle = FlxAngle.asDegrees(Math.atan2(dy, dx));
		//trace("source: " + p1 + ", target: " + p2 + ", angle: " + newAngle);
		//
		////this.angle = FlxAngle.asDegrees(newAngle) - 180;
		//this.angle = FlxAngle.asDegrees(newAngle);
		//
		//dx = 50 * Math.cos(newAngle);
		//dy = 50 * Math.sin(newAngle);
		//this.setPosition(p1.x, p1.y);
		//
        //p1.put();
        //p2.put();
	//}
}

/*
 * NOTE: I've tried and tried to get beam lasers to work but I'm
 * unable to get them to "look right".  I think beam lasers are 
 * a dead end at this point.  Perhaps they will work better as
 * large beacon/planetary weapons since they don't move.
 * 
 * 7/11/2017 10:08 PM Ok, just realized I should try calculating the beam's starting position in the same manner as I calculated a missile's exhaust particle position
 * 
 * 7/19/2017 10:43 PM Hmmm, still not working right.  IDK, this sucks.
 * 
 * 7/28/2017 6:02 PM Still haven't got them quite right.  I think my intuition is correct in that beam lasers may only work for stationary objects like planets and beacons.  Will pick this back up then.
 */

class Beam_small extends Beam {
    
    public function new(?damage:Float = 50.0, ?dual:Bool = false, distance:Int) {
        super(SMALL, damage, dual);
		
        //var range:Int = Math.round(source.getSensorRange());
		//var range:Int = Math.round(cast(source, FlxSprite).getMidpoint().distanceTo(target.getMidpoint()));
        
		trace("new beam: length=" + distance);
		
		if (dual) {
            this.setGraphicSize(distance, 3);
        } else {
            this.setGraphicSize(distance, 1);
        }
        this.updateHitbox();
        this.color = Laser.RED; // red laser ~650nm
        //this.lifespan = 0.3;
        //this.angle += 180;
        //FlxTween.color(this, 2.0, 0xff0000, FlxColor.TRANSPARENT, {type: FlxTween.ONESHOT, startDelay: 1.0, onComplete: function(_) {kill();} });
        
    }
    
    
}
