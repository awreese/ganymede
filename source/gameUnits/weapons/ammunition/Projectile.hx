package gameUnits.weapons.ammunition;

import flixel.addons.weapon.FlxBullet;

/**
 * Represents projectile ammo type (think actual bullets).
 * @author Drew Reese
 */
//class Projectile extends FlxBullet {
class Projectile extends Ammunition {

    //public var target:Ship;
    //private var damage:Float;
    
    private function new(damage:Float) {
        //super();
        super(damage);
		
        //this.damage = damage;
        this.maxVelocity.set(350.0, 450.0);
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
