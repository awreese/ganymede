package map;

/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
 * 
 * This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import flixel.math.FlxVector;

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

	public function delta(): FlxVector
	{
		return n2.pos.subtractNew(n1.pos);
	}

	public function interpDist(d: Float): FlxVector
	{
		return interpPerc(d / length());
	}

	public function interpPerc(i: Float): FlxVector
	{
		return n1.pos.addNew(delta().scale(i));
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