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
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import gameUnits.Ship;
import gameUnits.capturable.Capturable;
import gameUnits.capturable.Planet;
//import map.MapEdge.EdgeGroup;

using flixel.util.FlxSpriteUtil;

/**
 * NodeGroup is a group of MapNodes
 */
typedef NodeGroup = FlxTypedGroup<MapNode>;

//typedef EdgeMap = Map<map.MapNode, EdgeGroup>;

typedef NeighborMap = Map<MapNode, Float>;

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
	public static var NODE_RADIUS:Int = 30;

	public var gameMap:GameMap;
    
    public var neighbors:NeighborMap;
    
    //private var edgesOut:EdgeMap; // ???
	
	// Game objects at this node
	private var capturable:Capturable;
    private var factionShips:Map<FactionType, ShipGroup>;
	
    /*
     * TODO: reduce internal exposure, not everything needs to be public
     */
    
	public function new(gameMap:GameMap, x:Float, y:Float) {
		//super(x, y, NODE_SIZE, NODE_SIZE);
        super(x, y);
        
        this.width = 2 * NODE_RADIUS + 1;
        this.height = 2 * NODE_RADIUS + 1;
        
		this.gameMap = gameMap;
        
        this.neighbors = new NeighborMap();
        
        this.capturable = null;
        
        trace("node hitbox: " + this.getHitbox().toString());
        
        // create empty faction ship groups
        factionShips = new Map<FactionType, ShipGroup>();
        for (faction in Faction.getEnums()) {
            factionShips.set(faction, new ShipGroup());
        }
	}
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
    
    /*
     * Node functions
     */
    
    public function connect(node:MapNode):Bool {
        // already connected?
        if (this.isConnected(node)) {
            return false;
        }
        
        // not a neighbor yet, connect nodes on both ends
        var distance = this.getPosition().distanceTo(node.getPosition());
        this.neighbors.set(node, distance);
        node.neighbors.set(this, distance);
        return this.isConnected(node);
    }
    
    public function isConnected(node:MapNode):Bool {
        return this.neighbors.exists(node) && node.neighbors.exists(this);
    }
    
    public function clearNode():Void {
        this.neighbors = new NeighborMap();
    }
    
    public function mouseOver(p:FlxPoint):Bool {
        return this.getHitbox().containsPoint(p);
    }

	public function contains(v: FlxVector): Bool {
		//return pos.dist(v) < NODE_SIZE + 15;
		return this.getPosition().distanceTo(v) < NODE_RADIUS + 15;
	}

	public function distanceTo(n: MapNode): Float {
		//return pos.dist(n.pos);
		//return this.getPosition().distanceTo(n.getPosition());
        var distance:Float = this.neighbors.get(n);
        return distance;
	}

	public function drawTo(sprite: FlxSprite): Void {
        FlxSpriteUtil.drawCircle(sprite, this.x, this.y, NODE_RADIUS, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});
		
        for (n in neighbors.keys()) {
            var e = new MapEdge(this, n);
			FlxSpriteUtil.drawLine(sprite, e.interpDist(NODE_RADIUS).x, e.interpDist(NODE_RADIUS).y, e.interpDist(e.length() - NODE_RADIUS).x,
			e.interpDist(e.length() - NODE_RADIUS).y, {color: FlxColor.WHITE});
		}
	}

	public function pathTo(n: MapNode): Array<MapEdge> {
        // Dijkstra's algorithm
		var dists: Map<MapNode, Float> = [this => 0];
		var parents: Map<MapNode, MapNode> = [this => this];
		//var toCheck: Array<MapNode> = gameMap.nodes.copy();
		//var toCheck: Array<MapNode> = gameMap.nodes.members.copy();
		var toCheck: Array<MapNode> = gameMap.getNodeList();

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
			for (e in minEl.neighbors.keys()) {
				var newDist: Float = dists.get(minEl) + minEl.distanceTo(e);
				if (!dists.exists(e) || newDist < dists.get(e)) {
					dists.set(e, newDist);
					parents.set(e, minEl);
				}
			}
		}

        // TODO: convert this to real path object
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
	public function setCapturable(capturable:Capturable):Bool {
		if (capturable != null) {
			this.capturable = capturable;
            return true;
		}
        return false;
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
	
    // Capturable helpers
    
    /**
     * Returns true if capturable object exists on this node, false otherwise.
     * @return true iff a capturable object exists at this node, false otherwise
     */
    public function isCapturable():Bool {
        return this.capturable != null;
    }
    
    //public function getCapturableType():Any {
        //this.capturable.ty
    //}
    
	/*
	 * return true if captureable is a planet, false otherwise
	 */
	public function isPlanet():Bool {
		//var v = Std.instance(capturable, Planet);
		return !(Std.instance(capturable, Planet) == null);
	}
	
	public function getCaptureable(): Capturable {
		return capturable;
	}
	
	public function getFaction():FactionType {
        return (this.capturable == null) ? null : this.capturable.getFaction().getFactionType();
	}
}
