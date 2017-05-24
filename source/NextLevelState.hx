package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
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
	private var foreground:FlxSprite;
	private var congratulationsTxt:FlxText;
	private var background:FlxSprite;
	private var applauseSnd:FlxSound;
	
	override public function create():Void
	{
		Main.LEVEL++;
		
		// load sound effect
		#if flash
			applauseSnd = FlxG.sound.load(AssetPaths.applause__mp3);
		#else
			applauseSnd = FlxG.sound.load(AssetPaths.applause__wav);
		#end
		
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
		congratulationsTxt.setFormat("Consola", 60, FlxColor.BLACK);
		congratulationsTxt.alignment = CENTER;
		congratulationsTxt.screenCenter(FlxAxes.XY);
		add(congratulationsTxt);
		
        // Log level end and time
        Main.LOGGER.logLevelEnd({victory: true});
        
		super.create();
		applauseSnd.play();
	}

	override public function update(elapsed:Float):Void
	{
		if (foreground.y < 0.0) {
			foreground.y += 400 * elapsed;
		}
		if (FlxG.mouse.justPressed) {
			click();
		}
		super.update(elapsed);
	}
	
	// action for clicking replay button
	private function click():Void {
        //if (Main.LEVEL == 2 && !Main.RESTART) {
  			//FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
                //FlxG.switchState(new CombatTutorial());
            //});
        //}
        
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}
