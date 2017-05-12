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

import faction.Faction;
import faction.Faction.FactionType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import gameUnits.Ship.BluePrint;
import gameUnits.Ship.HullType;
import gameUnits.capturable.Capturable;
import gameUnits.capturable.Planet;
import map.MapNode.NodeGroup;

using flixel.util.FlxSpriteUtil;

/**
 * Game Map
 * 
 * Stores game maps and acts as the baseline bus of communication 
 * accross the graph that represents the game map.  Game objects 
 * communicate requests/queries to their underlying nodes and nodes
 * query the game map for global data, or other nodes such as the 
 * case of finding paths.
 * 
 * @author Rory Soiffer
 * @author Drew Reese
 */
class GameMap extends FlxSprite {

	// list of nodes in current game map
	//public var nodes:MapNodeList = [];
	public var nodes:NodeGroup;
    
    private var selected:MapNode = null;
	
    private var numPlanets:Int;
	
    private var factionShipCount:Map<FactionType, Int>; // Global ship count
	private var factionControlledNodes:Map<FactionType, NodeGroup>;

	public function new(playState:PlayState, level: Int) {
		super();
        
		this.nodes = new NodeGroup();
		this.numPlanets = 0;
        
        this.factionShipCount = new Map<FactionType, Int>();
		this.factionControlledNodes = new Map<FactionType, NodeGroup>();
		
        // initialize global faction data
        for (faction in Faction.getEnums()) {
            this.factionShipCount.set(faction, 0);
			this.factionControlledNodes.set(faction, new NodeGroup());
        }
		
        // Log level start and time
        Main.LOGGER.logLevelStart(level, Date.now());
        
        // Load the nodes
		switch (level) {
			case 1:
				levelOne(playState);
			case 2:
				levelTwo(playState);
			default:
				levelThree(playState);
		}
		drawNodes();
		for (n in nodes) {
			var captureable = n.getCaptureable();
			if (captureable != null) {
				factionControlledNodes.get(captureable.getFaction().getFactionType()).add(n);
			}
		}
	}

	public function findNode(v: FlxVector):MapNode {
		//return nodes.filter(function(n) return n.contains(v))[0];
		for (node in nodes) {
			if (node.contains(v)) {
				return node;
			}
		}
		return null;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
    
    /*
     * private graph functions
     * 
     * These are convenience methods to help in designing levels.
     */
    
     /**
      * Adds new node to this graph.
      * @param node new node to add
      * @return true iff graph was modified, false otherwise
      */
    private function addNode(node:MapNode):Bool {
        // TODO: Fill this in
		var added = this.nodes.add(node);
        return added == node;
    }
    
    /**
     * Connects two specified nodes by adding an edge between them.
     * @param node1 one vertex of edge
     * @param node2 the other vertex of edge
     * @return true iff graph was modified, false otherwise
     */
    private function connect(node1:MapNode, node2:MapNode):Bool {
        // TODO: Fill this in
		//var connected = node1.
        return false;
    }
    
    /**
     * Adds specified capturable object to the specified node.
     * @param node  node to add capturable to
     * @param capturable    capturable to add
     * @return true iff node was modified, false otherwise
     */
    private function addCapturable(node:MapNode, capturable:Capturable):Bool {
        // TODO: Fill this in
        return false;
    }
     
    /*
     * public Game Map functions
     * 
     * These allow for global ship production limit enforcement or
     * other general queries made via MapNode game object reside on.
     */
    
     /**
      * Returns the total count of ships on the map.
      * @return total count of ships on the map
      */
    public function getGlobalShipCount():Int {
        var totalCount = 0;
        for (shipCount in this.factionShipCount) {
            totalCount += shipCount;
        }
        return totalCount;
    }
    
    /**
     * Returns the total count of ships on the map for the specified faction.
     * @param faction   faction to return ship count of
     * @return  total ship count for specified faction
     */
    public function getShipCount(faction:FactionType):Int {
        return this.factionShipCount.get(faction);
    }
    
    /**
     * Increments the ship count of the specified faction by 1, returns new 
     * faction ship count.
     * @param faction   faction to increment ship count of
     * @return  new ship count for faction
     */
    public function incrementShipCount(faction:FactionType):Int {
        this.factionShipCount[faction]++;
        return this.getShipCount(faction);
    }
    
    /**
     * Decrements the ship count of the specified faction by 1, returns new 
     * faction ship count.
     * @param faction   faction to deccrement ship count of
     * @return  new ship count for faction
     */
    public function decrementShipCount(faction:FactionType):Int {
        this.factionShipCount[faction]--;
        return this.getShipCount(faction);
    }
	
	/**
	 * Returns a reference to NodeGoup of the game map controlled by the specified
	 * faction.  Any modifications made to the game map will be reflected in the 
	 * NodeGroup, and vice-versa.  Use extreme caution.
	 * @param	faction	faction to return NodeGroup for
	 * @return NodeGroup of specified faction
	 */
	public function getControlledNodes(faction:FactionType):NodeGroup {
		return this.factionControlledNodes.get(faction);
	}
	
	public function updateControllingFaction(node:MapNode, faction:FactionType):Void {
		var captureable = node.getCaptureable();
		if (captureable != null) {
			var oldFaction = captureable.getFaction().getFactionType();
			this.factionControlledNodes.get(oldFaction).remove(node, true);
			this.factionControlledNodes.get(faction).add(node);
		}
	}
	
	private function drawNodes():Void {
		// Loads an empty sprite for the map background
		loadGraphic("assets/images/mapbg.png", false, 400, 320);

		// Draw the nodes to the background
		for (n in nodes)
		{
			n.drawTo(this);
		}
	}
	
	// level 1
	private function levelOne(playState:PlayState):Void {
		// create nodes
		var n1 = new MapNode(this, 100, 150);
		var n2 = new MapNode(this, 300, 150);
		
		// create edges
		n1.neighbors.push(n2);
		n2.neighbors.push(n1);
		
		// draw the nodes
		//nodes = [n1, n2];
		nodes.add(n1);
		nodes.add(n2);
		//drawNodes();
		
		// set captureable
		var n1P = new Planet(playState, n1, new Faction(FactionType.PLAYER), new PlanetStat(new BluePrint(HullType.FRIGATE)));
		var n2P = new Planet(playState, n2, new Faction(FactionType.NOP), new PlanetStat(new BluePrint(HullType.FRIGATE)));

		n1.setCapturable(n1P);
		n2.setCapturable(n2P);
		FlxG.state.add(n1P);
		FlxG.state.add(n2P);
		numPlanets = 2;
	}
	
	// level 2
	private function levelTwo(playState:PlayState):Void {
		// make nodes
		var n1 = new MapNode(this, 50, 150);
		var n2 = new MapNode(this, 200, 150);
		var n3 = new MapNode(this, 350, 150);
		
		// make edges
		n1.neighbors.push(n2);
		n2.neighbors.push(n1);
		n2.neighbors.push(n3);
		n3.neighbors.push(n2);
		//nodes = [n1, n2, n3];
		nodes.add(n1);
		nodes.add(n2);
		nodes.add(n3);
		
		// set captureable
		var n1P = new Planet(playState, n1, new Faction(FactionType.PLAYER), new PlanetStat(new BluePrint(HullType.FRIGATE, 30.0), 10, 3.0));
		var n2P = new Planet(playState, n2, new Faction(FactionType.NOP), new PlanetStat(new BluePrint(HullType.FRIGATE)));

		var n3P = new Planet(playState, n3, new Faction(FactionType.ENEMY_1),
					new PlanetStat(new BluePrint(HullType.FRIGATE, 15.0, 0.3, 100.0, 1.0, 7.0)));
		
		n1.setCapturable(n1P);
		n2.setCapturable(n2P);
		n3.setCapturable(n3P);
		FlxG.state.add(n1P);
		FlxG.state.add(n2P);
		FlxG.state.add(n3P);
		numPlanets = 3;
	}
	
	// level 3
	public function levelThree(playState:PlayState):Void {
		// make nodes
		var n1 =  new MapNode(this, 50, 50);
		var n2 = new MapNode(this, 100, 200);
		var n3 = new MapNode(this, 300, 70);
		var n4 = new MapNode(this, 270, 250);

		// make edges
		n1.neighbors.push(n2);
		n2.neighbors.push(n1);

		n2.neighbors.push(n3);
		n3.neighbors.push(n2);
		n2.neighbors.push(n4);
		n4.neighbors.push(n2);

		n3.neighbors.push(n4);
		n4.neighbors.push(n3);

		//nodes = [n1, n2, n3, n4];
		nodes.add(n1);
		nodes.add(n2);
		nodes.add(n3);
		nodes.add(n4);
				
		// set captureable
		var n1P = new Planet(playState, n1, new Faction(FactionType.PLAYER), new PlanetStat(new BluePrint(HullType.FRIGATE, 30.0), 10, 3.0));
		var n3P = new Planet(playState, n3, new Faction(FactionType.NOP), new PlanetStat(new BluePrint(HullType.FRIGATE)));

		var n4P = new Planet(playState, n4, new Faction(FactionType.ENEMY_1),
					new PlanetStat(new BluePrint(HullType.FRIGATE, 20.0, 0.3, 100.0, 1.0, 8.0)));
		n1.setCapturable(n1P);
		n3.setCapturable(n3P);
		n4.setCapturable(n4P);
		FlxG.state.add(n1P);
		FlxG.state.add(n3P);
		FlxG.state.add(n4P);
		numPlanets = 3;
	}
	
	/*
	 * return the amount of player planet in the map
	 */
	public function getNumPlayerPlanets():Int {
		var numPlayerPlanets = 0;
		for (n in nodes) {
			if (n.containPlanet()) {
				var c = cast(n.getCaptureable(), Planet);
				if (c.getFaction().getFaction() == FactionType.PLAYER) {
					numPlayerPlanets++;
				}
			}
		}
		return numPlayerPlanets;
	}
	
	/*
	 * return number of planets on map
	 */
	public function getNumPlanets():Int {
		return numPlanets;
	}
}

