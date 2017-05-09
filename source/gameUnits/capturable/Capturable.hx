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
    
    public function new(node: MapNode, faction: Faction) {
        super(node.pos.x, node.pos.y);
        this.node = node;
        this.faction = faction;
        this.captureEngine = new CaptureEngine(this.faction.getFaction(), 100.0);
		
		// create capturebar and add it to the graphics
		captureBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 50, 10, null, "", 0, 100, true);
		captureBar.x = node.pos.x - 25;
		captureBar.y = node.pos.y + 20;
		captureBar.createColoredFilledBar(faction.getColor(), true);
		captureBar.visible = false;
		FlxG.state.add(captureBar);
    }
    
    override public function update(elapsed:Float):Void {
        // TODO: Monitor capture status, display "contended" bar when active skirmish happening
		
		// get the current controlling faction and their cp
		var currStatus = captureEngine.status();
		var currFaction = FactionType.NOP;
		for (f in currStatus.keys()) {
			currFaction = f;
		}
		var currCP = currStatus.get(currFaction);
		
		if (captureEngine.checkCaptured()) {
			// if captured, change faction and set bar color
			faction = new Faction(currFaction);
			captureBar.color = faction.getColor();
		}
		
		captureBar.value = currCP;
		
		captureBar.visible = true;
		
        super.update(elapsed);
    }
}
