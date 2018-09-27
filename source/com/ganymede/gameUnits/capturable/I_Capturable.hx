/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2018 Andrew Reese
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

//import com.ganymede.gameUnits.capturable.CaptureEngine;
import com.ganymede.faction.Faction;
import com.ganymede.map.Node;

/**
 * @author Drew Reese
 */
interface I_Capturable {
  public var node(default, null):Node;
  public var totalControlPoints(default, null):Float;
  public var controllingFaction(default, null):FactionType;
  public var capturingFaction(default, null):FactionType;
  public var isControlled(default, null):Bool;
  
  private var currentControlPoints:Float;
  private var captureBar:CaptureBar;
  
  public function capture(captureFaction:FactionType, capturePoints:Float):Void;
  
  private function captured():Void;
  private function lost(capturingFaction:FactionType):Void;
}
