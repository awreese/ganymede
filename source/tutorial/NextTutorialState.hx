package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import tutorial.CombatTutorial;

/**
 * ...
 * @author Daisy Xu
 */
class NextTutorialState extends FlxState 
{
	private var foreground:FlxSprite;
	private var congratulationsTxt:FlxText;
	private var background:FlxSprite;
	private var applauseSnd:FlxSound;
	private var waitTime:Float;
	
	override public function create():Void
	{
		Main.LEVEL++;
		waitTime = 0.0;
		
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
		foreground.loadGraphic(AssetPaths.confetti__png, false, 1280, 720);
		foreground.y = -foreground.height;
		add(foreground);
		
		// create the congradulation text
		congratulationsTxt = new FlxText(0, 20, 0, "Good job!");
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
		if (foreground.y >= 0.0) {
			waitTime += elapsed;
		}
		if (waitTime >= 3.0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new CombatTutorial());
		}
		super.update(elapsed);
	}
}
