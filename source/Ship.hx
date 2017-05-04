package;

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
import map.MapNode;
import map.MapEdge;

/**
 * 
 * @author Daisy
 * @author Rory Soiffer
 * @author Drew Reese
 */
class Ship extends FlxSprite
{
	// Parent/Faction Info
	private var homePlanet: Planet;
	private var faction: Faction;
	
	// General stats
	//private var pos: FlxVector;
	//private var velocity: Float = 30;
	public var stats: ShipStat;

	// Completely ship-specific
	//public var rotation: Float; no longer used
	public var destination: MapNode;
	public var nodePath: Array<MapEdge> = [];
	public var progress: Float;
	public var isSelected: Bool;
	
	
	/*
	 * TODO: Update constructor to take planet instead of node when created.
	 * 
	 * Planets have a map node field to use for destinations, i.e. Ships interact with planets, not
	 * the underlying graph.
	 */
	
	public function new(destination: MapNode, faction: Faction, shipStats: ShipStat)
	{
		super();
		//pos = destination.pos;
		this.destination = destination;
		this.faction = faction;
		this.stats = shipStats;
		
		loadGraphic("assets/images/ship_1.png", false, 32, 32);
		
	}

	public function idealPos(): FlxVector
	{
		return nodePath[0].interpDist(progress);
	}

	public function isMoving(): Bool
	{
		return nodePath.length >= 1;
	}

	public function pathTo(n: MapNode): Void
	{
		if (isMoving())
		{
			var e = nodePath[0];
			nodePath = nodePath[0].pathTo(n, progress);
			if (nodePath[0].n1 != e.n1)
			{
				progress = e.length() - progress;
			}
		}
		else {
			nodePath = destination.pathTo(n);
		}
		destination = n;
	}

	override public function update(elapsed:Float):Void
	{
		// check faction, draw appropriate sprite/color, etc..
		switch(this.faction) {
			case PLAYER:
				trace("Player Ship");
			case NEUTRAL:
				trace("Neutral Ship");
			default:
				trace("Enemy Ship #" + this.faction);
		}
		
		
		// Change the sprite to show when the ship is selected
		if (isSelected)
		{
			loadGraphic("assets/images/ship_1_selected.png", false, 32, 32);
		}
		else {
			loadGraphic("assets/images/ship_1.png", false, 32, 32);
		}

		// Whether the ship is currently stationed at one node or is moving between nodes
		if (isMoving())
		{
			//pos = idealPos();
			stats.pos = idealPos();
			angle = nodePath[0].delta().degrees;
			
			// Update the ship's movement along an edge
			//progress += velocity * elapsed;
			progress += stats.vel * elapsed;
			if (progress > nodePath[0].length())
			{
				progress -= nodePath[0].length();
				nodePath.shift();
			}
		}
		else {
			//pos = destination.pos;
			stats.pos = destination.pos;

			progress = 0;
		}

		// Set the sprite's position (x,y) to match the actual position (pos)
		//x = pos.x - origin.x;
		//y = pos.y - origin.y;
		
		x = stats.pos.x - origin.x;
		y = stats.pos.y - origin.y;

		super.update(elapsed);
	}

}