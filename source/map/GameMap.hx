package map;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Rory Soiffer
 */
class GameMap extends FlxSprite
{

	public var nodes:List<MapNode> = new List();

	public function new()
	{
		super();

		// Load the nodes
		var n1 =  new MapNode(this, 50, 50);
		var n2 = new MapNode(this, 100, 200);
		var n3 = new MapNode(this, 300, 70);
		var n4 = new MapNode(this, 270, 250);

		n1.neighbors.add(n2);
		n2.neighbors.add(n1);

		n2.neighbors.add(n3);
		n3.neighbors.add(n2);

		n2.neighbors.add(n4);
		n4.neighbors.add(n2);

		n3.neighbors.add(n4);
		n4.neighbors.add(n3);

		nodes.add(n1);
		nodes.add(n2);
		nodes.add(n3);
		nodes.add(n4);

		// Loads an empty sprite for the map background
		loadGraphic("assets/images/background.png", true, 400, 320);
 
		// Draw the nodes to the background
		for (n in nodes)
		{
			n.drawTo(this);
		}

	}
	
	private var selected: MapNode = null;

	override public function update(elapsed:Float):Void
	{
		//trace(FlxG.mouse.x);
		if (FlxG.mouse.justPressed)
		{
			for (n in nodes)
			{
				if (n.contains(FlxG.mouse.x, FlxG.mouse.y))
				{
					trace("Selected node at " + n.toString());
					selected = n;
				}
			}
		}
		if (FlxG.mouse.justPressedRight && selected != null)
		{
			for (n in nodes)
			{
				if (n.contains(FlxG.mouse.x, FlxG.mouse.y))
				{
					trace("Finding path to node at " + n.toString());
					for (e in selected.pathTo(n)) {
						trace(e.toString());
					}
				}
			}
		}

		super.update(elapsed);
	}
}

private class MapNode
{
	public static var NODE_SIZE:Int = 30;

	public var gameMap:GameMap;
	public var x:Float;
	public var y:Float;
	public var neighbors:List<MapNode> = new List();

	public function new(gameMap:GameMap, x:Float, y:Float)
	{
		this.gameMap = gameMap;
		this.x = x;
		this.y = y;
	}

	public function contains(x:Float, y:Float): Bool
	{
		return (x - this.x) * (x - this.x) + (y - this.y) * (y - this.y) < NODE_SIZE * NODE_SIZE;
	}

	public function distanceTo(n:MapNode): Float
	{
		return Math.sqrt((n.x - x) * (n.x - x) + (n.y - y) * (n.y - y));
	}

	public function drawTo(sprite:FlxSprite): Void
	{
		sprite.drawCircle(x, y, NODE_SIZE, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});
		for (n in neighbors)
		{
			var angle = Math.atan2(n.y - y, n.x - x);
			sprite.drawLine(x + NODE_SIZE * Math.cos(angle), y + NODE_SIZE * Math.sin(angle),
							n.x - NODE_SIZE * Math.cos(angle), n.y - NODE_SIZE * Math.sin(angle),
			{color: FlxColor.WHITE});
		}
	}
	
	public function pathTo(n: MapNode): List<MapNode>
	{
		var dists: Map<MapNode, Float> = [this => 0];
		var parents: Map<MapNode, MapNode> = [this => this];
		var toCheck: List<MapNode> = gameMap.nodes.map(function(x) return x);

		while (!toCheck.isEmpty()) {
			var minEl: MapNode = toCheck.first();
			
			for (e in toCheck) {
				if (!dists.exists(minEl) || (dists.exists(e) && dists.get(e) < dists.get(minEl))) {
					minEl = e;
				}
			}
			if (minEl == n) {
				break;
			}
			toCheck.remove(minEl);
			for (e in minEl.neighbors) {
				var newDist: Float = dists.get(minEl) + minEl.distanceTo(e);
				if (!dists.exists(e) || newDist < dists.get(e)) {
					dists.set(e, newDist);
					parents.set(e, minEl);
				}
			}
		}
		
		var path: List<MapNode> = new List();
		var e: MapNode = n;
		while (e != this) {
			path.push(e);
			e = parents.get(e);
		}
		return path;
	}
	
	public function toString(): String
	{
		return "(" + x + ", " + y + ")";
	}
}