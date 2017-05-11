package gameUnits.ships;
import gameUnits.ships.Ship;

/**
 * ...
 * @author Rory Soiffer
 */
class ShipAttack extends FlxSprite
{
	
	public var target: Ship;

	public function new(target: Ship) 
	{
		this.target = target;
	}
	
}