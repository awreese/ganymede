package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
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
		addChild(new FlxGame(0, 0, PlayState));
	}
}