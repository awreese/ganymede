package;

/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
 * 
 * This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import tutorial.CombatTutorial;
import tutorial.SelectShipTutorial;

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
		background.loadGraphic(AssetPaths.menubg__png);
		add(background);
		
		// create and add the title
		title = new FlxText(0, 50, 0, "AstroRush: TBD");
		title.setFormat("Consola", 100);
		title.alignment = CENTER;
		title.screenCenter(FlxAxes.X);
		add(title);
		
		// create and add play button
		playBtn = new FlxButton(0, 0, "", clickPlay);
		playBtn.loadGraphic(AssetPaths.play_btn__png, false, 232, 103);
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
		if (Main.LEVEL == 1) {
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
				FlxG.switchState(new SelectShipTutorial());
			});
		} else {
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
				FlxG.switchState(new PlayState());
			});
		}
	}
}