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

package gameUnits.capturable;

import faction.CaptureEngine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import map.MapNode;
import faction.Faction;

/**
 * Capturable
 * 
 * Capturable objects, like planets and beacons, exist on nodes.
 * 
 * This class acts as interface between objects that can be captured and
 * the underlying graph structure that makes up the game map.  It stores
 * the controlling faction and capture engine.
 * 
 * @author Drew Reese
 */
class Capturable extends FlxSprite {

    // parent node and faction control fields
	private var node: MapNode;
	private var faction:Faction;
	
	private var captureBar:FlxBar;
	private var TOTAL_CP:Float = 100.0;
    
    private var captureEngine:CaptureEngine; // TODO: make this an actual HUD :/
	private var shipsAtPlanet: Array<Ship>;
    
    public function new(node: MapNode, faction: Faction) {
        super(node.x, node.y);
        this.node = node;
        this.faction = faction;
        this.captureEngine = new CaptureEngine(this.faction.getFaction(), 100.0);
		
		// create capturebar and add it to the graphics
		captureBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 50, 10, null, "", 0, captureEngine.getMaxControllingPoint(), true);
		captureBar.x = node.x - 25;
		captureBar.y = node.y + 20;
		captureBar.createColoredFilledBar(faction.getColor(), true);
		captureBar.killOnEmpty = false;
		captureBar.visible = false;
		FlxG.state.add(captureBar);
    }
    
    override public function update(elapsed:Float):Void {
        // TODO: Monitor capture status, display "contended" bar when active skirmish happening
		// get accumulative points
		var totalCP = new Map<FactionType, Float>();
		for (f in Faction.getEnums()) {
			totalCP[f] = 0.0;
		}
		for (s in shipsAtPlanet) {
			var cp = totalCP[s.getFaction()];
			totalCP.set(s.getFaction(), cp + (s.stats.cps));
		}
		for (f in Faction.getEnums()) {
			captureEngine.setPoints(f, totalCP[f] * elapsed);
		}
		
		// change bar color to invading faction if being invaded for NOP
		if (this.faction.getFaction() == FactionType.NOP && captureEngine.isContended()) {
			captureBar.createColoredFilledBar(captureEngine.getCapturingFaction().getColor(),true);
		}
		
		// change faction if captured
		if (captureEngine.checkCaptured()) {
			// change controlling faction if captured
			var currStatus = captureEngine.status();
			var currFaction;
			for (f in currStatus.keys()) {
				currFaction = f;
			}
			// if captured, change faction and set bar color
			faction = new Faction(currFaction);
			captureBar.color = faction.getColor();
		}
		
		// get current cp
		var currStatus = captureEngine.status();
		var currFaction;
		for (f in currStatus.keys()) {
			currFaction = f;
		}
		// keep track of current cp
		var currCP = currStatus[currFaction];
				
		// set value for bar
		captureBar.value = currCP;
		captureBar.updateBar();
		
		captureBar.visible = captureEngine.isContended();
				
        super.update(elapsed);
    }
	
	// sets array of ships at planet
	public function setShips(ships: Array<Ship>): Void {
		shipsAtPlanet = ships;
	}
	
	// get current cp of this
	public function getCP(): Float {
		return captureBar.value;
	}
	
	// get max cp this can have
	public function getTotalCP():Float {
		return captureEngine.getMaxControllingPoint();
	}
	
	/**
	 * Returns the faction of this Capturable.
	 * @return  Faction of this capturable object
	 */
	public function getFaction():Faction {
		return this.faction;
	}
}
