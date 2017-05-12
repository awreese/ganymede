package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import tutorial.CapturingFactionTutorial;

/**
 * ...
 * @author Daisy Xu
 */
class NextLevelState extends FlxState 
{
	private var background:FlxSprite;
	private var congratulationsTxt:FlxText;
	
	override public function create():Void
	{
		Main.LEVEL++;
		// create background
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.nextlevelbg__png);
		add(background);
		
		// create the congradulation text
		congratulationsTxt = new FlxText(0, 20, 0, "Yay!\nYou did it!");
		congratulationsTxt.setFormat("Consola", 40, FlxColor.BLACK);
		congratulationsTxt.alignment = CENTER;
		congratulationsTxt.screenCenter(FlxAxes.XY);
		add(congratulationsTxt);
		
        // Log level end and time
        Main.LOGGER.logLevelEnd(Date.now());
        
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.justPressed) {
			click();
		}
		super.update(elapsed);
	}
	
	// action for clicking replay button
	private function click():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}
