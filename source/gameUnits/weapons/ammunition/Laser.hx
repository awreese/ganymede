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
import flixel.addons.weapon.FlxBullet;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;
import gameUnits.Ship;
import gameUnits.combat.I_Combatant;
import gameUnits.weapons.WeaponSize;
import gameUnits.weapons.ammunition.Ammunition.Charge;
import gameUnits.weapons.ammunition.Laser.Pulse;

/**
 * Represents laser projectile ammo type.
 * @author Drew Reese
 */
class Laser extends Charge {
	
    public static var PULSE_SPEED:FlxBounds<Float> = new FlxBounds(500.0);
    public static var BEAM_SPEED:FlxBounds<Float> = new FlxBounds(0.0);
    
    public static var RED:FlxColor = 0xff0000;      // red laser ~650nm
    public static var YELLOW:FlxColor = 0xffd500;   // yellow laser ~593nm
    public static var GREEN:FlxColor = 0x65ff00;    // green laser ~532nm
    public static var BLUE:FlxColor = 0x0028ff;     // blue laser ~445nm
    
	private function new(chargeSize:WeaponSize, damage:Float)  {
		super(chargeSize, damage);
		//this.maxVelocity.set(PULSE_SPEED, PULSE_SPEED);
	}
	
}

/**
 * Pulse lasers
 * Faster tracking, shorter range, higher rate of fire, less damage per shot
 */
class Pulse extends Laser {
    
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
        //this.color = 0xff0000; // red laser ~650nm
        this.color = Laser.RED;
        //this.lifespan = 0.3;
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
        //this.color = 0x65ff00; // green laser ~532nm
        this.color = Laser.YELLOW;
        //this.lifespan = 0.4;
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
        //this.color = 0x0028ff; // blue laser ~445nm
        this.color = Laser.GREEN;
        //this.lifespan = 0.5;
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
        //this.color = 0xffd500; // yellow laser ~593nm
        this.color = Laser.BLUE;
        //this.lifespan = 0.6;
    }
}

/**
 * Beam lasers
 * Slower tracking, longer range, lower rate of fire, more damage per shot
 */
class Beam extends Laser {
	
	private var source:I_Combatant;
    private var dual:Bool;
	
	private function new(chargeSize:WeaponSize, damage:Float, source:I_Combatant, ?dual:Bool = false) {
		super(chargeSize, damage);
        if (dual) {
            loadGraphic(AssetPaths.pulse_laser_dual__png, false);
        } else {
            loadGraphic(AssetPaths.pulse_laser__png, false);
        }
        //this.alpha = 0.75;
		this.lifespan = 1.0;
        this.source = source;
        this.dual = dual;
	}
}

/*
 * NOTE: I've tried and tried to get beam lasers to work but I'm
 * unable to get them to "look right".  I think beam lasers are 
 * a dead end at this point.  Perhaps they will work better as
 * large beacon/planetary weapons since they don't move.
 */

class Beam_small extends Beam {
    
    public function new(?damage:Float = 50.0, source:I_Combatant, ?dual:Bool = false) {
        super(SMALL, damage, source, dual);
        var range:Int = Math.round(source.getSensorRange());
        if (dual) {
            this.setGraphicSize(range, 3);
        } else {
            this.setGraphicSize(range, 1);
        }
        this.updateHitbox();
        this.color = 0xff0000; // red laser ~650nm
        //this.lifespan = 0.3;
        //this.angle += 180;
        //FlxTween.color(this, 2.0, 0xff0000, FlxColor.TRANSPARENT, {type: FlxTween.ONESHOT, startDelay: 1.0, onComplete: function(_) {kill();} });
        
    }
    
    override public function update(elapsed:Float):Void {
        
        if (target != null && target.exists && this.overlaps(target)) {
            target.hurt(_damage);
        }
        
        //var srcSprt = cast(source, FlxSprite);
        //
        //if (srcSprt == null || !srcSprt.exists || this.lifespan <= 0.0) {
            //this.kill();
        //}
        
        super.update(elapsed);
    }
}
