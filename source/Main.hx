package;

import flixel.FlxGame;
import CapstoneLogger;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var LOGGER: CapstoneLogger;
	public function new()
	{
		// This code prevents right-click from opening a menu
		#if js
		untyped
		{
			document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
		}
		#end
		
		super();
		
		// get the logger up
		var gameId:Int = 1072;
		var gameKey:String = "5e1bd5047e378b5fd4912760004f80f4";
		var gameName:String = "astrorush";
		var categoryId:Int = 1;
		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, 1, true);
		
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
		addChild(new FlxGame(0, 0, MenuState, 1, 60, 60));
	}
}