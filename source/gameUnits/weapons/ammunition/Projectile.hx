package gameUnits.weapons.ammunition;

import flixel.addons.weapon.FlxBullet;

/**
 * Represents projectile ammo type (think actual bullets).
 * @author Drew Reese
 */
class Projectile extends Ammunition {

    private function new(damage:Float) {
        super(damage);
        this.maxVelocity.set(350.0, 450.0);
        this.accelerates = false;
    }
    
}
