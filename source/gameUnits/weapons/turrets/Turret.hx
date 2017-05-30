package gameUnits.weapons.turrets;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import flixel.util.helpers.FlxBounds;
import gameUnits.weapons.ammunition.Ammunition;
import gameUnits.weapons.ammunition.Laser;

/**
 * ...
 * @author Drew Reese
 */
//class Turret extends FlxTypedWeapon<FlxBullet> {
class Turret extends FlxTypedWeapon<Ammunition> {

    private function new(name:String, bulletFactory:FlxTypedWeapon<Ammunition>->Ammunition, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
        super(name, bulletFactory, fireFrom, speedMode);
		
        this.rotateBulletTowardsTarget = true;
        this.bounds.set(0, 0, FlxG.width, FlxG.height);
    }
    
}

//class Energy extends Turret {
//class Energy extends FlxTypedWeapon<Laser> {
class Energy extends Turret {
	
	private function new(name:String, ammoFactory:FlxTypedWeapon<Ammunition>->Ammunition, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(name, ammoFactory, fireFrom, speedMode);
		
        this.rotateBulletTowardsTarget = true;
        this.bounds.set(0, 0, FlxG.width, FlxG.height);
	}
}

class GatlingPulseLaser extends Energy {
    
    public function new(parent:FlxSprite) {
        super("Gatling Pulse Laser I", 
            function(d) {
                var pulse = new Pulse(10.0);
                //return new Pulse(10.0);
                //var trail:FlxTrail = new FlxTrail(pulse, 10, 0, 0.5, 0.05);
                //FlxG.state.add(trail);
                return pulse;
            }, 
            FlxWeaponFireFrom.PARENT(parent, new FlxBounds(parent.origin, parent.origin)), 
            FlxWeaponSpeedMode.SPEED(new FlxBounds(Pulse.PULSE_SPEED, Pulse.PULSE_SPEED))
        );
        this.bulletLifeSpan = new FlxBounds(0.05, 0.05);
		this.fireRate = 1000;
        
        FlxG.state.add(this.group);
    }
}

//class Hybrid extends FlxTypedWeapon<HybridAmmo> {
	//
	//public function new(name:String, ammoFactory:FlxTypedWeapon<HybridAmmo>->HybridAmmo, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		//super(name, ammoFactory, fireFrom, speedMode);
		//
	//}
//}

//class Projectile extends FlxTypedWeapon<ProjectileAmmo> {
	//
	//public function new(name:String, ammoFactory:FlxTypedWeapon<ProjectileAmmo>->ProjectileAmmo, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		//super(name, ammoFactory, fireFrom, speedMode);
		//
	//}
//}
