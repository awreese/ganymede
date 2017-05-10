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

import flixel.util.FlxColor;

/**
 * This enumeration represents the controllable factions in the game.
 * 
 * @author Drew Reese
 */
enum FactionType {
	NOP;
	PLAYER;
	NEUTRAL;
	ENEMY_1;
	ENEMY_2;
	ENEMY_3;
	ENEMY_4;
	ENEMY_5;
	ENEMY_6;
}

/**
 * Faction class represents the existing factions in the game.
 * Game assets that can be controlled/possessed will have some controlling 
 * faction assigned to it.
 * 
 * @author Drew Reese
 */
class Faction {
	// maps faction type to faction color
	private static var faction_color:Map<FactionType, FlxColor>;
    private static var faction_count:Int;

	// initializes faction color mapping
	static function __init__() {
		faction_color = new Map<FactionType, FlxColor>();
		faction_color.set(FactionType.NOP, FlxColor.WHITE);
		faction_color.set(FactionType.PLAYER, FlxColor.BLUE);
		faction_color.set(FactionType.NEUTRAL, FlxColor.GREEN);
		faction_color.set(FactionType.ENEMY_1, FlxColor.RED);
		faction_color.set(FactionType.ENEMY_2, FlxColor.ORANGE);
		faction_color.set(FactionType.ENEMY_3, FlxColor.YELLOW);
		faction_color.set(FactionType.ENEMY_4, FlxColor.PINK);
		faction_color.set(FactionType.ENEMY_5, FlxColor.MAGENTA);
		faction_color.set(FactionType.ENEMY_6, FlxColor.CYAN);
        faction_count = Lambda.count(faction_color);
		trace("faction & color: " + faction_color);
        trace("faction count: " + faction_count);
	}
    
    /**
     * Returns an array of FactionType Enums.
     * @return array of FactionType
     */
    public static function getEnums():Array<FactionType> {
        return Type.allEnums(FactionType);
    }
    
    /**
     * Returns the count of FactionType Enums.
     * @return count of FactionType
     */
    public static function count():Int {
        return faction_count;
    }
	
	var _faction: FactionType;
	
	/**
	 * Creates new faction object.
	 * @param	faction of new faction object
	 */
	public function new(faction:FactionType) {
		this._faction = (faction == null) ? NOP : faction;
	}
	
	/**
	 * Sets the faction type of this faction.
	 * @param	faction to set this faction to
	 */
	public function setFaction(faction:FactionType): Void {
		this._faction = (faction == null) ? NOP : faction;
	}
	
	/**
	 * Gets the faction type of this faction.
	 * @return	FactionType of this faction
	 */
	public function getFaction():FactionType {
		return this._faction;
	}
	
	/**
	 * Returns the color of this faction.
	 * @return	FlxColor of this faction
	 */
	public function getColor(): FlxColor {
		return faction_color.get(this._faction);
	}
	
}
