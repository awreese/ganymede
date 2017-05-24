package gameUnits.weapons;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import gameUnits.Ship;

/**
 * ...
 * @author Drew Reese
 */
class Missile extends FlxBullet  {
	
	private var target:Ship;
	private var damage:Float;
	

	private function new(damage:Float)  {
		super();
		this.accelerates = true;
		
		this.damage = damage;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		// check if target exists & track target's position
		if (target.exists) {
			
			// adjust trajectory to target
			
			// check for collision
			if (this.overlaps(target)) {
				// Do damage to target & destroy missile
				target.hurt(damage);
				this.
			}
		}
		
	}
	
}

class Launcher extends FlxTypedWeapon<Missile> {
	
	public function new(name:String, missileFactory:FlxTypedWeapon<Missile>->Missile, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(name, missileFactory, fireFrom, speedMode);
		
	}
}