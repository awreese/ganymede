package npc;

import faction.Faction.FactionType;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import map.MapNode;
/**
 * ...
 * @author Daisy
 */
class Enemy extends NPC
{
	// keep track of how much time has passed
	private var timer: FlxTimer;
	// 
	private var time: Int;
	
	public function new(faction:FactionType, time: Int) {
		this.time = time;
		// timer for checking when enemy make a move
		timer = new FlxTimer();
		// set to move every x second where x is time
		timer.start(time);
		super(faction);
	}
	
	/**
	 * 
	 * @param	nodes - group of MapNodes of this.faction
	 */
	public function makeMove(nodes: FlxTypedGroup<MapNode>/*, elapsed: Float*/) {
		//timer += elapsed;
		if (nodes.length > 0) {
			// checks if timer is finished
			if (timer.finished) {
				// if is finished, make a move
			
				// find node with lowest cp ratio
				var n: MapNode = nodes.getRandom();
				var ratio: Float = 1.0;
				for (node in nodes) {
					var captureable = node.getCaptureable();
					if (captureable.getCP() < captureable.getTotalCP()) {
						if (captureable.getCP() / captureable.getTotalCP() < ratio) {
							ratio = captureable.getCP() / captureable.getTotalCP();
							n = node;
						}
					}
				}
			
				//n = nodes.getRandom(); // I got a compiler warning n was never initialized below, so I did it here to make it stop whining.
				var ships = n.getShipGroup(this.faction);
			
				// if the cp isn't that low, expand territory
				if (ratio >= 0.7 && ships.length > 0) {
					var des: MapNode = null;
					var queue: Array<MapNode> = new Array<MapNode>();
					var visited: Array<MapNode> = new Array<MapNode>();
					queue.push(n);
				
					// while there's still more nodes to look through
					while (queue.length > 0) {
						var currNode = queue.shift();
						visited.push(currNode);
						var captureable = currNode.getCaptureable();
						// if found nop, go there
						if (captureable != null && captureable.getFaction().getFaction() == FactionType.NOP) {
							des = currNode;
							break;
						}
						// if found a captureable whose faction != this.faction, set des to it, but look at other nodes
						// before deciding where to go
						if (captureable != null && captureable.getFaction().getFaction() != this.faction) {
							des = currNode;
						}
						if (des == null) {
							// traverse to farther if there is no destination yet
							for (neighbor in currNode.neighbors) {
								// only add to queue if haven't visited
								if (visited.indexOf(neighbor) == -1) {
									queue.push(neighbor);
								}
							}
						}
					}
				
					//var ships = n.getShips(this.faction);
					for (s in ships) {
						s.pathTo(des);
					}
				
				} else if (ships.length > 0) {
					// if there's other planet
					if (nodes.length != 1) {
						// send the ships at n to another planet of this.faction
						var des = nodes.getRandom();
						var captureable = des.getCaptureable();
						// find a node that's not this one
						while (captureable.getCP() / captureable.getTotalCP() == ratio) {
							des = nodes.getRandom();
							captureable = des.getCaptureable();
						}
				
						// move ships to des
						//var ships = n.getShips(this.faction);
						for (s in ships) {
							s.pathTo(des);
						}
					}
				}
				timer.reset(time);
			}
		}
	}
}