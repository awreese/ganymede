package;

import flixel.FlxGame;
import CapstoneLogger;
import flixel.math.FlxRandom;
import openfl.display.Sprite;
import tutorial.FinishGameState;

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
		untyped
		{
			document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
		}
		#end
		
		super();
		
        LEVEL = 1;
        
        AB_VERSION = new FlxRandom().getObject(AB_TEST);
        
		// get the logger up
		var gameId:Int = 1702;
		var gameKey:String = "5e1bd5047e378b5fd4912760004f80f4";
		var gameName:String = "astrorush";
		var categoryId:Int = 1;
		var versionID:Int = 1;
		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, versionID, false);
		
		// Retrieve the user (saved in local storage for later)
		var userId:String = Main.LOGGER.getSavedUserId();
		if (userId == null)
		{
			userId = Main.LOGGER.generateUuid();
			Main.LOGGER.setSavedUserId(userId);
		}
		Main.LOGGER.startNewSession(userId, this.onSessionReady);
	}
	
	private function onSessionReady(sessionRecieved:Bool):Void
	{
		addChild(new FlxGame(1280, 720, MenuState, 1, 60, 60));
	}
}
