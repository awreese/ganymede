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
    
}
