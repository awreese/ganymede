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

package faction;

import faction.Faction;

/**
 * Control Accumulator wraps and maintains an N-way accumulator that tracks
 * the accruing control points from each faction.
 * @author Drew Reese
 */
private class ControlAccumulator {
    public var _controlAccumulator:Map<FactionType, Float>;
    public var _controlPoints:Float;
    public var _controlFaction:FactionType;
    
    /**
     * Creates new control accumulator.
     * @param control_faction = NOP
     * @param control_points = 100.0
     */
    public function new(?control_faction:FactionType, ?control_points = 100.0) {
        control_faction = (control_faction == null) ? NOP : control_faction; // sets default
        this._controlAccumulator = new Map<FactionType, Float>();
        this._controlPoints = control_points;
        
        this.setControl(control_faction, control_points);
        
        trace("new control accumulator: " + this);
    }
    
    /**
     * Sets new controlling faction of this accumulator
     * @param control_faction
     * @param control_points
     */
    public function setControl(control_faction:FactionType, control_points:Float):Void {
        this._controlFaction = control_faction;
        for (ft in Faction.getEnums()) {
            if (ft == this._controlFaction) {
                this._controlAccumulator.set(ft, control_points);
            } else {
                this._controlAccumulator.set(ft, 0.0);
            }
        }
    }
    
    /**
     * Runs one interation of capture point accumulation.
     * @param factions
     * @return true iff controlling faction changed
     */
    public function accumulate(factions:Map<FactionType, Float>):Bool {
        // N-way accumulator
        for (f1 in Faction.getEnums()) {
            var contribution = factions.get(f1);
            factions.set(f1, 0.0);
            this._controlAccumulator[f1] += contribution;
            
            for (f2 in Faction.getEnums()) {
                if (f1 != f2) {
                    this._controlAccumulator[f2] -= contribution / (Faction.count() - 1);
                }
            }
        }
        
        // check if faction gained possession
        for (f1 in Faction.getEnums()) {
            if (f1 != this._controlFaction && this._controlAccumulator[f1] >= this._controlPoints) {
                this.setControl(f1, this._controlPoints);
                return true;
            }
        }
        return false;
    }
    
}

/**
 * Capture Engine
 * Used in object update methods to track accumulated faction capture points.
 * @author Drew Reese
 */
class CaptureEngine {
    private var _controlAccumulator:ControlAccumulator;
    private var _factions:Map<FactionType, Float>;

    /**
     * Instantiates new capture engine for faction object
     * @param control_faction = NOP
     * @param control_points = 100.0
     */
	public function new(?control_faction:FactionType, ?control_points = 100.0) {
        control_faction = (control_faction == null) ? NOP : control_faction; // sets default
        this._controlAccumulator = new ControlAccumulator(control_faction, control_points);
        this._factions = new Map<FactionType, Float>();
        
        for (ft in Faction.getEnums()) {
            this._factions.set(ft, 0.0);
        }
        
        trace(this._controlAccumulator);
	}
    
    /**
     * Bounds value val between min and max.
     * @param val   value to bound
     * @param min   minimum value
     * @param max   maximum value
     * @return  bounded value
     */
    private function bound(val:Float, min:Float, max:Float):Float {
        return Math.min(max, Math.max(min, val));
    }
	
    /**
     * Sets the faction capture points of the specified faction.
     * 
     * This is called to set the current accrued faction capture points 
     * before checking if change of possession has occured.
     * 
     * Example:
     *      for (faction in Faction.getEnums()) {
     *          cp = SUM(faction.cps @ object) * elapsed (converted to seconds)
     *          CaptureEngine.setPoints(faction, cp)
     *      }
     *      captured = CaptureEngine.checkCaptured();
     * 
     * @param faction   faction capturing object
     * @param points    sum of faction capture points per second
     */
    public function setPoints(faction:FactionType, points:Float):Void {
        var min = 0.0;
        var max = this._controlAccumulator._controlPoints;
        
        this._factions[faction] = bound(points, min, max);
    }
    
    /**
     * Checks if object has been captured.
     * @return true iff object has been captured, false otherwise
     */
    public function checkCaptured():Bool {
        return this._controlAccumulator.accumulate(this._factions);
    }
    
    /**
     * Returns the currently controlling faction and it's control points amount.
     * @return
     */
    public function status():Map<FactionType, Float> {
        var faction = this._controlAccumulator._controlFaction;
        var points = this._controlAccumulator._controlAccumulator.get(faction);
        return [faction => points];
    }
}
