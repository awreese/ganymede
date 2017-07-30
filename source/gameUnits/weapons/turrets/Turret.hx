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

package gameUnits.weapons.turrets;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.helpers.FlxBounds;
import gameUnits.combat.I_Combatant;
import gameUnits.weapons.I_Weapon;
import gameUnits.weapons.WeaponSize;
import gameUnits.weapons.ammunition.Ammunition.Charge;
import gameUnits.weapons.ammunition.Laser;
import gameUnits.weapons.ammunition.Projectile;
import gameUnits.weapons.ammunition.Projectile.Projectile_Small;

/**
 * This class represents the in-game turrets.
 * 
 * Basic turret classes are (high damage low range/low damage high range): 
 * Energy (Pulse/Beam Laser)
 * Projectile (Autocannon/Artillery)
 * Hybrid (Blasters/Railguns)
 * 
 * @author Drew Reese
 */
class Turret extends FlxTypedWeapon<Charge> implements I_Weapon {
    
    private var source:I_Combatant;
	private var size(get, null):WeaponSize;

    /**
     * Constructs new turret.
     * @param source    source object for this turret
     * @param name  name of this turret
     * @param chargeFactory factory that produces charges for this turret
     * @param fireFrom  location to spawn charges
     * @param speedMode speed of charges
     */
    private function new(source:FlxSprite, name:String, chargeFactory:FlxTypedWeapon<Charge>->Charge, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
        super(name, chargeFactory, fireFrom, speedMode);
		
        this.rotateBulletTowardsTarget = true;
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
     * Fires charge at selected target.
     */
    public function fire():Void {
        var target = source.selectTarget();
        if (target != null && fireAtTarget(cast(target, FlxSprite))) {
            currentBullet.target = cast(target, FlxSprite);
        }
    }
    
}

/**
 * Energy Turrets - Pulse & Beam Lasers
 */
class Energy extends Turret {
	
	private function new(source:FlxSprite, name:String, ammoFactory:FlxTypedWeapon<Charge>->Charge, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(source, name, ammoFactory, fireFrom, speedMode);
		
		var laser_snd:FlxSound;
		#if flash
			laser_snd = FlxG.sound.load(AssetPaths.laser_fire__mp3);
		#else
			laser_snd = FlxG.sound.load(AssetPaths.laser_fire__ogg);
		#end
		laser_snd.looped = false;
		this.onPreFireSound = laser_snd;
	}
}

class GatlingPulseLaser extends Energy {
    
    public function new(source:FlxSprite) {
        super(source, "Gatling Pulse Laser I", 
            function(d) {
                var pulse = new Pulse_Small(true);
                return pulse;
            }, 
            FlxWeaponFireFrom.PARENT(source, new FlxBounds(source.origin), false), 
            FlxWeaponSpeedMode.SPEED(Pulse.SPEED)
        );
        this.bulletLifeSpan = Pulse_Small.LIFESPAN;
		this.fireRate = 500;
        this.size = WeaponSize.SMALL;
    }
}

class BeamLaser extends Energy {
	
	private var distance:Int;
	
	private function new(source:FlxSprite, name:String, ammoFactory:FlxTypedWeapon<Charge>->Charge, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(source, name, ammoFactory, fireFrom, speedMode);
	}
	
	override public function fire():Void {
		var target = source.selectTarget();
		this.distance = 0;
        if (target != null) {
			this.distance = this.getDistance(cast(source, FlxSprite), cast(target, FlxSprite));
			
			if (fireAtTarget(cast(target, FlxSprite))) {
				currentBullet.target = cast(target, FlxSprite);
			}
        }
	}
	
	private function getDistance(source:FlxSprite, target:FlxSprite):Int {
		
		var p1 = source.getMidpoint();
		var p2 = target.getMidpoint();
		var distance = Math.round(p1.distanceTo(p2));
		p1.put();
        p2.put();
		return distance;
	}
}

class SmallFocusedBeamLaser extends Energy {
    
    public function new(source:FlxSprite) {
        super(source, "Small Focused Beam Laser I",
            function(d) {
                //var beam = new Beam_small(false, distance);
                var beam = new Beam_small(false, 100);
                return beam;
            },
            FlxWeaponFireFrom.PARENT(source, new FlxBounds(source.origin), false),
            FlxWeaponSpeedMode.SPEED(Beam.SPEED)
        );
        //this.bulletLifeSpan = new FlxBounds(1.0);
        this.bulletLifeSpan = Beam.LIFESPAN;
        this.fireRate = 5000;
        this.size = WeaponSize.SMALL;
    }
}

typedef Intercept = {
	var x: Int;
	var y: Int;
}

class ProjectileTurret extends Turret {
	
	private function new(source:FlxSprite, name:String, ammoFactory:FlxTypedWeapon<Charge>->Charge, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(source, name, ammoFactory, fireFrom, speedMode);
		
		var projectile_snd:FlxSound;
		#if flash
			projectile_snd = FlxG.sound.load(AssetPaths.projectile_fire__mp3);
		#else
			projectile_snd = FlxG.sound.load(AssetPaths.projectile_fire__ogg);
		#end
		projectile_snd.looped = false;
		this.onPreFireSound = projectile_snd;
	}
	
	override public function fire():Void {
		var target = source.selectTarget();
		
		if (target != null) {
			var targetShip = cast(target, Ship);
			
			// calculate target intercept point
			var speed = (Projectile.SPEED.max + Projectile.SPEED.min) * 0.5;
			var intercept:Intercept = getIntercept(targetShip.getMidpoint(), targetShip.vel, this.parent.getMidpoint(), speed);
			
			
			// fire at intercept point
			if (intercept != null && fireAtPosition(intercept.x, intercept.y)) {
				currentBullet.target = cast(target, FlxSprite);
			}
		}
		
	}
	
	
	//private static function getIntercept(dst:FlxSprite, src:FlxSprite, v:Float): Intercept {
	/**
	 * Calculates the intercept point of a moving target a projectile
	 * should be aimed at.  Based on code from: 
	 * https://stackoverflow.com/questions/2248876/2d-game-fire-at-a-moving-target-by-predicting-intersection-of-projectile-and-u
	 * 
	 * @param	dst position of target
	 * @param	dstVel velocity of target
	 * @param	src position of projectile
	 * @param	projSpeed projectile speed
	 * @return	intercept point
	 */
	private static function getIntercept(dst:FlxPoint, dstVel:FlxPoint, src:FlxPoint, projSpeed:Float): Intercept {
		
		//if (!dst.exists) { return null; }
		//var dstMP = dst.getMidpoint();
		//var srcMP = src.getMidpoint();
		//
		//var tx = dstMP.x - srcMP.x;
		//var ty = dstMP.y - srcMP.y;
		var tx = dst.x - src.x;
		var ty = dst.y - src.y;
		//
		//if (!dst.exists) { return null; }
		//var dstVel = dst.velocity;
		//
		//var tvx = dstVel.x;
		//var tvy = dstVel.y;
		var tvx = dstVel.x;
		var tvy = dstVel.y;
		
		// set quadratic parameters and solve
		var a = tvx * tvx + tvy * tvy - projSpeed * projSpeed;
		var b = 2 * (tx * tvx + ty * tvy);
		var c = tx * tx + ty * ty;
		var solution = solveQuadratic(a, b, c);
		
		var intercept:Intercept = null;
		if (solution != null) {
			var t = getSmallestPositiveTvalue(solution[0], solution[1]);
			if (t != null) {
				intercept = {
					x: Std.int(dst.x + t * tvx),
					y: Std.int(dst.y + t * tvy)
				}
			}
		}
		
		return intercept;
	}
	
	private static function solveQuadratic(a:Float, b:Float, c:Float):Array<Float> {
		var result = null;
		
		var radicand:Float = b * b - 4 * a * c;
		
		if (radicand < 0.0) {
			// no solution
			
		} else {
			// single solution (i.e. t1 == t2)
			// or 
			// dual solution
			result = [( -b + Math.sqrt(radicand)) / (2 * a), ( -b - Math.sqrt(radicand)) / (2 * a)];
		}
		
		return result;
	}
	
	private static function getSmallestPositiveTvalue(t0:Float, t1:Float):Float {
		var t = Math.min(t0, t1);
		if (t < 0.0) {
			t = Math.max(t0, t1);    
		}
		if (t >= 0.0) {
		  return t;
		}
		return null;
	}
}

class SmallAutoCannon extends ProjectileTurret {
	public function new (source:FlxSprite) {
		super(source, "Small Auto Cannon I.",
			function(d) {
				var projectile = new Projectile_Small();
				return projectile;
			}, 
			FlxWeaponFireFrom.PARENT(source, new FlxBounds(source.origin), false),
			FlxWeaponSpeedMode.SPEED(Projectile.SPEED)
		);
		//this.bulletLifeSpan = new FlxBounds(1.0);
        this.fireRate = 5000;
        this.size = WeaponSize.SMALL;
	}
}

//class Hybrid extends FlxTypedWeapon<HybridAmmo> {
	//
	//public function new(name:String, ammoFactory:FlxTypedWeapon<HybridAmmo>->HybridAmmo, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		//super(name, ammoFactory, fireFrom, speedMode);
		//
	//}
//}
