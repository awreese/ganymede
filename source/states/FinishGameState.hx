package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
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
	private var applauseSnd:FlxSound;

	override public function create():Void
	{
		// load sound effect
		#if flash
			applauseSnd = FlxG.sound.load(AssetPaths.applause__mp3);
		#else
			applauseSnd = FlxG.sound.load(AssetPaths.applause__wav);
		#end
		
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.finishgamebg__png);
		add(background);

		// create and add the title
		text = new FlxText(0, 20, 0, "Congratulations!\nYou finished the game!");
		text.setFormat("Consola", 50, FlxColor.BLACK);
		text.alignment = CENTER;
		text.screenCenter(FlxAxes.X);
		add(text);

		// create and add replay button
		restartBtn = new FlxButton(0, 0, "", clickRestart);
		restartBtn.loadGraphic(AssetPaths.restart_btn__png, false, 232, 103);
		restartBtn.x = 80;
		restartBtn.y = FlxG.height - restartBtn.height - 40;
		add(restartBtn);
		
		feedbackBtn = new FlxButton(0, 0, "", clickFeedback);
		feedbackBtn.loadGraphic(AssetPaths.feedback_btn__png, false, 232, 103);
		feedbackBtn.x = FlxG.width - feedbackBtn.width - 80;
		feedbackBtn.y = FlxG.height - restartBtn.height - 40;
		add(feedbackBtn);

		Main.LEVEL = 1;
		
		// Log level end and time
		var details = new Dynamic();
		details.time = Date.now();
		details.victory = true;
        Main.LOGGER.logLevelEnd(details);

		super.create();
		applauseSnd.play();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function clickRestart():Void
	{
		Main.RESTART = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(new states.PlayState());
		});
	}
	
	private function clickFeedback():Void
	{
		openfl.Lib.getURL(new URLRequest("https://goo.gl/forms/6bW2mc7pC7OxQnMy1"));
	}
}