package math;

/**
 * ...
 * @author Rory Soiffer
 */
class Vec
{

	public var x(default, null): Float;
	public var y(default, null): Float;

	public function new(x: Float, y: Float)
	{
		this.x = x;
		this.y = y;
	}

	public function add(o: Vec): Vec
	{
		return new Vec(x + o.x, y + o.y);
	}

	public function angle(): Float
	{
		return Math.atan2(y, x);
	}
	
	
	public function length(): Float
	{
		return Math.sqrt(x * x + y * y);
	}

	public function mul(d: Float): Vec
	{
		return new Vec(x * d, y * d);
	}

	public function subtract(o: Vec): Vec
	{
		return new Vec(x - o.x, y - o.y);
	}

	public function toString(): String
	{
		return "(" + x + ", " + y + ")";
	}
}