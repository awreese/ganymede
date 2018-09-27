/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
 *  Copyright (C) 2018  Andrew Reese
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

package com.ganymede.gameUnits.capturable;

import com.ganymede.db.Ganymede;
import com.ganymede.faction.Faction;
import com.ganymede.gameUnits.capturable.CaptureBar;
import com.ganymede.gameUnits.ships.Ship;
import com.ganymede.map.Node;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using com.ganymede.util.Utility.FloatTools;
using haxe.EnumTools.EnumValueTools;

/**
 * Capturable
 *
 * Capturable objects, like planets and beacons, exist on nodes.
 *
 * @author Drew Reese
 */
class Capturable extends FlxSpriteGroup implements I_Capturable {

  public var node(default, null): Node;
  public var totalControlPoints(default, null):Float;
  public var controllingFaction(default, null):FactionType;
  public var capturingFaction(default, null):FactionType;
  public var isControlled(default, null):Bool;
  
  private var currentControlPoints:Float;
  private var captureBar:CaptureBar;

  private var shipsAtPlanet: Array<Ship>; // TODO: Query this from node

  /**
   * Private constructor used by extending classes.
   * @param node  node capturable resides on
   * @param faction   faction of capturable node
   */
  private function new(
    node: Node,
    ?control_points = 100.0,
    ?control_faction:FactionType
  ) {
    super(node.x, node.y);
    
    this.node = node; // TODO: Check if this is needed for position any longer
    this.totalControlPoints = control_points;
    
    var isNOP:Bool = control_faction.equals(null) || control_faction.equals(NOP);
    this.controllingFaction = isNOP ? NOP : control_faction;
    this.capturingFaction = NOP;
    this.currentControlPoints = isNOP ? 0 : this.totalControlPoints;
    this.isControlled = !isNOP;
    
    // create capturebar and add it to the graphics
    captureBar = new CaptureBar(this, barEmpty, barFull);
    this.add(captureBar);
  }

  override public function update(elapsed:Float):Void {

    for (shipGroup in this.node.getShipGroups()) {
      for (ship in shipGroup) {
        ship.attemptCapture(this);
      }
    }

    super.update(elapsed);
    
    // TODO: Create & Apply capture entropy
    //if (!this.isControlled) {
      //this.currentControlPoints -= 5 * elapsed;
    //}
    //this.currentControlPoints = this.currentControlPoints.bound(0, this.totalControlPoints);
  }
  
  private function barEmpty() {
    //trace('Bar is empty');
  }
  
  private function barFull() {
    //trace('Bar is full');
  }
  
  // TODO: Remove this and query from node
  // sets array of ships at planet
  public function setShips(ships: Array<Ship>): Void {
    shipsAtPlanet = ships;
  }

  // TODO: I don't think this is required now, so check if removeable
  // get current cp of this
  public function getCP(): Float {
    //return captureBar.value;
    return this.currentControlPoints;
  }

  // TODO: same as above
  // get max cp this can have
  public function getTotalCP():Float {
    return this.totalControlPoints;
  }

  /**
   * Returns the faction of this Capturable.
   * @return  Faction of this capturable object
   */
  public function getFaction():Faction {
    return new Faction(this.controllingFaction);
  }
  
  public function capture(capturingFaction:FactionType, capturePoints:Float):Void {
    var normalizedCapturePoints:Float = capturePoints.roundN(3);
    var defending:Float = this.isDefendingCapture(capturingFaction) ? 1 : -1;
    
    this.currentControlPoints += defending * normalizedCapturePoints;
    
    if (this.currentControlPoints < 0.0) {
      this.lost(capturingFaction);
    }
    
    if (this.currentControlPoints > this.totalControlPoints) {
      if (!this.isControlled) {
        this.captured();
      }
      this.currentControlPoints = this.totalControlPoints;
    }
  }
  
  private function isDefendingCapture(capturingFaction:FactionType):Bool {
    var defendingControl:Bool = capturingFaction.equals(this.controllingFaction);
    var gainAfterCapture:Bool = capturingFaction.equals(this.capturingFaction);
    return defendingControl || gainAfterCapture;
  }

  private function captured():Void {
    this.controllingFaction = this.capturingFaction;
    this.capturingFaction = NOP;
    this.isControlled = true;
  }
  
  private function lost(capturingFaction:FactionType):Void {
    this.currentControlPoints *= -1;
    this.controllingFaction = NOP;
    this.capturingFaction = capturingFaction;
    this.isControlled = false;
  }
}
