package gameUnits.weapons.ammunition;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import gameUnits.Ship;

/**
 * ...
 * @author Drew Reese
 */
class Missile extends Ammunition  {
	
	//private var target:Ship;
	//private var damage:Float;
	

	private function new(damage:Float)  {
		super(damage);
		this.accelerates = true;
		
		//this.damage = damage;
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
				// maybe show explosion animation?
				this.kill();
			}
		}
		
	}
	
}
