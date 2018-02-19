package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import gameUnits.capturable.Planet;
import faction.Faction.FactionType;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
/**
 * ...
 * @author Daisy Xu
 */
class UpgradeHUD extends FlxTypedGroup<FlxSprite>
{
	public var planet:Planet; // will pass in planet player wants to upgrade
	
	private var _screen:FlxSprite; // screen for displaying the upgrade screen
	
	private var _bgSprite:FlxSprite; // background sprite
	
	private var _alpha:Float = 0; // use to fade in and out of hud
	
	private var closeButton: FlxButton; // button to click when want to close hub
	
	public function new() 
	{
		super();
		
		// create new screen
		_screen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		
		// create background
		_bgSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_bgSprite.screenCenter();
		add(_bgSprite);
		
		
	}
	
	/**
	 * 
	 * @param	p	the planet in which we're upgrading
	 */
	public function initHUB(p: Planet): Void {
		_screen.drawFrame();
		
		planet = p; // set planet to the one passed in to us
		
		FlxTween.num(0, 1, .66, { ease: FlxEase.circOut, onComplete: finishFadeIn }, updateAlpha);
	}
	
	/**
	 * called by Tween to fade in/out all items in hud
	 */
	private function updateAlpha(value: Float): Void {
		_alpha = value;
		forEach(function(spr:FlxSprite) {
			spr.alpha = _alpha;
		});
	}
	
	/**
	 * When opening hub, set to active so it can gets updates and allow player to interact. Show the current planet's level and stats as well
	 */
	private function finishFadeIn(_): Void {
		active = true;
	}
	
	/**
	 * When finish with hub, set it to not active and not visible (no update or draw)
	 */
	private function finishFadeOut(_): Void {
		active = false;
		visible = false;
	}
	
	/**
	 * Update function for the upgrade HUB
	 * @param	elapsed - time elapsed since last update
	 */
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
	
	/**
	 * Close the hub and set everything else back to active
	 */
	private function clickClose(): Void {
		finishFadeOut();
	}
}