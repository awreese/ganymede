package;

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
class NextLevelState extends FlxState 
{
	private var background:FlxSprite;
	private var congratulationsTxt:FlxText;
	private var nextLevelBtn:FlxButton;
	
	override public function create():Void
	{
		
		// create background
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.nextlevelbg__png);
		add(background);
		
		// create the congradulation text
		congratulationsTxt = new FlxText(0, 20, 0, "Congratulations!\nYou Won!");
		congratulationsTxt.setFormat("Consola", 40, FlxColor.BLACK);
		congratulationsTxt.alignment = CENTER;
		congratulationsTxt.screenCenter(FlxAxes.X);
		add(congratulationsTxt);
		
		// create and add replay button
		nextLevelBtn = new FlxButton(0, 0, "Next Level", clickNextLevel);
		nextLevelBtn.x = (FlxG.width / 2) - (nextLevelBtn.width / 2);
		nextLevelBtn.y = (FlxG.height / 2) + nextLevelBtn.height + 10;
		add(nextLevelBtn);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	// action for clicking replay button
	private function clickNextLevel():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}