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

import faction.Faction;
import faction.Faction.FactionType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import gameUnits.Ship.ShipStat;
import gameUnits.Ship.ShipType;
import gameUnits.capturable.Planet;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Rory Soiffer
 */
class GameMap extends FlxSprite
{

	public var nodes:Array<MapNode> = [];
	private var level:Int;
	private var numPlanets:Int;

	public function new(playState:PlayState, level: Int)
	{
		super();
		
		// store the level
		this.level = level;
		numPlanets = 0;
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
	}

	public function findNode(v: FlxVector): MapNode
	{
		return nodes.filter(function(n) return n.contains(v))[0];
	}

	private var selected: MapNode = null;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function drawNodes():Void {
		// Loads an empty sprite for the map background
		loadGraphic("assets/images/background.png", false, 400, 320);

		// Draw the nodes to the background
		for (n in nodes)
		{
			n.drawTo(this);
		}
	}
	
	// level 1
	private function levelOne(playState:PlayState):Void {
		// create nodes
		var n1 = new MapNode(this, new FlxVector(100, 150));
		var n2 = new MapNode(this, new FlxVector(300, 150));
		
		// create edges
		n1.neighbors.push(n2);
		n2.neighbors.push(n1);
		
		// draw the nodes
		nodes = [n1, n2];
		//drawNodes();
		
		// set captureable
		var n1P = new Planet(playState, n1, new Faction(FactionType.PLAYER), new PlanetStat(new ShipStat(ShipType.FRIGATE)));
		var n2P = new Planet(playState, n2, new Faction(FactionType.NOP), new PlanetStat(new ShipStat(ShipType.FRIGATE)));
		n1.setCapturable(n1P);
		n2.setCapturable(n2P);
		FlxG.state.add(n1P);
		FlxG.state.add(n2P);
		numPlanets = 2;
	}
	
	// level 2
	private function levelTwo(playState:PlayState):Void {
		// make nodes
		var n1 = new MapNode(this, new FlxVector(50, 150));
		var n2 = new MapNode(this, new FlxVector(200, 150));
		var n3 = new MapNode(this, new FlxVector(350, 150));
		
		// make edges
		n1.neighbors.push(n2);
		n2.neighbors.push(n1);
		n2.neighbors.push(n3);
		n3.neighbors.push(n2);
		nodes = [n1, n2, n3];
		
		// set captureable
		var n1P = new Planet(playState, n1, new Faction(FactionType.PLAYER), new PlanetStat(new ShipStat(ShipType.FRIGATE)));
		var n2P = new Planet(playState, n2, new Faction(FactionType.NOP), new PlanetStat(new ShipStat(ShipType.FRIGATE)));
		var n3P = new Planet(playState, n3, new Faction(FactionType.ENEMY_1),
					new PlanetStat(new ShipStat(ShipType.FRIGATE, 15.0, 0.3, 100.0, 1.0, 7.0)));
		
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
		var n1 =  new MapNode(this, new FlxVector(50, 50));
		var n2 = new MapNode(this, new FlxVector(100, 200));
		var n3 = new MapNode(this, new FlxVector(300, 70));
		var n4 = new MapNode(this, new FlxVector(270, 250));

		// make edges
		n1.neighbors.push(n2);
		n2.neighbors.push(n1);

		n2.neighbors.push(n3);
		n3.neighbors.push(n2);

		n2.neighbors.push(n4);
		n4.neighbors.push(n2);

		n3.neighbors.push(n4);
		n4.neighbors.push(n3);

		nodes = [n1, n2, n3, n4];
		
		// set captureable
		var n1P = new Planet(playState, n1, new Faction(FactionType.PLAYER), new PlanetStat(new ShipStat(ShipType.FRIGATE)));
		var n2P = new Planet(playState, n2, new Faction(FactionType.NOP), new PlanetStat(new ShipStat(ShipType.FRIGATE)));
		var n4P = new Planet(playState, n3, new Faction(FactionType.ENEMY_1),
					new PlanetStat(new ShipStat(ShipType.FRIGATE, 20.0, 0.3, 100.0, 1.0, 8.0)));
		n1.setCapturable(n1P);
		n2.setCapturable(n2P);
		n4.setCapturable(n4P);
		FlxG.state.add(n1P);
		FlxG.state.add(n2P);
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

