package com.ganymede.npc;

import com.ganymede.faction.Faction;
import com.ganymede.faction.Faction.FactionType;
import flixel.FlxBasic;

/**
 * ...
 * @author Daisy Xu
 */
class NPC extends FlxBasic
{
	private var faction: FactionType;
	
	public function new(faction: FactionType) {
		super();
		this.faction = faction;
	}
	
	/**
	 * get faction of this
	 */
	public function getFaction() {
		return this.faction;
	}
}