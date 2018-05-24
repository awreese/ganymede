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

package com.ganymede.faction;

import com.ganymede.faction.Faction.FactionType;
import flixel.math.FlxMath.bound;

/**
 * Control Accumulator wraps and maintains an N-way accumulator that tracks
 * the accruing control points from each faction.
 *
 * @author Drew Reese
 */
private class ControlAccumulator {
  public var _totalControlPoints:Float;
  public var _currentControlPoints:Float;
  public var _currentControlFaction:FactionType;
  public var _capturingFaction: FactionType;

  /**
   * Creates new control accumulator.
   * @param control_faction = NOP
   * @param control_points = 100.0
   */
  public function new(?control_faction:FactionType, ?total_control_points = 100.0) {
    this._currentControlFaction = (control_faction == null) ? NOP : control_faction; // sets default
    this._totalControlPoints = total_control_points;
    this._currentControlPoints = control_faction == NOP ? 0.0 : total_control_points;
  }

  /**
   * Runs one interation of capture point accumulation.
   * @param factions
   * @return true iff controlling faction changed
   */
  public function accumulate(factions:Map<FactionType, Float>):Bool {
    var oldController = this._currentControlFaction;

    for (f in Faction.getEnums()) {
      var cp = factions.get(f);

      if ((oldController == NOP && f == this._capturingFaction) || f == oldController) {
        this._currentControlPoints += factions.get(f);

        // check if capturing faction finally captured
        this.checkCaptured(f);

      } else {
        this._currentControlPoints -= factions.get(f);

        // check if controling faction lost possession
        this.checkLost(f);
      }
    }
    // make sure currentControlPoints is not less than 0
    //this._currentControlPoints = this._currentControlPoints < 0.0 ? 0.0 : this._currentControlPoints;
    // make sure currentControlPoints is not greater than totalControlPoints
    //this._currentControlPoints = this._currentControlPoints > this._totalControlPoints ? this._totalControlPoints : this._currentControlPoints;
    this._currentControlPoints = bound(_currentControlPoints, 0.0, _totalControlPoints);
    
    return this._currentControlFaction != oldController;
  }

  /**
   * Checks if faction captured object
   * @param faction
   * @return
   */
  private function checkCaptured(faction:FactionType):Bool {
    if (this._currentControlPoints > this._totalControlPoints) {
      this._currentControlPoints = this._totalControlPoints;
      this._currentControlFaction = faction;
      return true;
    }
    return false;
  }

  /**
   * Checks if faction caused the captured object to be lost
   * @param faction
   * @return
   */
  private function checkLost(faction:FactionType):Bool {
    if (this._currentControlPoints < 0) {
      this._currentControlFaction = NOP;
      this._capturingFaction = faction;
      this._currentControlPoints = Math.abs(this._currentControlPoints);
      return true;
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
  public function addPoints(faction:FactionType, points:Float):Void {
    var min = 0.0;
    var max = this._controlAccumulator._totalControlPoints;

    this._factions[faction] = bound(points, min, max);
  }

  /**
   * If the controlling faction is not in 100% control of capturable object, this
   * method returns true, false otherwise.
   * @return true iff controlling faction has less then total control points, false otherwise
   */
  public function isContended():Bool {
    if (_controlAccumulator._currentControlFaction == NOP) {
      // if planet is NOP, contended if currentControlPoints is greater than 0.0
      return this._controlAccumulator._currentControlPoints > 0.0;
    } else {
      // if planet is not NOP, contended if currentControlPoints > totalControlPoints
      return this._controlAccumulator._currentControlPoints < this._controlAccumulator._totalControlPoints;
    }
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
    var faction = this._controlAccumulator._currentControlFaction;
    var points = this._controlAccumulator._currentControlPoints;
    return [faction => points];
  }

  /**
   * Returns the total controlling points that this captureEngine can have
   * @return float of the total controlling points
   */
  public function getMaxControllingPoint(): Float {
    return this._controlAccumulator._totalControlPoints;
  }

  /**
   * Return the Capturing Faction
   * @return Faction of capturing faction
   */
  public function getCapturingFaction(): Faction {
    return new Faction(this._controlAccumulator._capturingFaction);
  }
}
