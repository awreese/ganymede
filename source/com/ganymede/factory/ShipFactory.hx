package com.ganymede.factory;

import com.ganymede.faction.Faction.FactionType;
import com.ganymede.gameUnits.ships.HullType;
import com.ganymede.gameUnits.ships.I_Ship;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Drew Reese
 */
class ShipFactory extends FlxTimer {

  private var _lastProducedTime(default, null):Float;
  private var productionCheck(default, null):Void->Bool;
  
  public function new(productionCheck:Void->Bool) {
    this._lastProducedTime = 0.0;
    this.productionCheck = productionCheck;
  }
  
  public function produceShip(hullType:HullType, faction:FactionType):I_Ship {
    this._lastProducedTime += FlxG.elapsed;
  }
  
  private function canProduce():Bool {
    return
  }
  
}
