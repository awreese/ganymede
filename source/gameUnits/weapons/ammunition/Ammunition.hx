package gameUnits.weapons.ammunition;

import flixel.addons.weapon.FlxBullet;

/**
 * Generic ammunition class.  All munitions used in-game
 * extend this class.
 * @author Drew Reese
 */
class Ammunition extends FlxBullet {

    public var target:Ship;
	private var damage:Float;
    
    private function new(damage:Float) {
        super();
		this.damage = damage;
    }
    
    override public function update(elapsed:Float):Void {
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
 * Charges are used for turrets.
 */
class Charge extends Ammunition {
    private function new(damage:Float) {
        super(damage);
        this.accelerates = false;
    }
}
