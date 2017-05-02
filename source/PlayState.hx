package;

import flixel.FlxState;
import map.GameMap;

class PlayState extends FlxState
{
	override public function create():Void
	{
		add(new GameMap());
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}