package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author Daisy Xu
 */
class MovingShipTutorial extends FlxState {
	private var background:FlxSprite;
	private var timer:Float;
	private var switchImage:Bool;
	private var ship:FlxSprite;
	private var cursor:FlxSprite;
	private var mouse:FlxSprite;
	private var cursorInPlace:Bool;
	private var nop:FlxSprite;
	private var captureBar:FlxBar;
	private var shipInPlace:Bool;
	private var waitTimer:Float;
	
	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.select_ship_tutorial__png);
		add(background);
		
		timer = 0.0;
		waitTimer = 0.0;
		
		// create nop planet
		nop = new FlxSprite(406, 220);
		nop.loadGraphic(AssetPaths.uncontrolled_planet_1__png, false, 32, 32);
		add(nop);
		
		// create ship
		ship = new FlxSprite(166, 220);
		ship.loadGraphic(AssetPaths.ship_1_selected__png, false, 32, 32);
		add(ship);
		
		// create cursor
		cursor = new FlxSprite(ship.x + ship.width / 2, ship.y + ship.height / 2);
		cursor.loadGraphic(AssetPaths.cursor__png, false, 22, 32);
		add(cursor);
		
		// create mouse
		mouse = new FlxSprite(0, 0);
		mouse.loadGraphic(AssetPaths.mouse_right__png, false, 92, 141);
		mouse.x = FlxG.width - mouse.width - 20;
		mouse.y = FlxG.height - mouse.height - 10;
		mouse.visible = false;
		add(mouse);
		
		// create capture bar
		captureBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 50, 10, null, "", 0, 100, true);
		captureBar.x = nop.x - (nop.width / 4);
		captureBar.y = nop.y + nop.height + 2;
		captureBar.createColoredFilledBar(FlxColor.BLUE, true);
		captureBar.visible = false;
		captureBar.value = 0;
		add(captureBar);
		
		switchImage = true;
		cursorInPlace = false;
		shipInPlace = true;
		
		super.create();
	}
	
	// flip the image of the mouse click
	private function flipImage():Void {
		if (switchImage) {
			mouse.loadGraphic(AssetPaths.mouse__png, false, 92, 141);
			switchImage = false;
		} else {
			mouse.loadGraphic(AssetPaths.mouse_right__png, false, 92, 141);
			switchImage = true;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!shipInPlace && waitTimer < 0.5) {
			// wait before animation plays
			waitTimer += elapsed;
			return;
		}
		if (captureBar.visible) {
			// move capture bar
			captureBar.value += 20 * elapsed;
			if (captureBar.value == 100.0) {
				nop.loadGraphic(AssetPaths.player_planet_1__png, false, 32, 32);
				waitTimer += elapsed;
			}
		}
		if (!shipInPlace) {
			// move the ship to nop planet
			ship.x += 75 * elapsed;
			if (ship.x >= nop.x) {
				shipInPlace = true;
				captureBar.visible = true;
				waitTimer = 0.0;
			}
		}
		if (!cursorInPlace) {
			// move cursor
			cursor.x += 100 * elapsed;
			if (cursor.x >= nop.x + nop.width / 2) {

				cursorInPlace = true;
				mouse.visible = true;
			}
		} else {
			// flip mouse image
			timer += elapsed;
			if (timer >= 0.75) {
				flipImage();
				timer = 0.0;
			}
		}
		
		if (FlxG.mouse.justPressedRight) {
			// if pressed right on/near nop planet, move ship and stuff
			var mousePos = FlxG.mouse.getPosition();
			var dist = mousePos.distanceTo(new FlxPoint(nop.x + nop.width / 2, nop.y + nop.height / 2));
			if (dist <= 15) {
				click();
			}
		}
		
		if (captureBar.value >= 100.0 && waitTimer >= 0.75) {
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new NextLevelState());
		});
		}
	}
	
	private function click():Void {
		ship.loadGraphic(AssetPaths.ship_1__png, false, 32, 32);
		shipInPlace = false;
		cursor.visible = false;
		mouse.visible = false;
		cursorInPlace = true;
	}
}