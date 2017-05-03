package map;

import math.Vec;
import flixel.FlxSprite;
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
		var n1 =  new MapNode(this, new Vec(50, 50));
		var n2 = new MapNode(this, new Vec(100, 200));
		var n3 = new MapNode(this, new Vec(300, 70));
		var n4 = new MapNode(this, new Vec(270, 250));

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

	public function findNode(v: Vec): MapNode
	{
		return nodes.filter(function(n) return n.contains(v))[0];
	}

	private var selected: MapNode = null;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

