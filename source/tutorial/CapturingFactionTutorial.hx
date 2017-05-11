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
class CapturingFactionTutorial extends FlxState 
{
	private var background:FlxSprite;
	private var congratulationsTxt:FlxText;
	
	override public function create():Void
	{
		// create background
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.capturing_faction_tutorial__png);
		add(background);
        
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.justPressed) {
			click();
		}
		super.update(elapsed);
	}
	
	// action for clicking continue button
	private function click():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}