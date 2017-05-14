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
import haxe.Json;
import haxe.io.Input;
import map.MapNode.NodeGroup;
import openfl.filesystem.File;

using flixel.util.FlxSpriteUtil;

typedef Id_to_Node = Map<String, MapNode>;

typedef Node_to_Neighbors = Map<MapNode, NodeGroup>;

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
	//public var nodes:NodeGroup;
    
    private var id_to_node:Id_to_Node;
    private var node_to_neighbors:Node_to_Neighbors;
    
    private var selected:MapNode = null;
	
    private var factionShipCount:Map<FactionType, Int>; // Global ship count
	private var factionControlledNodes:Map<FactionType, NodeGroup>;

	public function new(playState:PlayState, level: Int) {
		super();
        
        loadGraphic("assets/images/mapbg.png", false, 400, 320);
        
		//this.nodes = new NodeGroup();
        //
        //this.id_to_node = new Id_to_Node();
        //this.node_to_neighbors = new Node_to_Neighbors();
        //
		//this.numPlanets = 0;
        //
        //this.factionShipCount = new Map<FactionType, Int>();
		//this.factionControlledNodes = new Map<FactionType, NodeGroup>();
		//
        //// initialize global faction data
        //for (faction in Faction.getEnums()) {
            //this.factionShipCount.set(faction, 0);
			//this.factionControlledNodes.set(faction, new NodeGroup());
        //}
        
        this.setGraph();
		
        // Log level start and time
        Main.LOGGER.logLevelStart(level, Date.now());
		
		parseLevel();
        
        // Load the nodes
        trace("Building level: " + level);
		switch (level) {
			case 1:
				levelOne(playState);
			case 2:
				levelTwo(playState);
			default:
				levelThree(playState);
		}
		drawNodes();
		//for (n in nodes) {
		for (n in node_to_neighbors.keys()) {
			var captureable = n.getCaptureable();
			if (captureable != null) {
				factionControlledNodes.get(captureable.getFaction().getFactionType()).add(n);
			}
		}
	}

	public function findNode(v: FlxVector):MapNode {
		//return nodes.filter(function(n) return n.contains(v))[0];
		//for (node in nodes) {
		for (node in node_to_neighbors.keys()) {
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
    
    private function setGraph():Void {
        trace("clearing graph");
        
        this.id_to_node = new Id_to_Node();
        this.clearGraph(); // clean up any old entires
        this.node_to_neighbors = new Node_to_Neighbors();
        
        this.factionShipCount = new Map<FactionType, Int>();
		this.factionControlledNodes = new Map<FactionType, NodeGroup>();
		
        // initialize global faction data
        for (faction in Faction.getEnums()) {
            this.factionShipCount.set(faction, 0);
			this.factionControlledNodes.set(faction, new NodeGroup());
        }
    }
    
    /**
     * Clears out any pre-existing node neighbors
     */
    private function clearGraph():Void {
        if (node_to_neighbors != null) {
            for (ng in node_to_neighbors) {
                for (node in ng) {
                    if (node != null) node.clearNode();
                }
            }
        }
    }
    
     /**
      * Adds new node to this graph.
      * @param node new node to add
      * @return true iff graph was modified, false otherwise
      */
    private function addNode(id:String, x:Float, y:Float):MapNode {
        if (!id_to_node.exists(id)) {
            var node = new MapNode(this, x, y);
            id_to_node.set(id, node);
            node_to_neighbors.set(node, new NodeGroup());
            return node;
        }
        return null;
    }
    
    private function connectByID(node_id1:String, node_id2:String):Bool {
        if (!(id_to_node.exists(node_id1) && id_to_node.exists(node_id2))) {
            return false;
        }
        return connect(id_to_node.get(node_id1), id_to_node.get(node_id2));
    }
    
    /**
     * Connects two specified nodes by adding an edge between them.
     * @param node1 one vertex of edge
     * @param node2 the other vertex of edge
     * @return true iff graph was modified, false otherwise
     */
    private function connect(node1:MapNode, node2:MapNode):Bool {
        return node1.connect(node2);
    }
    
    private function addCapturableByID(node_id1:String, capturable:Capturable):Bool {
        if (!(id_to_node.exists(node_id1) || capturable == null)) {
            return false;
        }
        return addCapturable(id_to_node.get(node_id1), capturable);
    }
    
    /**
     * Adds specified capturable object to the specified node.
     * @param node  node to add capturable to
     * @param capturable    capturable to add
     * @return true iff node was modified, false otherwise
     */
    private function addCapturable(node:MapNode, capturable:Capturable):Bool {
        return node.setCapturable(capturable);
    }
     
    /*
     * public Game Map functions
     * 
     * These allow for global ship production limit enforcement or
     * other general queries made via MapNode game object reside on.
     */
    
    public function getNodeList():Array<MapNode> {
        var result:Array<MapNode> = new Array();
        for (node in node_to_neighbors.keys()) {
            result.push(node);
        }
        return result.copy();
    }

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
		//loadGraphic("assets/images/mapbg.png", false, 400, 320);

		// Draw the nodes to the background
		//for (n in nodes)
		for (n in node_to_neighbors.keys())
		{
			n.drawTo(this);
		}
	}
	
	// level 1
	private function levelOne(playState:PlayState):Void {
		// create nodes
        var n1 = this.addNode("node1", 474.0, 344.0);
		var n2 = this.addNode("node2", 697.0, 344.0);
		
		// create edges
        this.connectByID("node1", "node2");
        this.connectByID("node2", "node1");
		
		// draw the nodes
		//drawNodes();
		
		// set captureable
		var n1P = new Planet(playState, this.id_to_node.get("node1"), new Faction(FactionType.PLAYER), new PlanetStat(new BluePrint(HullType.FRIGATE)));
		var n2P = new Planet(playState, this.id_to_node.get("node2"), new Faction(FactionType.NOP), new PlanetStat(new BluePrint(HullType.FRIGATE)));

        this.addCapturableByID("node1", n1P);
        this.addCapturableByID("node2", n2P);
		FlxG.state.add(n1P);
		FlxG.state.add(n2P);
	}
	
	// level 2
	private function levelTwo(playState:PlayState):Void {
		// make nodes
		addNode("node1", 50, 150);
		addNode("node2", 200, 150);
        addNode("node3", 350, 150);
		
		// make edges
        connectByID("node1", "node2");
        connectByID("node2", "node3");
        
        //drawNodes();
        
		// set captureable
		var n1P = new Planet(playState, id_to_node.get("node1"), new Faction(FactionType.PLAYER), new PlanetStat(new BluePrint(HullType.FRIGATE, 30.0), 10, 3.0));
		var n2P = new Planet(playState, id_to_node.get("node2"), new Faction(FactionType.NOP), new PlanetStat(new BluePrint(HullType.FRIGATE)));
		var n3P = new Planet(playState, id_to_node.get("node3"), new Faction(FactionType.ENEMY_1), new PlanetStat(new BluePrint(HullType.FRIGATE, 15.0, 0.3, 100.0, 1.0, 7.0)));
		
        addCapturableByID("node1", n1P);
        addCapturableByID("node2", n2P);
        addCapturableByID("node3", n3P);
        
		FlxG.state.add(n1P);
		FlxG.state.add(n2P);
		FlxG.state.add(n3P);
	}
	
	// level 3
	public function levelThree(playState:PlayState):Void {
		// make nodes
        var n1 = addNode("node1", 50, 50);
		var n2 = addNode("node2", 100, 200);
        var n3 = addNode("node3", 300, 70);
        var n4 = addNode("node4", 270, 250);

		// make edges
        connectByID("node1", "node2");
        connectByID("node2", "node3");
        connectByID("node2", "node4");
        connectByID("node3", "node4");

		// set captureable
		var n1P = new Planet(playState, id_to_node.get("node1"), new Faction(FactionType.PLAYER), new PlanetStat(new BluePrint(HullType.FRIGATE, 30.0), 10, 3.0));
		var n3P = new Planet(playState, id_to_node.get("node3"), new Faction(FactionType.NOP), new PlanetStat(new BluePrint(HullType.FRIGATE)));
		var n4P = new Planet(playState, id_to_node.get("node4"), new Faction(FactionType.ENEMY_1), new PlanetStat(new BluePrint(HullType.FRIGATE, 20.0, 0.3, 100.0, 1.0, 8.0)));
        
        addCapturableByID("node1", n1P);
        addCapturableByID("node3", n3P);
        addCapturableByID("node4", n4P);
        
		FlxG.state.add(n1P);
		FlxG.state.add(n3P);
		FlxG.state.add(n4P);
	}
	
	private function parseLevel():Void {
		var file = File.getContent("assets/data/level" + Main.LEVEL + ".json");
		var data = Json.parse(file);
	}
	
	/*
	 * return the amount of player planet in the map
	 */
	public function getNumPlayerPlanets():Int {
        var numPlayerPlanets = 0;
		//for (n in nodes) {
		for (n in node_to_neighbors.keys()) {
			if (n.isPlanet()) {
				var c = cast(n.getCaptureable(), Planet);
				if (c.getFaction().getFactionType() == FactionType.PLAYER) {
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
        var planetCount:Int = 0;
        for (node in node_to_neighbors.keys()){
            if (node.isPlanet()) planetCount++;
        }
        return planetCount;
	}
}

