package map;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import math.Vec;
using flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author Rory Soiffer
 */
class MapNode
{
	public static var NODE_SIZE:Int = 30;

	public var gameMap: GameMap;
	public var pos: Vec;
	public var neighbors: Array<MapNode> = new Array();

	public function new(gameMap:GameMap, pos: Vec)
	{
		this.gameMap = gameMap;
		this.pos = pos;
	}

	public function contains(v: Vec): Bool
	{
		return pos.subtract(v).length() < NODE_SIZE;
	}

	public function distanceTo(n: MapNode): Float
	{
		return pos.subtract(n.pos).length();
	}

	public function drawTo(sprite: FlxSprite): Void
	{
		sprite.drawCircle(pos.x, pos.y, NODE_SIZE, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});
		for (n in neighbors)
		{
			var e = new MapEdge(this, n);
			sprite.drawLine(e.interpDist(NODE_SIZE).x, e.interpDist(NODE_SIZE).y, e.interpDist(e.length() - NODE_SIZE).x,
			e.interpDist(e.length() - NODE_SIZE).y, {color: FlxColor.WHITE});
		}
	}

	public function pathTo(n: MapNode): Array<MapEdge>
	{
		// Dijkstra's algorithm
		var dists: Map<MapNode, Float> = [this => 0];
		var parents: Map<MapNode, MapNode> = [this => this];
		var toCheck: Array<MapNode> = gameMap.nodes.copy();

		while (toCheck.length > 0)
		{
			var minEl: MapNode = toCheck[0];

			for (e in toCheck)
			{
				if (!dists.exists(minEl) || (dists.exists(e) && dists.get(e) < dists.get(minEl)))
				{
					minEl = e;
				}
			}
			if (minEl == n)
			{
				break;
			}
			toCheck.remove(minEl);
			for (e in minEl.neighbors)
			{
				var newDist: Float = dists.get(minEl) + minEl.distanceTo(e);
				if (!dists.exists(e) || newDist < dists.get(e))
				{
					dists.set(e, newDist);
					parents.set(e, minEl);
				}
			}
		}

		var path: Array<MapEdge> = new Array();
		var e: MapNode = n;
		while (e != this)
		{
			path.unshift(new MapEdge(parents.get(e), e));
			e = parents.get(e);
		}
		return path;
	}
}