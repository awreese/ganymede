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
	private var timer:Float;
	private var switchImage:Bool;
	private var shipBtn:FlxButton;
	private var cursor:FlxSprite;
	private var mouse:FlxSprite;
	private var cursorInPlace:Bool;
	private var nop:FlxSprite;
	private var waitTimer:Float;
	
	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.select_ship_tutorial__png);
		add(background);
		
		timer = 0.0;
		waitTimer = 0.0;
		
		// create ship button
		shipBtn = new FlxButton(166, 220, "", clickShip);
		shipBtn.loadGraphic(AssetPaths.ship_1__png, false, 32, 32);
		add(shipBtn);
		
		// create cursor sprite
<<<<<<< HEAD
		cursor = new FlxSprite(shipBtn.x + 41, shipBtn.y + 41);
=======
		cursor = new FlxSprite(207, 261);
>>>>>>> master
		cursor.loadGraphic(AssetPaths.cursor__png, false, 22, 32);
		add(cursor);
		
		// create nop planet
		nop = new FlxSprite(406, 220);
		nop.loadGraphic(AssetPaths.uncontrolled_planet_1__png, false, 32, 32);
		add(nop);
		
		// create mouse
<<<<<<< HEAD
		mouse = new FlxSprite(0, 0);
		mouse.loadGraphic(AssetPaths.mouse_left__png, false, 92, 141);
		mouse.x = FlxG.width - mouse.width - 20;
		mouse.y = FlxG.height - mouse.height - 10;
=======
		mouse = new FlxSprite(FlxG.width - 112, FlxG.height - 151);
		mouse.loadGraphic(AssetPaths.mouse_left__png, false, 92, 141);
>>>>>>> master
		mouse.visible = false;
		add(mouse);
		
		switchImage = true;
		cursorInPlace = false;
		
		super.create();
	}
	
	/**
	 * flip between left click and regular mouse
	 */
	private function flipImage():Void {
		if (switchImage) {
			mouse.loadGraphic(AssetPaths.mouse__png, false, 92, 141);
			switchImage = false;
		} else {
			mouse.loadGraphic(AssetPaths.mouse_left__png, false, 92, 141);
			switchImage = true;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (waitTimer < 0.75) {
			waitTimer += elapsed;
			return;
		}
		if (!cursorInPlace) {
			// moves the cursor
			cursor.x -= 45 * elapsed;
			cursor.y -= 45 * elapsed;
			if (cursor.x <= shipBtn.x + (shipBtn.width / 2)) {
				cursorInPlace = true;
				mouse.visible = true;
			}
		} else {
			// check if time to switch mouse image
			timer += elapsed;
			if (timer >= 0.75) {
				flipImage();
				timer = 0.0;
			}
		}
	}
	
	private function clickShip():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new MovingShipTutorial());
		});
	}
	
}
