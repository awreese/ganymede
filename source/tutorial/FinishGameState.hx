package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.net.URLRequest;

/**
 * ...
 * @author Daisy Xu
 */
class FinishGameState extends FlxState
{
	private var text:FlxText;
	private var restartBtn:FlxButton;
	private var background:FlxSprite;
	private var feedbackBtn:FlxButton;

	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.finishgamebg__png);
		add(background);

		// create and add the title
		text = new FlxText(0, 20, 0, "Congratulations!\nYou finished the game!");
		text.setFormat("Consola", 40, FlxColor.BLACK);
		text.alignment = CENTER;
		text.screenCenter(FlxAxes.X);
		add(text);

		// create and add replay button
		restartBtn = new FlxButton(0, 0, "", clickRestart);
		restartBtn.loadGraphic(AssetPaths.replay_btn__png, false, 114, 44);
		restartBtn.x = 20;
		restartBtn.y = FlxG.height - restartBtn.height - 31;
		add(restartBtn);
		
		feedbackBtn = new FlxButton(0, 0, "", clickFeedback);
		feedbackBtn.loadGraphic(AssetPaths.feedback_btn__png, false, 114, 44);
		feedbackBtn.x = FlxG.width - feedbackBtn.width - 20;
		feedbackBtn.y = FlxG.height - restartBtn.height - 31;

		restartBtn = new FlxButton(20, FlxG.height - 75, "", clickRestart);
		restartBtn.loadGraphic(AssetPaths.replay_btn__png);
		add(restartBtn);
		
		feedbackBtn = new FlxButton(FlxG.width - 114 - 20, FlxG.height - 75, "", clickFeedback);
		feedbackBtn.loadGraphic(AssetPaths.feedback_btn__png);
>>>>>>> master
		add(feedbackBtn);

		Main.LEVEL = 1;

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function clickRestart():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(new PlayState());
		});
	}
	
	private function clickFeedback():Void
	{
		openfl.Lib.getURL(new URLRequest("https://goo.gl/forms/6bW2mc7pC7OxQnMy1"));
	}
}