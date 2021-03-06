package;

import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
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
	private var gameover:FlxSprite;
	private var replayBtn:FlxButton;
	
	override public function create():Void
	{
		// create the GameOver text
		gameover = new FlxSprite();
		gameover.loadGraphic(AssetPaths.gameover__png);
		add(gameover);
		
		// create and add replay button
		replayBtn = new FlxButton(0, 0, "", clickReplay);
		replayBtn.loadGraphic(AssetPaths.replay_btn__png, false, 176, 78);
		replayBtn.x = (FlxG.width / 2) - replayBtn.width + 10;
		replayBtn.y = (FlxG.height) - 2 * replayBtn.height - 60;
		add(replayBtn);
		
		// Log level end and time
        Main.LOGGER.logLevelEnd({victory: false});
		
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
