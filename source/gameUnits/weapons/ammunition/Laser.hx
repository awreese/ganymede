package gameUnits.weapons.ammunition;

import flixel.addons.weapon.FlxBullet;
import gameUnits.Ship;

/**
 * Represents laser projectile ammo type.
 * @author Drew Reese
 */
//class Laser extends FlxBullet  {
class Laser extends Ammunition  {
	
	//public var target:Ship;
	//private var damage:Float;

	private function new(damage:Float)  {
		//super();
		super(damage);
		//loadGraphic("assets/images/temp_laser.png", false, 16, 16);
		//this.damage = damage;
		this.maxVelocity.set(500.0, 500.0);
        this.accelerates = false;
	}
	
	override public function update(elapsed:Float):Void {
		// Handles lifespan and boundary checking
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
		//FlxSpriteUtil.drawLine(
	}
}
