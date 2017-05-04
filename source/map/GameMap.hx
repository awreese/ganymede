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

import flixel.FlxSprite;
import flixel.math.FlxVector;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Rory Soiffer
 */
class GameMap extends FlxSprite
{

	public var nodes:Array<MapNode> = [];

	public function new()
	{
		super();

		// Load the nodes
		var n1 =  new MapNode(this, new FlxVector(50, 50));
		var n2 = new MapNode(this, new FlxVector(100, 200));
		var n3 = new MapNode(this, new FlxVector(300, 70));
		var n4 = new MapNode(this, new FlxVector(270, 250));


		n1.neighbors.push(n2);
		n2.neighbors.push(n1);

		n2.neighbors.push(n3);
		n3.neighbors.push(n2);

		n2.neighbors.push(n4);
		n4.neighbors.push(n2);

		n3.neighbors.push(n4);
		n4.neighbors.push(n3);

		nodes = [n1, n2, n3, n4];

		// Loads an empty sprite for the map background
		loadGraphic("assets/images/background.png", false, 400, 320);

		// Draw the nodes to the background
		for (n in nodes)
		{
			n.drawTo(this);
		}

	}

	public function findNode(v: FlxVector): MapNode
	{
		return nodes.filter(function(n) return n.contains(v))[0];
	}

	private var selected: MapNode = null;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

