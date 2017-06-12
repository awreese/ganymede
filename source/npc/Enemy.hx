package npc;

import faction.CaptureEngine;
import faction.Faction.FactionType;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import gameUnits.Ship;
import gameUnits.capturable.Capturable;
import map.MapNode;

/**
 * ...
 * @author Daisy
 */
class Enemy extends NPC
{
	// keep track of how much time has passed
	private var timer: FlxTimer;
	private var time: Int;
	
	private var rand:FlxRandom;
	
	public function new(faction:FactionType, time: Int) {
		rand = new FlxRandom();
		this.time = time;
		// timer for checking when enemy make a move
		timer = new FlxTimer();
		// set to move every x second where x is time
		if (this.time >= 0) {
            timer.start(time);
        }
		super(faction);
	}
	
	/**
	 * 
	 * @param	nodes - group of MapNodes of this.faction
	 */
	public function makeMove(nodes: FlxTypedGroup<MapNode>/*, elapsed: Float*/) {
		//timer += elapsed;
		var nodesArr: Array<MapNode> = nodes.members;
		if (nodesArr.length > 0) {
			// checks if timer is finished
			if (timer.finished) {
				// if is finished, make a move
				// find node with lowest cp ratio
				var n: MapNode = nodesArr[rand.int(0, nodesArr.length - 1)];
				var ratio: Float = 1.0;
				for (node in nodesArr) {
					var captureable = node.getCaptureable();
					if (captureable.getCP() < captureable.getTotalCP()) {
						if (captureable.getCP() / captureable.getTotalCP() < ratio) {
							ratio = captureable.getCP() / captureable.getTotalCP();
							n = node;
						}
					}
				}
				
				// check if getting captured planet is less than 70%
				n = ratio >= 0.5 ? nodesArr[rand.int(0, nodesArr.length - 1)] : n;
								
				var ships = n.getShipGroup(this.faction);
			
				// if the cp isn't that low, expand territory
				if (ratio >= 0.5 && ships.length > 0) {
					var des: MapNode = null;
					var visited: Array<MapNode> = new Array<MapNode>();
					des = findDes(n, visited, 0);
				
					for (s in ships) {
						s.pathTo(des);
					}
				
				} else if (ships.length > 0) {
					// if there's other planet
					if (nodesArr.length != 1) {
						// send the ships at n to another planet of this.faction
						var des:MapNode = nodesArr[rand.int(0, nodesArr.length - 1)];
						// find a node that's not this one
						while (des == n) {
							des = nodesArr[rand.int(0, nodesArr.length - 1)];
						}
						
						// move ships to des
						for (s in ships) {
							s.pathTo(des);
						}
					}
				}
				timer.reset(time);
			}
		}
	}
	
	// recursively go through nodes up to depth 3 to find best destination to go to
	private function findDes(node:MapNode, visited:Array<MapNode>, depth:Int) :MapNode {
		var numShip = node.getFaction() == null ? 0 : node.getShipGroup(node.getFaction()).length;
		// if hit depth 3, go back
		if (depth == 3) {
			return node;
		}
		if (node.getFaction() != null && node.getFaction() == FactionType.NOP) {
			// if this.node == nop, return it automatically
			return node;
		}
		// add node to visited
		visited.push(node);
		var des: MapNode = node;
		// go through each neighbor
		var neighbors = node.neighbors.keys();
		for (n in neighbors) {
			if (visited.indexOf(n) != -1) {
				// if already looked at n, skip
				continue;
			}
			// check node at deeper depth
			var recurseNode:MapNode = findDes(n, visited, depth + 1);
			if (recurseNode.getFaction() == null || recurseNode.getFaction() == this.faction) {
				// if the returned node doesn't have a faction, is not captureable, check next one
				// or if returned node is of this.faction, check next one
				continue;
			}
			if (recurseNode.getFaction() == FactionType.NOP) {
				return recurseNode; // enemy aim for nop planets first
			}
			if (des.getFaction() == null || des.getFaction() == this.faction) {
				// if des have no faction, set des to recurseNode
				// or if des.faction == this.faction, set des to recurseNode
				des = recurseNode;
				continue;
			}
			var numShips:Int = recurseNode.getShipGroup(recurseNode.getFaction()).length; // get num of ships
			if (numShips < des.getShipGroup(des.getFaction()).length) {
				des = recurseNode;
			}
		}
		return des;
	}
}
