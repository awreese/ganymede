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
 * @author Daisy
 */
class MenuState extends FlxState
{

	private var title:FlxText;
	private var playBtn:FlxButton;
	private var background:FlxSprite;

	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.tempmenubg__png);
		add(background);
		
		// create and add the title
		title = new FlxText(0, 20, 0, "AstroRush: TBD");
		title.setFormat("Consola", 22);
		title.alignment = CENTER;
		title.screenCenter(FlxAxes.X);
		add(title);
		
		// create and add play button
		playBtn = new FlxButton(0, 0, "Play", clickPlay);
		playBtn.x = (FlxG.width / 2) - (playBtn.width/ 2);
		playBtn.y = FlxG.height / 2;
		add(playBtn);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickPlay():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
}