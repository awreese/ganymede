package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
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
	private var captureTxt:FlxText;
	
	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.select_ship_tutorial__png);
		add(background);
		
		timer = 0.0;
		waitTimer = 0.0;
		
		// create nop planet
		nop = new FlxSprite(697+16, 344+16);
		nop.loadGraphic(AssetPaths.planet_1_none__png, false, 32, 32);
		nop.x -= nop.origin.x;
		nop.y -= nop.origin.y;
		add(nop);
		
		// create ship
		ship = new FlxSprite(472+16, 344+16);
		ship.loadGraphic(AssetPaths.ship_1_player_selected__png, false, 32, 32);
		ship.x -= ship.origin.x;
		ship.y -= ship.origin.y;
		add(ship);
		
		// create cursor
		cursor = new FlxSprite(ship.x + ship.width / 2, ship.y + ship.height / 2);
		cursor.loadGraphic(AssetPaths.cursor__png, false, 22, 32);
		add(cursor);
		
		// create capture bar
		captureBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 50, 10, null, "", 0, 100, true);
		captureBar.x = nop.x;
		captureBar.y = nop.y + nop.height + 2;
		captureBar.createColoredFilledBar(FlxColor.BLUE, true);
		captureBar.visible = false;
		captureBar.value = 0;
		add(captureBar);
		
		// create the capture text
		captureTxt = new FlxText(0, 0, 0, "Capturing");
		captureTxt.setFormat("Consola", 25);
		captureTxt.x = captureBar.x - captureTxt.width / 4;
		captureTxt.y = captureBar.y + 15;
		captureTxt.visible = false;
		add(captureTxt);
		
		// create mouse
		mouse = new FlxSprite(0, 0);
		mouse.loadGraphic(AssetPaths.mouse_right__png, false, 92, 141);
		mouse.x = nop.x - mouse.width / 4;
		mouse.y = nop.y + nop.height + 27;
		mouse.visible = false;
		add(mouse);
		
		switchImage = true;
		cursorInPlace = false;
		shipInPlace = true;
		
		// zoom in
		FlxG.camera.focusOn(new FlxPoint(592, 438));
		FlxG.camera.zoom = FlxG.height / 320;
		
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
			// flashes capture text
			if (captureBar.value >= 80.0) {
				captureTxt.visible = true;
			} else if (captureBar.value >= 60.0) {
				captureTxt.visible = false;
			} else if (captureBar.value >= 40.0) {
				captureTxt.visible = true;
			} else if (captureBar.value >= 20.0) {
				captureTxt.visible = false;
			}
			if (captureBar.value == 100.0) {
				captureTxt.text = "Captured";
				nop.loadGraphic(AssetPaths.planet_1_player__png, false, 32, 32);
				waitTimer += elapsed;
			}
		}
		if (!shipInPlace) {
			// move the ship to nop planet
			ship.x += 100 * elapsed;
			if (ship.x >= nop.x + nop.width / 4) {
				shipInPlace = true;
				captureBar.visible = true;
				captureTxt.visible = true;
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
			if (dist <= 45) {
				click();
			}
		}
		
		if (captureBar.value >= 100.0 && waitTimer >= 0.75) {
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new CombatTutorial());
		});
		}
	}
	
	private function click():Void {
		ship.x += ship.origin.x;
		ship.y += ship.origin.y;
		ship.loadGraphic(AssetPaths.ship_1_player__png, false, 32, 32);
		ship.x -= ship.origin.x;
		ship.y -= ship.origin.y;
		shipInPlace = false;
		cursor.visible = false;
		mouse.visible = false;
		cursorInPlace = true;
	}
}