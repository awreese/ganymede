package gameUnits.weapons;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import gameUnits.Ship;

/**
 * ...
 * @author Drew Reese
 */
class Laser extends FlxBullet  {
	
	private var target:Ship;
	private var damage:Float;

	private function new(damage:Float)  {
		super();
		//loadGraphic("assets/images/temp_laser.png", false, 16, 16);
		this.damage = damage;
		
	}
	
	override public function update(elapsed:Float):Void {
		// Handles lifespan and boundary checking
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

/**
 * Pulse lasers
 * Faster tracking, shorter range, higher rate of fire, less damage per shot
 */
class Pulse extends Laser {
	
	public function new(damage:Float) {
		super(damage);
		loadGraphic("assets/images/temp_laser.png", false, 16, 16);
		this.lifespan = 0.5;
		this.maxVelocity.set(500.0, 500.0); // in pixels/second
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
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
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		//this.setGraphicSize(64, 16);
		FlxSpriteUtil.drawLine(
	}
}

class LaserTurret extends FlxTypedWeapon<Laser> {
	
	public function new(name:String, missileFactory:FlxTypedWeapon<Laser>->Laser, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(name, missileFactory, fireFrom, speedMode);
		
		this.rotateBulletTowardsTarget = true;
	}
}