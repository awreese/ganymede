package map;

import math.Vec;

/**
 * ...
 * @author Rory Soiffer
 */
class MapEdge
{

	public var n1: MapNode;
	public var n2: MapNode;

	public function new(n1: MapNode, n2: MapNode)
	{
		this.n1 = n1;
		this.n2 = n2;
	}

	public function delta(): Vec
	{
		return n2.pos.subtract(n1.pos);
	}

	public function interpDist(d: Float): Vec
	{
		return interpPerc(d / length());
	}

	public function interpPerc(i: Float): Vec
	{
		return n1.pos.add(delta().mul(i));
	}

	public function length(): Float
	{
		return n1.distanceTo(n2);
	}

	public function pathTo(n: MapNode, d: Float): Array<MapEdge>
	{
		var path1 = n1.pathTo(n);
		var d1: Float = d;
		for (e in path1)
		{
			d1 += e.length();
		}
		
		var path2 = n2.pathTo(n);
		var d2: Float = length() - d;
		for (e in path2)
		{
			d2 += e.length();
		}
		
		if (d1 > d2)
		{
			path2.unshift(this);
			return path2;
		}
		else {
			path1.unshift(new MapEdge(n2, n1));
			return path1;
		}
	}
}