package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Daisy Xu
 */
class SelectShipTutorial extends FlxState 
{
	private var background:FlxSprite;
	private var nextBtn:FlxButton;
	private var timer:Float;
	private var switchImage:Bool;
	
	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.select_ship_tutorial_1__png);
		add(background);
		
		// create and add exit button
		nextBtn = new FlxButton(0, 0, "Next", clickNext);
		nextBtn.x = FlxG.width - nextBtn.width - 10;
		nextBtn.y = FlxG.height - nextBtn.height - 10;
		add(nextBtn);
		
		switchImage = false;
		
		super.create();
	}
	
	private function flipImage():Void {
		if (switchImage) {
			background.loadGraphic(AssetPaths.select_ship_tutorial_1__png);
			switchImage = false;
		} else {
			background.loadGraphic(AssetPaths.select_ship_tutorial_2__png);
			switchImage = true;
		}
	}

	override public function update(elapsed:Float):Void
	{
		timer += elapsed;
		if (timer >= 0.75) {
			flipImage();
			timer = 0.0;
		}
		super.update(elapsed);
	}
	
	private function clickNext():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new MovingShipTutorial());
		});
	}
	
}