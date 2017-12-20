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

package com.ganymede.npc;

import flixel.util.FlxTimer;
import com.ganymede.faction.Faction;

// Type shortcut
private typedef TimerMap_t = Map<FactionType, Timer_t>;

// Stores reference to timer object, expireation level, and aggressed status
private typedef Timer_t = {
    timer:FlxTimer,
    level:Int,
    aggressed:Bool
}

/**
 * AggressionEngine
 * 
 * Global singleton class that stores most permutations of FactionType.
 *      map (faction_i => timer(faction_j))
 *       - such that i != j
 *       - timer(faction_j) is the timer_t representation of faction_j
 *          towards faction_i
 * 
 * @author Drew Reese
 */
private class AggressionEngine {
    
    public static var instance(default, null):AggressionEngine = new AggressionEngine(); // Singleton
    
    public var _timers:Map <Faction, Map<FactionType, Timer_t>>;
    
    /**
     * Creates new aggression engine
     */
    private function new() {
        this._timers = new Map <FactionType, TimerMap_t>();
        
        for (faction in Faction.getEnums) {
            if (faction == NOP || faction == PLAYER) {
                continue;
            }
            
            this._timers.set(faction, new TimerMap_t());
            
            for (opposing in Faction.getEnums) {
                if (faction == opposing) {
                    continue;
                }
                
                this._timers.get(faction).set(opposing, {timer: new FlxTimer(), 0, aggressed: false});
            }
        }
        
    }
    
    /**
     * Returns the aggression timer for opposition against faction.
     * @param faction       - faction being aggressed
     * @param opposition    - aggressing faction
     * @return  Timer_t timer of aggression from opposing faction to faction
     */
    public function getTimer(faction:FactionType, opposition:FactionType): Timer_t {
        return _timers.get(faction).get(opposition);
    }
    
}

/**
 * AggressionTimer
 * 
 * When attacks on a faction are detected, an aggression timer is started.  If at
 * any point before the timer has expired another attack is detected, the timer is 
 * reset and timer starts over.  If no attacks are registered for the duration of 
 * the aggression timer, it cancels automatically and any actions previous 
 * aggressed faction cease.
 * 
 * @author Drew Reese
 */
class AggressionTimer {

    public static inline var AGGRESSION_NEVER:Int = -1;
    public static inline var AGGRESSION_ALWAYS:Int = 1000;
    
    // Stores level-based Timer Expiration
    private static var _expires:Map<Int, Float>;
    
    // initializes aggression levels to a timer expiration in seconds
    static function __init__() {
        _expires = new Map<Int, Float>();
        _expires.set(AGGRESSION_NEVER, 0.0);
        _expires.set(0, 15000.0); // base       = 15 seconds
        _expires.set(1, 25000.0); // base + 10  = 25s
        _expires.set(2, 40000.0); // base + 15  = 40s
        _expires.set(3, 60000.0); // base + 20  = 60s
        _expires.set(4, 90000.0); // base + 30  = 90s
        _expires.set(AGGRESSION_ALWAYS, Math.POSITIVE_INFINITY);
    }
    
    private static var _globalAggressionEngine:AggressionEngine = AggressionEngine.instance();
    private var _faction:FactionType;
    
    /**
     * Creates new global aggression timer for specified faction
     * @param faction   - faction for this timer
     */
    public function new(faction:FactionType) {
        this._faction = faction;
    }
    
    /**
     * Returns timer between this and opposing factions
     * @param opposing  - opposing faction
     * @return timer between this and opposing factions
     */
    private function getTimer(opposing:FactionType):Timer_t {
        return _globalAggressionEngine.getTimer(this._faction, opposing);
    }
    
    /**
     * Starts timer between this and opposing factions.
     * @param opposing  - aggressing faction
     * @param level     - expiration level for timer
     */
    public function start(opposing:FactionType, level:Int) {
        if (opposing == this._faction) {
            return;
        }
        
        var timer:Timer_t = getTimer(opposing);
        
        if (timer.aggressed) {
            // timer already active... reset
            timer.timer.reset(_expires.get(timer.level));
        } else {
            // start new timer
            timer.aggressed = true;
            timer.level = level;
            
            timer.timer.start(_expires.get(timer.level), function() { expired(faction); }, 1);
            
        }
        
    }
    
    /**
     * Cancels aggression between this and opposing factions
     * @param opposing  - aggressing faction
     */
    private function expired(opposing:FactionType) {
        if (opposing == this._faction) {
            return;
        }
        getTimer(opposing).aggressed = false;
    }
    
    /**
     * Returns the time remaining between this and aggressing factions.
     * @param opposing  - aggressing faction
     * @return  time remaining on this timer
     */
    public function getTimeLeft(opposing:FactionType):Float {
        return getTimer(opposing).timer.timeLeft;
    }
    
    /**
     * Returns [true|false] if the timer between this and aggressing
     * faction has expired.
     * @param opposing  - aggressing faction
     * @return  true iff this timer has expired
     */
    public function isExpired(opposing:FactionType):Bool {
        return getTimer(opposing).timer.finished;
    }
    
}
