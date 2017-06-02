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
import tutorial.SelectShipTutorial;

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
	private var replayBtn:FlxButton;
	private var nextLevelBtn:FlxButton;
	
	override public function create():Void
	{		
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
		
		// create and add replay button
		replayBtn = new FlxButton(0, 0, "", clickReplay);
		replayBtn.loadGraphic(AssetPaths.replay_btn__png, false, 176, 78);
		replayBtn.x = (FlxG.width / 2) - replayBtn.width * 1.5;
		replayBtn.y = (FlxG.height) - 2 * replayBtn.height;
		add(replayBtn);
		
		// create and add next level button
		nextLevelBtn = new FlxButton(0, 0, "", clickNextLevel);
		nextLevelBtn.loadGraphic(AssetPaths.nextlevel_btn__png, false, 176, 78);
		nextLevelBtn.x = (FlxG.width / 2) + nextLevelBtn.width / 2;
		nextLevelBtn.y = (FlxG.height) - 2 * nextLevelBtn.height;
		add(nextLevelBtn);
		
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
		super.update(elapsed);
	}
	
	// action for clicking replay button
	private function clickReplay():Void {
		if (Main.LEVEL == 2 && !Main.RESTART) {
			Main.LEVEL = 1; // decrement level back to one if tutorial
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new SelectShipTutorial());
			});
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
	
	// action for clicking next level button
	private function clickNextLevel():Void {
		Main.LEVEL++;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}
