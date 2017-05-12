package tutorial;

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
class FinishGameState extends FlxState
{
	private var text:FlxText;
	private var restartBtn:FlxButton;
	private var background:FlxSprite;

	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.tempmenubg__png);
		add(background);

		// create and add the title
		text = new FlxText(0, 20, 0, "Congratulations!\nYou finished the game!");
		text.setFormat("Consola", 22);
		text.alignment = CENTER;
		text.screenCenter(FlxAxes.X);
		add(text);

		// create and add play button
		restartBtn = new FlxButton(0, 0, "Restart", clickRestart);
		restartBtn.x = (FlxG.width / 2) - (restartBtn.width/ 2);
		restartBtn.y = FlxG.height - restartBtn.height - 10;
		add(restartBtn);

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
}