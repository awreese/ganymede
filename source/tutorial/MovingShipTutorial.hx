package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author Daisy Xu
 */
class MovingShipTutorial extends FlxState {
	private var background:FlxSprite;
	private var continueBtn:FlxButton;
	private var timer:Float;
	private var switchImage:Bool;
	
	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.moving_ship_tutorial_2__png);
		add(background);
		
		// create and add exit button
		continueBtn = new FlxButton(0, 0, "Continue", clickContinue);
		continueBtn.x = FlxG.width - continueBtn.width - 10;
		continueBtn.y = FlxG.height - continueBtn.height - 10;
		add(continueBtn);
		
		switchImage = true;
		
		super.create();
	}
	
	private function flipImage():Void {
		if (switchImage) {
			background.loadGraphic(AssetPaths.moving_ship_tutorial_1__png);
			switchImage = false;
		} else {
			background.loadGraphic(AssetPaths.moving_ship_tutorial_2__png);
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
	
	private function clickContinue():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}