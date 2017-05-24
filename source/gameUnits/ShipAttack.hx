package gameUnits;

import flixel.addons.weapon.FlxBullet;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

/**
 * This class represents one projectile fired by a ship at a given target ship.
 * @author Rory Soiffer
 * @author Drew Reese
 */
class ShipAttack extends FlxBullet
{

	public var target: Ship;    // Which ship this attack is targeting
	private var damage: Float;  // How much damage this attack deals
	private var speed: Float;   // How fast this attack travels

	public function new(damage: Float, speed: Float) {
		super();
		this.damage = damage;
		this.speed = speed;
		//loadGraphic("assets/images/temp_laser.png", false, 16, 16);
		this.makeGraphic(16, 16, FlxColor.TRANSPARENT);
	}

	override public function update(elapsed: Float) {
				
		super.update(elapsed);
		
		var width = Math.abs(target.x - this.x);
		var height = Math.abs(target.y - this.y);
		
		this.width = width;
		this.height = height;
		
		
		
		var lineStyle:LineStyle = {color: FlxColor.RED, thickness: 1.0};
		var drawStyle:DrawStyle = {smoothing:true};
		FlxSpriteUtil.drawLine(this, this.x, this.y, target.x, target.y, lineStyle, drawStyle);
		
		// Make sure that the target hasn't been destroyed already
		if (target.exists) {
		
			// Move in the direction of the target
			velocity = target.getPos().subtractNew(pointToVector(this.getPosition())).normalize().scaleNew(speed);
			//Rotate the bullet to match its velocity
			angle = pointToVector(this.velocity).degrees;
			
			// If the attack hit the target
			if (this.overlaps(target)) {
				
				// Damage the target
                target.hurt(damage);
				
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
