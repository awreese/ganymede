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

package gameUnits.combat;

import flixel.FlxObject;
import gameUnits.Ship;

/**
 * Interface for in-game combatants.
 * @author Drew Reese
 */
interface I_Combatant {
    private var radar:Radar;
    private var sensorRange:Float;
    
    public function getSensorRange():Float;
    public function inSensorRange(object:FlxObject):Bool;
    public function setRadar(ships:Array<Ship>):Void;
    public function selectTarget():I_Combatant;
}