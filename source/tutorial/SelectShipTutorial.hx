package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
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
		shipBtn = new FlxButton(472+16, 344+16, "", clickShip);
		shipBtn.loadGraphic(AssetPaths.ship_1_player__png, false, 32, 32);
		shipBtn.x -= shipBtn.origin.x;
		shipBtn.y -= shipBtn.origin.y;
		shipBtn.scrollFactor.set(1, 1);
		add(shipBtn);
		
		// create cursor sprite
		cursor = new FlxSprite(shipBtn.x + 40, shipBtn.y + 40);
		cursor.loadGraphic(AssetPaths.cursor__png, false, 22, 32);
		add(cursor);
		
		// create nop planet
		nop = new FlxSprite(697+16, 344+16);
		nop.loadGraphic(AssetPaths.planet_1_none__png, false, 32, 32);
		nop.x -= nop.origin.x;
		nop.y -= nop.origin.y;
		add(nop);
		
		// create mouse
		mouse = new FlxSprite(0, 0);
		mouse.loadGraphic(AssetPaths.mouse_left__png, false, 92, 141);
		mouse.x = shipBtn.x - mouse.width / 4;
		mouse.y = shipBtn.y + shipBtn.height + cursor.height / 2 + 10;
		mouse.visible = false;
		add(mouse);
		
		switchImage = true;
		cursorInPlace = false;
		
		// zoom in
		FlxG.camera.focusOn(new FlxPoint(592, 438));
		FlxG.camera.zoom = FlxG.height / 320;
		
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

	override public function update(elapsed:Float):Void {
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
