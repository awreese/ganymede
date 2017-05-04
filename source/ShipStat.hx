package;
import flixel.math.FlxVector;

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

/**
 * Ship statistic type.
 * 
 * @author Drew Reese
 */
typedef ShipStat = {
	// General
	var pos: FlxVector;	// position
	var vel: Float;		// velocity
	
	// Defense
	var sh: Float;		// shields
	var hp: Int;		// hitpoints
	
	// Offense
	var as: Float;		// attack speed
	var ap: Float;		// attack power
	var cp: Float;		// capture power/rate
}