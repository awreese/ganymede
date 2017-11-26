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
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import gameUnits.Ship;
import gameUnits.Ship.BluePrint;
import gameUnits.Ship.HullType;
import gameUnits.capturable.Capturable;
import gameUnits.capturable.Planet;
import graph.Graph;
import haxe.Json;
import map.Node.NodeGroup;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

typedef Id_to_Node = Map<String, Node>;

typedef Node_to_Neighbors = Map<Node, NodeGroup>;

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
class GameMap extends FlxSpriteGroup {

	// list of nodes in current game map
	//public var nodes:MapNodeList = [];
	//public var nodes:NodeGroup;
    
    private var id_to_node:Id_to_Node;
    private var node_to_neighbors:Node_to_Neighbors;
	private var _mapGraph:Graph<String,Float>;
    
    private var selected:Node = null;
	
    private var factionShipCount:Map<FactionType, Int>; // Global ship count
	private var factionControlledNodes:Map<FactionType, NodeGroup>;
	
	private var enemyAi:Int;
	
	private var minX: Float;
	private var maxX: Float;
	private var minY: Float;
	private var maxY: Float;

	public function new(playState:PlayState, level: Int) {
		minX = Math.POSITIVE_INFINITY; // smallest x
		maxX = Math.NEGATIVE_INFINITY; // biggest x
		minY = Math.POSITIVE_INFINITY; // smallest y
		maxY = Math.NEGATIVE_INFINITY; // biggest y
		super();
        
        //loadGraphic("assets/images/mapbg.png", false, 1920, 1047);
		
		var bg = new FlxSprite(AssetPaths.mapbg__png);
		this.add(bg);
        
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
		
		this._mapGraph = new Graph<String,Float>();
			//.allowCycles(true)
			//.build();
		
		this._mapGraph.add('a');
        this._mapGraph.add('b');
        this._mapGraph.add('c');
        this._mapGraph.add('d');
        this._mapGraph.add('e');
        this._mapGraph.add('f');
        this._mapGraph.add('g');
        this._mapGraph.add('h');
        
        _mapGraph.connect('a', 'b', 2);
        _mapGraph.connect('a', 'f', 1);
        _mapGraph.connect('a', 'h', 3);
        _mapGraph.connect('b', 'c', 4);
        _mapGraph.connect('b', 'e', 1);
        _mapGraph.connect('e', 'f', 2);
        _mapGraph.connect('e', 'd', 2);
        _mapGraph.connect('f', 'h', 2);
        _mapGraph.connect('f', 'g', 3);
        _mapGraph.connect('f', 'd', 5);
        _mapGraph.connect('h', 'g', 1);
        _mapGraph.connect('d', 'g', 4);
        _mapGraph.connect('d', 'c', 3);
        
        trace("f connected to d (true):  " + _mapGraph.isConnected('f', 'd'));
        trace("d connected to f (true):  " + _mapGraph.isConnected('d', 'f'));
        trace("a connected to e (false): " + _mapGraph.isConnected('a', 'e'));
        trace(Json.stringify(_mapGraph));
		
		//var compareFn = function(e1:Float, e2:Float):Int {
			////return e1 - e2;
			//if (e1 < e2) return -1;
			//if (e1 > e2) return 1;
			//return 0;
		//}
		
		//_mapGraph.findPath(1, 2, compareFn);
		_mapGraph.findPath('a', 'b');
        
        this.setGraph();
		
        // Log level start and time
        Main.LOGGER.logLevelStart(level);
		trace("Constructing level: " + level);
		parseLevel(playState);
        
		drawNodes();
		
		//for (n in nodes) {
		for (n in node_to_neighbors.keys()) {
			var captureable = n.getCaptureable();
			if (captureable != null) {
				factionControlledNodes.get(captureable.getFaction().getFactionType()).add(n);
			}
		}
		// TODO: figure out how to not get any gray area when zooming in to the corner of the map
        if (Main.AB_VERSION != Main.AB_TEST[0] || Main.LEVEL != 1) {
            minX = minX - Node.NODE_RADIUS * 2 - 10 < 0.0 ? 0.0 : minX - Node.NODE_RADIUS * 2 - 10; // get offset for node
            minY = minY - Node.NODE_RADIUS * 2 - 10 < 0.0 ? 0.0 : minY - Node.NODE_RADIUS * 2 - 10; // get offset for node
            maxY = maxY + Node.NODE_RADIUS * 2 + 10 < 0.0 ? FlxG.width : maxY + Node.NODE_RADIUS * 2 + 10; // get offset for node
            maxX = maxX + Node.NODE_RADIUS * 2 + 10 < 0.0 ? FlxG.width : maxX + Node.NODE_RADIUS * 2 + 10; // get offset for node
            var p = new FlxPoint((maxX + minX) / 2, (maxY + minY) / 2);
            FlxG.camera.focusOn(new FlxPoint((maxX + minX) / 2, (maxY + minY) / 2));
            var z = FlxG.stage.width  / (maxX - minX);
            z = z > FlxG.stage.height / (maxY - minY) ? FlxG.stage.height / (maxY - minY) : z; // set to smallest zoom
    
            FlxG.camera.zoom = z > 1.25 ? z : 1; // zoom into map
        }
	}

	public function findNode(v: FlxVector):Node {
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
		// update which nodes belong to which faction
		for (faction in Faction.getEnums()) {
			for (n in factionControlledNodes.get(faction)) {
				if (n.getFaction() != faction) {
					factionControlledNodes.get(faction).remove(n, true);
					factionControlledNodes.get(n.getFaction()).add(n);
				}
			}
		}
	}
    
    /*
     * private graph functions
     * 
     * These are convenience methods to help in designing levels.
     */
    
    private function setGraph():Void {
        
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
    private function addNode(id:String, x:Float, y:Float):Node {
        if (!id_to_node.exists(id)) {
            var node = new Node(this, x, y);
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
    private function connect(node1:Node, node2:Node):Bool {
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
    private function addCapturable(node:Node, capturable:Capturable):Bool {
        return node.setCapturable(capturable);
    }
     
    /*
     * public Game Map functions
     * 
     * These allow for global ship production limit enforcement or
     * other general queries made via MapNode game object reside on.
     */
    
    public function getNodeList():Array<Node> {
        var result:Array<Node> = new Array();
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
	
	public function updateControllingFaction(node:Node, faction:FactionType):Void {
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
			//n.drawTo(this);
			//this.add(n);
			FlxG.state.add(n);
		}
	}
	
	private function parseLevel(playState:PlayState):Void {
		var file = Assets.getText("assets/data/level" + Main.LEVEL + ".json"); // get string of json
		var data = Json.parse(file); // parse json

		enemyAi = data.ai; // get ai time
		var nodes = data.nodes; // get nodes
		var neighbors = data.neighbors; // get neighbors
		
		// For each node in the level
		for (s in Reflect.fields(nodes)) {
			var node = data.nodes[Std.parseInt(s)];
			var n = this.addNode(node.id, node.x, node.y); // Add the node to the game
			
			// Update the level bounds
			minX = node.x < minX ? node.x : minX; // set smallest x
			maxX = node.x > maxX ? node.x : maxX; // set biggest x
			minY = node.y < minY ? node.y : minY; // set smallest y
			maxY = node.y > maxY ? node.y : maxY; // set biggest y
			
			// Get the node's faction
			var faction:FactionType = null; 
			if (Reflect.hasField(node, "faction")) {
				switch (node.faction) {
					case "player":
						faction = FactionType.PLAYER;
					case "enemy1":
						faction = FactionType.ENEMY_1;
					case "enemy2":
						faction = FactionType.ENEMY_2;
					case "enemy3":
						faction = FactionType.ENEMY_3;
					case "enemy4":
						faction = FactionType.ENEMY_4;
					case "enemy5":
						faction = FactionType.ENEMY_5;
					case "enemy6":
						faction = FactionType.ENEMY_6;
					case "neutral":
						faction = FactionType.NEUTRAL;
					case "nop":
						faction = FactionType.NOP;
					default:
						faction = null;
				}
			}
			
			// Defining planets and ships by templates
			if (Reflect.hasField(node, "planet")) {
				// Load the planet and ship templates
				var planetstat = PlanetStat.getPlanetStat(node.planet.planet_template);
				planetstat.ship = BluePrint.getBluePrint(node.planet.ship_template);
				
				// Create the planet and add it the to game
				var planet = new Planet(playState, this.id_to_node.get(node.id), new Faction(faction), planetstat);
				this.addCapturableByID(node.id, planet);
				FlxG.state.add(planet);
			}
			
			// Defining planets and ships by custom stats
			// Keeping the same format allows compatibility with old level files
			if (Reflect.hasField(node, "captureable")) {
				if (faction != null) {
					// if there'a faction, then not empty node
					var cap = node.captureable;
					switch(cap.object) {
						case "planet":
							// if planet
							var bp = cap.blueprint; // get blueprint from json
							var blueprint = new BluePrint(bp.hull, bp.maxVel, bp.sh, bp.hp, bp.as, bp.ad, bp.cps); // make blueprint
							// make planet stat
							var ps = new PlanetStat(blueprint, cap.cap, cap.prod, cap.prod_thresh, cap.cap_lvl, cap.tech_lvl, cap.base_cost, cap.cap_per_level, cap.tech_per_lvl);
							var planet = new Planet(playState, this.id_to_node.get(node.id), new Faction(faction), ps); // create planet
							this.addCapturableByID(node.id, planet); // add planet
							FlxG.state.add(planet);
					}
				}
			}
		}
		
		// For each edge between nodes
		for (s in Reflect.fields(neighbors)) {
			var node = neighbors[Std.parseInt(s)]; // get node
			for (i in Reflect.fields(node.neighbor)) {
				var n2 = node.neighbor[Std.parseInt(i)]; // get id of neighbor
				this.connectByID(node.id, n2); // create edge
			}
		}
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
	
	/*
	 * return the timer for the enemy AI
	 */
	public function getAiTime():Int {
		return enemyAi;
	}
}
