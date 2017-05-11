package source.gameUnits.ships;

/**
 * ...
 * @author Rory Soiffer
 */
enum ShipType
{
	FRIGATE;
	DESTROYER;
	CRUISER;
	BATTLECUISER;
	BATTLESHIP;
	FIGHTER;
	CORVETTE;
	CAPITAL;
	PATROL_CRAFT;

}

class ShipStats
{

	public static function getAttackSpeed(type: ShipType): Float
	{
		switch (type)
		{
			case FRIGATE: return 1;
			case DESTROYER: return 2;
			default: return null;
		}
	}

	public static function getCapturePower(type: ShipType): Float
	{
		return 5;
	}

	public static function getMaxHP(type: ShipType): Int
	{
		return 5;
	}

	public static function getShields(type: ShipType): Float
	{
		return 0;
	}

	public static function getSpeed(type: ShipType): Float
	{
		return 20;
	}
}

//?speed = 20.0,
//?sh = 0.5,
//?maxHP = 100.0,
//?as = 2.0,
//?ap = 10.0,
//?cps = 5.0)