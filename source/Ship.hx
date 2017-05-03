package source;

import flixel.FlxSprite;
import map.MapNode;
import map.MapEdge;
import math.Vec;

/**
 * ...
 * @author Daisy
 */
class Ship extends FlxSprite
{

	// General stats
	public var team: Int;
	public var speed: Float = 30;

	// Completely ship-specific
	public var pos: Vec;
	public var rotation: Float;
	public var destination: MapNode;
	public var nodePath: Array<MapEdge> = [];
	public var progress: Float;
	public var isSelected: Bool;

	public function new(destination: MapNode, team: Int)
	{
		super();
		pos = destination.pos;
		this.destination = destination;
		loadGraphic("assets/images/ship_1.png", false, 32, 32);
		this.team = team;
	}

	public function idealPos(): Vec
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
			pos = idealPos();
			rotation = nodePath[0].delta().angle();
			angle = rotation * 180 / Math.PI;

			// Update the ship's movement along an edge
			progress += speed * elapsed;
			if (progress > nodePath[0].length())
			{
				progress -= nodePath[0].length();
				nodePath.shift();
			}
		}
		else {
			pos = destination.pos;

			progress = 0;
		}

		// Set the sprite's position (x,y) to match the actual position (pos)
		x = pos.x - origin.x;
		y = pos.y - origin.y;

		super.update(elapsed);
	}

}