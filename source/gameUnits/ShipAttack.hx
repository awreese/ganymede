package gameUnits;

import flixel.addons.weapon.FlxBullet;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

/**
 * This class represents one projectile fired by a ship at a given target ship.
 * @author Rory Soiffer
 */
class ShipAttack extends FlxBullet
{

	public var target: Ship; // Which ship this attack is targeting
	private var damage: Float; // How much damage this attack deals
	private var speed: Float; // How fast this attack travels

	public function new(damage: Float, speed: Float) {
		super();
		this.damage = damage;
		this.speed = speed;
		loadGraphic("assets/images/temp_laser.png", false, 16, 16);
	}

	override public function update(elapsed: Float) {
				
		super.update(elapsed);
		
		// Make sure that the target hasn't been destroyed already
		if (target.exists) {
		
			// Move in the direction of the target
			velocity = target.getPos().subtractNew(pointToVector(this.getPosition())).normalize().scaleNew(speed);
			//Rotate the bullet to match its velocity
			angle = pointToVector(this.velocity).degrees;
			
			// If the attack hit the target
			if (this.getPosition().distanceTo(target.getPos()) < Math.max(target.width, target.height)/2) {
				
				// Damage the target
				target.stats.hitPoints -= damage * target.stats.shield;
				
				// If needed, destroy the target
				if (target.stats.hitPoints <= 0) {
					target.destroy();
				}
				
				// Destroy the bullet
				this.kill();
			}
		} else {
			//Rotate the bullet to match its velocity
			angle = pointToVector(this.velocity).degrees;
		}
	}
	
	// A quick helper method that converts a FlxPoint into an FlxVector
	private static inline function pointToVector(point: FlxPoint): FlxVector {
		return new FlxVector(point.x, point.y);
	}
}
