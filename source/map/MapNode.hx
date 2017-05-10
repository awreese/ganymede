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

package map;

import Std;
import faction.Faction;
import faction.Faction.FactionType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import gameUnits.Ship;
import gameUnits.capturable.Capturable;
import gameUnits.capturable.Planet;

using flixel.util.FlxSpriteUtil;

/**
 * NodeGroup is a group of MapNodes
 */
typedef NodeGroup = FlxTypedGroup<MapNode>;

/**
 * MapNode
 * 
 * Exists as the go-between game objects the game map.  This class tracks
 * and maintains a localized (node only) field for any capturable objects
 * residing the node, and a list of ships currently present, divided by 
 * faction for easy querying.
 * 
 * @author Rory Soiffer
 * @author Drew Reese
 */
class MapNode extends FlxObject {
	public static var NODE_SIZE:Int = 30;

	public var gameMap: GameMap;
	//public var pos: FlxVector;
	public var neighbors: Array<MapNode> = new Array();
	//public var neighbors:NodeGroup;
	
	// Game objects at this node
	private var capturable:Capturable;
    private var factionShips:Map<FactionType, ShipGroup>;
	
    /*
     * TODO: remove pos position vector and replace constructor to just use the
     * baked-in object (x, y) coordinate.  This requires node extending FlxBasic (???)
     * 
     * TODO: reduce internal exposure, not everything needs to be public
     */
    
	//public function new(gameMap:GameMap, pos: FlxVector) {
	public function new(gameMap:GameMap, x:Float, y:Float) {
		super();
		
		//this.pos = pos;
		this.x = x;
		this.y = y;
		
		this.gameMap = gameMap;
		
        this.capturable = null;
        
        // create empty faction ship groups
        factionShips = new Map<FactionType, ShipGroup>();
        for (faction in Faction.getEnums()) {
            factionShips.set(faction, new ShipGroup());
        }
	}

	public function contains(v: FlxVector): Bool {
		//return pos.dist(v) < NODE_SIZE + 15;
		return this.getPosition().distanceTo(v) < NODE_SIZE + 15;
	}

	public function distanceTo(n: MapNode): Float {
		//return pos.dist(n.pos);
		return this.getPosition().distanceTo(n.getPosition());
	}

	public function drawTo(sprite: FlxSprite): Void {
		FlxSpriteUtil.drawCircle(sprite, this.x, this.y, NODE_SIZE, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});
		for (n in neighbors)
		{
			var e = new MapEdge(this, n);
			FlxSpriteUtil.drawLine(sprite, e.interpDist(NODE_SIZE).x, e.interpDist(NODE_SIZE).y, e.interpDist(e.length() - NODE_SIZE).x,
			e.interpDist(e.length() - NODE_SIZE).y, {color: FlxColor.WHITE});
		}
	}

	public function pathTo(n: MapNode): Array<MapEdge> {
		// Dijkstra's algorithm
		var dists: Map<MapNode, Float> = [this => 0];
		var parents: Map<MapNode, MapNode> = [this => this];
		//var toCheck: Array<MapNode> = gameMap.nodes.copy();
		var toCheck: Array<MapNode> = gameMap.nodes.members.copy();

		while (toCheck.length > 0) {
			var minEl: MapNode = toCheck[0];

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

		var path: Array<MapEdge> = new Array();
		var e: MapNode = n;
		while (e != this) {
			path.unshift(new MapEdge(parents.get(e), e));
			e = parents.get(e);
		}
		return path;
	}
	
	public function getPos():FlxVector {
		//return new FlxVector(pos.x, pos.y);
		return new FlxVector(x, y);
	}
	
    /**
     * Sets the capturable object at this node.
     * @param capturable    capturable object to set at this node
     */
	public function setCapturable(capturable:Capturable):Void {
		if (capturable != null) {
			this.capturable = capturable;
		}
	}
    
    /**
     * Adds specified ship to this node.
     * @param ship  ship to add to this node
     */
    public function addShip(ship:Ship):Void {
        var group:ShipGroup = this.factionShips.get(ship.getFaction());
        group.add(ship);
        this.gameMap.incrementShipCount(ship.getFaction());
    }
    
    /**
     * Removes ship from this node's list
     * @param ship  shit to remove from this node
     */
    public function removeShip(ship:Ship):Void {
        var group:ShipGroup = this.factionShips.get(ship.getFaction());
        group.remove(ship, true);
        this.gameMap.decrementShipCount(ship.getFaction());
    }
    
    /**
     * Moves the specified ship from this node to the specified node.
     * 
     * NOTE: This implementation calls addShip on the specified node then 
     * calls removeShip on this node.  This currently is not a single atomic
     * action so edge cases for race conditions exist, but are unlikely 
     * to cause issues since counts are incremented before being decremented
     * back to the actual count.
     * 
     * @param ship  ship to move to specified node
     * @param toNode    new node for ship
     */
    public function moveShip(ship:Ship, node:MapNode):Void {
        node.addShip(ship);   // increments count
        this.removeShip(ship);  // decrements count
    }
	
	/**
	 * Retuns a ShipGroup for the specified faction currently at this node.
	 * @param	faction	faction to return ShipGroup of
	 * @return	ShipGroup for specified faction currently at this node
	 */
	public function getShipGroup(faction:FactionType):ShipGroup {
		return this.factionShips.get(faction);
	}
	
	/*
	 * return true if captureable is a planet, false otherwise
	 */
	public function containPlanet():Bool {
		//var v = Std.instance(capturable, Planet);
		return !(Std.instance(capturable, Planet) == null);
	}
	
	public function getCaptureable(): Capturable {
		return capturable;
	}
	
	public function getFaction():FactionType {
		return this.capturable.getFaction().getFaction();
	}
}
