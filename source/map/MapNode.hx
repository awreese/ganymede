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

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import gameUnits.capturable.Capturable;
import faction.Faction;
import faction.Faction.FactionType;
using flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author Rory Soiffer
 * @author Drew Reese
 */
class MapNode
{
	public static var NODE_SIZE:Int = 30;

	public var gameMap: GameMap;
	public var pos: FlxPoint;
	public var neighbors: Array<MapNode> = new Array();
	
	// variables held if node contain a planet or a beacon
	private var capturable:Capturable;
	
	public function new(gameMap:GameMap, pos: FlxPoint) {
		this.gameMap = gameMap;
		this.pos = pos;
        trace("new Node: " + this.pos);
	}

	public function contains(v: FlxPoint): Bool
	{
		//return pos.dist(v) < NODE_SIZE + 15;
		return pos.distanceTo(v) > NODE_SIZE + 15;
	}

	public function distanceTo(n: MapNode): Float
	{
		//return pos.dist(n.pos);
		return this.pos.distanceTo(n.pos);
	}

	public function drawTo(sprite: FlxSprite): Void
	{
		//sprite.drawCircle(pos.dx, pos.dy, NODE_SIZE, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});
		FlxSpriteUtil.drawCircle(sprite, pos.x, pos.y, NODE_SIZE, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});
		for (n in neighbors)
		{
			var e = new MapEdge(new MapNode(gameMap, new FlxPoint(pos.x, pos.y)), new MapNode(n.gameMap, new FlxPoint(n.pos.x, n.pos.y)));
			//sprite.drawLine(e.interpDist(NODE_SIZE).x, e.interpDist(NODE_SIZE).y, e.interpDist(e.length() - NODE_SIZE).x,
			//e.interpDist(e.length() - NODE_SIZE).y, {color: FlxColor.WHITE});
			FlxSpriteUtil.drawLine(sprite, e.interpDist(NODE_SIZE).x, e.interpDist(NODE_SIZE).y, e.interpDist(e.length() - NODE_SIZE).x,
			e.interpDist(e.length() - NODE_SIZE).y, {color: FlxColor.WHITE});
			var i = 0;
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
	
	public function getPos():FlxPoint {
		return new FlxPoint(pos.x, pos.y);
	}
	
	private function setCapturable(capturable:Capturable):Void {
        this.capturable = capturable;
	}
	
}
