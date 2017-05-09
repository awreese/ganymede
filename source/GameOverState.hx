package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

/**
 * ...
 * @author Daisy Xu
 */
class GameOverState extends FlxState 
{
	private var gameoverTxt:FlxText;
	private var replayBtn:FlxButton;
	
	override public function create():Void
	{
		// create the GameOver text
		gameoverTxt = new FlxText(0, (FlxG.height / 2) - 20, 0, "GAME OVER");
		gameoverTxt.setFormat("Consola", 40);
		gameoverTxt.alignment = CENTER;
		gameoverTxt.screenCenter(FlxAxes.X);
		add(gameoverTxt);
		
		// create and add replay button
		replayBtn = new FlxButton(0, 0, "Replay", clickReplay);
		replayBtn.x = (FlxG.width / 2) - (replayBtn.width / 2);
		replayBtn.y = (FlxG.height / 2) + replayBtn.height + 10;
		add(replayBtn);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	// action for clicking replay button
	private function clickReplay():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}