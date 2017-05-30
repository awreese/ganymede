package gameUnits.weapons.launchers;

import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import gameUnits.weapons.ammunition.Missile;

/**
 * ...
 * @author Drew Reese
 */
class Launcher extends FlxTypedWeapon<Missile> {

    public function new(name:String, bulletFactory:FlxTypedWeapon<Missile> -> Missile, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
        super(name, bulletFactory, fireFrom, speedMode);
		
    }
    
}
