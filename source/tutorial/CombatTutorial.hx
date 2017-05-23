package tutorial;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import gameUnits.Ship;

/**
 * ...
 * @author Daisy Xu
 */
class CombatTutorial extends FlxState 
{
	private var background:FlxSprite;
	private var timer:Float;
	private var switchImage:Bool;
	private var playerShip:FlxButton;
	private var enemyShip:FlxSprite;
	private var cursor:FlxSprite;
	private var mouse:FlxSprite;
	private var cursorInPlace:Bool;
	private var moveRight:Bool;
	private var moveShip:Bool;
	private var enemyPlanet:FlxSprite;
	private var waitTimer:Float;
	private var captureBar:FlxBar;
	private var shipInPlace:Bool;
	private var combatTxt:FlxText;
	
	override public function create():Void
	{
		// create and add the background image
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.combat_tutorial__png);
		add(background);
		
		timer = 0.0;
		waitTimer = 0.0;
		
		// create enemy planet
		enemyPlanet = new FlxSprite(955, 344 + 16);
		enemyPlanet.loadGraphic(AssetPaths.planet_1_enemy1__png, false, 32, 32);
		enemyPlanet.x -= enemyPlanet.origin.x;
		enemyPlanet.y -= enemyPlanet.origin.y;
		add(enemyPlanet);
		
		// create ship button
		playerShip = new FlxButton(472+16, 344+16, "", clickShip);
		playerShip.loadGraphic(AssetPaths.ship_1_player__png, false, 32, 32);
		playerShip.x -= playerShip.origin.x;
		playerShip.y -= playerShip.origin.y;
		playerShip.scrollFactor.set(1, 1);
		add(playerShip);
		
		// create cursor sprite
		cursor = new FlxSprite(playerShip.x + 40, playerShip.y + 40);
		cursor.loadGraphic(AssetPaths.cursor__png, false, 22, 32);
		add(cursor);
		
		// create enemy ship
		enemyShip = new FlxSprite(955 + 16 + 16, 344 + 16);
		enemyShip.loadGraphic(AssetPaths.ship_1_enemy1__png, false, 32, 32);
		enemyShip.x -= enemyShip.origin.x;
		enemyShip.y -= enemyShip.origin.y;
		enemyShip.angle = enemyShip.angle + 180;
		add(enemyShip);
		
		// create mouse
		mouse = new FlxSprite(0, 0);
		mouse.loadGraphic(AssetPaths.mouse_left__png, false, 92, 141);
		mouse.x = playerShip.x - mouse.width / 2;
		mouse.y = playerShip.y + playerShip.height + cursor.height / 2 + 10;
		mouse.visible = false;
		add(mouse);
		
		// create capture bar
		captureBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 50, 10, null, "", 0, 100, true);
		captureBar.x = enemyPlanet.x;
		captureBar.y = enemyPlanet.y + enemyPlanet.height + 2;
		captureBar.createColoredFilledBar(FlxColor.RED, true);
		captureBar.visible = false;
		captureBar.value = 100;
		add(captureBar);
		
		// create the combat text
		combatTxt = new FlxText(0, 0, 0, "Combat");
		combatTxt.setFormat("Consola", 25);
		combatTxt.x = captureBar.x - combatTxt.width / 4;
		combatTxt.y = captureBar.y + 15;
		combatTxt.visible = false;
		add(combatTxt);
		
		switchImage = true;
		cursorInPlace = false;
		moveRight = false;
		
		// zoom in
		FlxG.camera.focusOn(new FlxPoint(713, 344));
		FlxG.camera.zoom = FlxG.height / 420;
		
		// Log level start and time
        Main.LOGGER.logLevelStart(Main.LEVEL, Date.now());
		
		super.create();
	}
	
	/**
	 * flip mouse image
	 */
	private function flipImage():Void {
		if (switchImage) {
			mouse.loadGraphic(AssetPaths.mouse__png, false, 92, 141);
			switchImage = false;
		} else if (cursor.x < enemyPlanet.x + enemyPlanet.width / 2) {
			mouse.loadGraphic(AssetPaths.mouse_left__png, false, 92, 141);
			switchImage = true;
		} else {
			mouse.loadGraphic(AssetPaths.mouse_right__png, false, 92, 141);
			switchImage = true;
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (waitTimer < 0.75) {
			waitTimer += elapsed;
			return;
		}
		if (!cursorInPlace && !moveRight) {
			// moves the cursor
			cursor.x -= 45 * elapsed;
			cursor.y -= 45 * elapsed;
			if (cursor.x <= playerShip.x + (playerShip.width / 2)) {
				cursorInPlace = true;
				mouse.visible = true;
			}
		} else if (!cursorInPlace && moveRight) {
			cursor.x += 200 * elapsed;
			if (cursor.x >= enemyPlanet.x + enemyPlanet.width / 2) {
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
			if (moveShip && playerShip.x < enemyPlanet.x + enemyPlanet.width / 2) {
				playerShip.x += 150 * elapsed;
			}
		}
		
		if (FlxG.mouse.justPressedRight) {
			// if pressed right on/near enemy planet, move ship and stuff
			var mousePos = FlxG.mouse.getPosition();
			var dist = mousePos.distanceTo(new FlxPoint(enemyPlanet.x + enemyPlanet.width / 2, enemyPlanet.y + enemyPlanet.height / 2));
			if (dist <= 45) {
				click();
			}
		}
		
		if (!enemyShip.visible) {
			// if destroyed enemy ship, start capturing
			if (captureBar.color == FlxColor.RED) {
				// if bar is red, decrease value
				captureBar.value -= 20 * elapsed;
				if (captureBar.value <= 0.0) {
					enemyPlanet.loadGraphic(AssetPaths.planet_1_none__png, false, 32, 32);
					// if emptied the bar, set the bar to fill with blue
					captureBar.createColoredFilledBar(FlxColor.BLUE, true);
					captureBar.value = 0;
				}
			} else {
				// if bar is blue, increase value
				captureBar.value += 20 * elapsed;
			}
		}
	}
	
	private function clickShip():Void {
		moveRight = true;
		cursorInPlace = false;
		mouse.visible = false;
		mouse.loadGraphic(AssetPaths.mouse_right__png, false, 92, 141);
		mouse.x = enemyPlanet.x - mouse.width / 4;
		mouse.y = enemyPlanet.y + enemyPlanet.height + 27;
		// change sprite for player ship
		playerShip.x += playerShip.origin.x;
		playerShip.y += playerShip.origin.y;
		playerShip.loadGraphic(AssetPaths.ship_1_player_selected__png, false, 32, 32);
		playerShip.x -= playerShip.origin.x;
		playerShip.y -= playerShip.origin.y;
	}
	
	private function click():Void {
		// change sprite for player ship
		playerShip.x += playerShip.origin.x;
		playerShip.y += playerShip.origin.y;
		playerShip.loadGraphic(AssetPaths.ship_1_player__png, false, 32, 32);
		playerShip.x -= playerShip.origin.x;
		playerShip.y -= playerShip.origin.y;
		cursor.visible = false;
		mouse.visible = false;
		cursorInPlace = true;
		moveShip = true;
	}
}