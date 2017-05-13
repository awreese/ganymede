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
	private var foreground:FlxSprite;
	private var congratulationsTxt:FlxText;
	private var background:FlxSprite;
	
	override public function create():Void
	{
		Main.LEVEL++;
		
		// create background
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.whitebg__png);
		add(background);
		
		// create foreground
		foreground = new FlxSprite(0, 0);
		foreground.loadGraphic(AssetPaths.nextlevelbg__png, false, 1280, 922);
		foreground.y = -foreground.height;
		add(foreground);
		
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
		if (foreground.y < 0.0) {
			foreground.y += 300 * elapsed;
		}
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
