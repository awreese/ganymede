package com.ganymede;

import flixel.FlxGame;
import flixel.math.FlxRandom;
import openfl.display.Sprite;
import com.ganymede.tutorial.FinishGameState;

import com.ganymede.CapstoneLogger;
import com.ganymede.db.Ganymede;

class Main extends Sprite {

  public static var LOGGER:CapstoneLogger;
  public static var LEVEL:Int;
  public static inline var FINAL_LEVEL:Int = 10;
  public static var RESTART:Bool = false;

  public static var AB_TEST:Array<String> = ["A", "B"];
  public static var AB_VERSION:String;

  public function new() {
    // This code prevents right-click from opening a menu
    #if js
    untyped {
      document.oncontextmenu = document.body.oncontextmenu = function() {
        return false;
      }
    }
    #end

    super();

    LEVEL = 1;

    //AB_VERSION = new FlxRandom().getObject(AB_TEST);
    AB_VERSION = AB_TEST[0]; // force version A for now

    // connect to database
    //#if js
    //Data.load(haxe.Resource.getString(AssetPaths.ganymedeDB__cdb));
    //#else
    //Data.load(null));
    //#end
    ////trace("Lich", Data.myDB.get(Lich));
    //trace("factions", Data.factions.get(PLAYER).color);
    //trace("factions", Data.factions.resolve('PLAYER').faction);
    //trace(Data.levels.all[0]);
    //trace(Data.levels.all[0].planets);

    //GanymedeDB.connect();
    //GanymedeDB.levelByIndex(0);
    
    //var res = Ganymede.levelByIndex(0);
    //trace(res);

    // get the logger up
    var gameId:Int = 1702;
    var gameKey:String = "5e1bd5047e378b5fd4912760004f80f4";
    var gameName:String = "astrorush";
    var categoryId:Int = 1;
    var versionID:Int = 1;
    Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, versionID, false);

    // Retrieve the user (saved in local storage for later)
    var userId:String = Main.LOGGER.getSavedUserId();
    if (userId == null) {
      userId = Main.LOGGER.generateUuid();
      Main.LOGGER.setSavedUserId(userId);
    }
    Main.LOGGER.startNewSession(userId, this.onSessionReady);
  }

  private function onSessionReady(sessionRecieved:Bool):Void {
    addChild(new FlxGame(1280, 720, MenuState, 1, 60, 60));
  }
}
