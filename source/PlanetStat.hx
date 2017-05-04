package;

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
 * Planet statistic type
 * 
 * Planet statistics must be instanitated and passed into constructors
 * for planets.
 * 
 * @author Drew Reese
 */
typedef PlanetStat = {
	// General
	var cap: Int;			// ship capacity
	var prod: Float;		// ship production rate
	var prod_thresh: Float;	// production rate threshold for falloff
	
	// Levels
	var cap_level: Int;		// current capacity level
	var tech_level: Int;	// current tech level
	
	// Upgrades/costs
	var base_cost: Int;		// base upgrade cost in ships
	var cap_per_lvl: Int;	// capacity increase per level
	var tech_per_lvl: Float;	// tech increase per level
	
}