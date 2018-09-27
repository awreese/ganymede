/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017-2018 Andrew Reese, Daisy Xu, Rory Soiffer
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

package com.ganymede;

import com.ganymede.Main;
import com.ganymede.faction.Faction;
import com.ganymede.gameUnits.ships.Ship;
import com.ganymede.gameUnits.ships.Ship.ShipGroup;
import com.ganymede.gameUnits.capturable.Planet;
import com.ganymede.map.GameMap;
import com.ganymede.map.Node;
import com.ganymede.npc.Enemy;
import com.ganymede.tutorial.FinishGameState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PlayState extends FlxState {
  private var grpMap: FlxTypedGroup<GameMap>;
  private var gameMap: GameMap;

  private var shipGroup:ShipGroup;

  private var grpPlanets: FlxTypedGroup<Planet>;
  private var rand:FlxRandom;
  private var numPlayerFaction:Int;
  private var enemies: Array<Enemy>;

  private var tutor:Tutorial;

  override public function create():Void {
    rand = new FlxRandom();
    enemies = new Array<Enemy>();

    // Initialize the map
    //grpMap = new FlxTypedGroup<GameMap>();        ///
    //add(grpMap);                                    //____ WTF is this?
    gameMap = new GameMap(this, Main.LEVEL);        //     no other game map is ever added to the group
    //grpMap.add(gameMap);                          ///
    
    // TODO: Once game layers are fleshed out better, use below
    //add(gameMap.mapLayers);
    add(gameMap);
    
    trace('gameMap', gameMap);
    //trace('grpMap', grpMap);

    // Create the ships
    shipGroup = new ShipGroup();
    add(shipGroup);

    // add the enemies
    for (faction in Faction.getEnums()) {
      if (faction == null || faction == FactionType.PLAYER || faction ==  FactionType.NOP || faction == FactionType.NEUTRAL) {
        continue;
      }
      if (gameMap.getControlledNodes(faction).length > 0) {
        enemies.push(new Enemy(faction, gameMap.getAiTime()));
      }
    }

    this.tutor = new Tutorial(this);

    super.create();
  }

  /*
   * This is the main game engine.
   */
  override public function update(elapsed:Float):Void {

    /*
     * Check and update any game state
     */
    //Tutorial.checkTutorial(this, elapsed);
    tutor.checkTutorial(elapsed);

    for (ship in shipGroup) {
      if (ship.exists) {
        // update all ships' radars
        ship.setRadar(
          shipGroup.members.copy().filter(
        function(other:Ship) {
          return ship != other && other.exists && ship.inSensorRange(other);
        }
          )
        );
      } else {
        //trace("Ship destroyed: " + ship.toString());

        ship.destroy();
        this.shipGroup.remove(ship, true);
      }
    }

    /*
     * Handle any mouse/keyboard events
     */

    // Selecting ships
    if (FlxG.mouse.justPressed) {

      Main.LOGGER.logLevelAction(1, {
        x: FlxG.mouse.x,
        y: FlxG.mouse.y,
        button: 1
      });

      var n = gameMap.findNode(new FlxVector(FlxG.mouse.x, FlxG.mouse.y));
      //var n = gameMap.findNode(FlxG.mouse.getPosition());
      if (n == null) {
        // old loop
        //for (s in grpShips) {
        //s.isSelected = false;
        //}

        // new loop
        //for (ship in shipgroupByFaction.get(PLAYER)) {
        //ship.isSelected =  false;
        //}
        for (ship in shipGroup) {
          if (ship.getFactionType() == PLAYER) {
            ship.isSelected = false;
          }
        }

      } else {
        // old loop
        //for (s in grpShips) {
        //// only move the ships that are the player's
        //if (s.getFaction() == FactionType.PLAYER) {
        //// allows player to select multiple ships on the map
        //if (n.contains(s.getPos())) {
        //s.isSelected = true;
        //}
        //}
        //}

        // new loop
        //for (ship in shipgroupByFaction.get(PLAYER)) {
        for (ship in shipGroup) {
          // allows player to select multiple ships on the map
          if (ship.getFactionType() == PLAYER && n.contains(ship.getPos())) {
            ship.isSelected = true;
          }
        }

        // Log selecting a planet
        Main.LOGGER.logLevelAction(2, {
          x: n.x,
          y: n.y
        });

      }
    }

    // Ordering ships to move
    if (FlxG.mouse.justPressedRight) {

      Main.LOGGER.logLevelAction(1, {
        x: FlxG.mouse.x,
        y: FlxG.mouse.y,
        button: 2
      });

      var n = gameMap.findNode(new FlxVector(FlxG.mouse.x, FlxG.mouse.y));
      if (n != null) {
        // old loop
        //for (s in grpShips) {
        //if (s.isSelected) {
        //s.isSelected = false;
        //s.pathTo(n);
        //}
        //}

        // new loop
        //for (ship in shipgroupByFaction.get(PLAYER)) {
        var shipCount:Int = 0;
        for (ship in shipGroup) {
          //if (ship.isSelected) {
          if (ship.getFactionType() == PLAYER && ship.isSelected) {
            ship.isSelected = false;
            ship.pathTo(n);
            shipCount++;
          }
        }

        // Log ordering ships
        Main.LOGGER.logLevelAction(3, {
          x: n.x,
          y: n.y,
          num: shipCount
        });

      }
    }

    // enemy turn
    for (enemy in enemies) {
      var nodes = gameMap.getControlledNodes(enemy.getFaction());
      if (nodes.members.length > 0) {
        // make a move if there are controlling factions
        enemy.makeMove(nodes);
      }
    }
    //enemy1.makeMove(gameMap.getControlledNodes(enemy1.getFaction()));

    // Make ships move by flocking
    shipFlocking(elapsed);

    // Make ships fight one another
    //shipCombat(elapsed); // Handled in Ship.hx now

    // check where each ships are and updating each planet, and battle if there's opposing factions
    //nodeUpdate(elapsed);

    // produce ships
    //produceShips(elapsed);

    // check if there are other ships of other factions
    var noOtherFaction: Bool = true;
    var noPlayerShips: Bool = true;
    for (ship in shipGroup) {
      if (ship.getFactionType() == FactionType.PLAYER) {
        // found a player ship
        noPlayerShips = false;
      }
      if (ship.exists) {
        if (ship.getFactionType() != FactionType.PLAYER) {
          // found a ship that's not of player faction
          noOtherFaction = false;
        }
      }
      // break out of loop if found both
      if (!noPlayerShips && !noOtherFaction) break;
    }

    // if captured all the planets, progress
    if (gameMap.getNumPlayerPlanets() == gameMap.getNumPlanets() && noOtherFaction) {
      if (Main.LEVEL == Main.FINAL_LEVEL) {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
          FlxG.switchState(new FinishGameState());
        });
      }
      FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
        FlxG.switchState(new NextLevelState());
      });
    }

    // if player lose all planets, gameover
    if (gameMap.getNumPlayerPlanets() == 0 && noPlayerShips) {
      FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
        FlxG.switchState(new GameOverState());
      });
    }

    super.update(elapsed);
  }

  public function addShip(ship:Ship):Void {
    //this.shipgroupByFaction.get(ship.getFactionType()).add(ship);
    this.shipGroup.add(ship);
  }

  public function getShipGroup():Array<Ship> {
    return this.shipGroup.members.copy();
  }

  public function nodeClicked(point:FlxPoint):Node {
    var node = gameMap.findNode(new FlxVector(point.x, point.y));
    return node;
  }

  /*
   * This function handles all the flocking behavior of the ships. It does so by iterating
   * through all the ships, comparing their position and velocity to the position and velocity
   * of nearby ships, and then setting each ship's velocity.
   *
   * This flocking algorithm is based primarily off of the Boid algorithm described here:
   * https://en.wikipedia.org/wiki/Boids
   */
  private function shipFlocking(elapsed: Float): Void {
    // Iterates through all the ships
    for (s1 in shipGroup) {

      // Defines all the forces acting on the ship
      var toDest = s1.idealPos().subtractNew(s1.pos); // This force pulls the ship towards its destination
      var desiredSpeed = s1.vel.normalize().scaleNew(s1.getMaxVelocity()).subtractNew(s1.vel); // This force accelerates the ship to its desired speed
      var noise = new FlxVector(Math.random() - .5, Math.random() - .5); // This force provides a bit of noise to make the motion look nicer
      var seperation = new FlxVector(0, 0); // This force prevents ships from getting too close together
      var alignment = new FlxVector(0, 0); // This force makes ships tend to point the same direction
      var cohesion = new FlxVector(0, 0); // This force makes ships tend to group together in clusters

      // Iterate through all other ships that this ship might flock with
      for (s2 in shipGroup) {
        // Only flock with other ships of your faction
        if (s2 != s1 && s1.getFactionType() == s2.getFactionType()) {
          var d: FlxVector = s1.pos.subtractNew(s2.pos);
          // Only flock with nearly ships
          if (d.length < 30) {
            seperation = seperation.addNew(d.scaleNew(1/d.lengthSquared));
            alignment = alignment.addNew(s2.vel.subtractNew(s1.vel));
            cohesion = cohesion.addNew(d.normalize());
          }
        }
      }

      // Compute the net acceleration, scaling each component by an arbitrary constant
      // The constants to scale by were determined partially by trial and error until the motion looked good
      var acceleration = new FlxVector(0, 0)
      .addNew(toDest.scaleNew(.01 * s1.getMaxVelocity() * toDest.length))
      .addNew(desiredSpeed.scaleNew(50))
      .addNew(noise.scaleNew(10))
      .addNew(seperation.scaleNew(500))
      .addNew(alignment.scaleNew(.3))
      .addNew(cohesion.scaleNew(.1));

      // Update the velocity
      s1.vel = s1.vel.addNew(acceleration.scaleNew(elapsed));
    }
  }

  // TODO: Swap ownership of production to real ship factory and test
  // produce ships for each planet (if they can)
  //private function produceShips(elapsed: Float):Void {
  ////for (n in gameMap.nodes) {
  //for (n in gameMap.getNodeList()) {
  //// checks if there's a planet at n
  //if (!n.isPlanet()) {
  //continue;
  //}
  //// get the planet
  //var p = cast(n.getCaptureable(), Planet);
  //var pPos = p.getPos();
  //// find the MapNode for the planet
  //var node = gameMap.findNode(new FlxVector(pPos.x + (MapNode.NODE_RADIUS / 2), pPos.y + (MapNode.NODE_RADIUS / 2)));
  //var ship:Ship = p.produceShip(node);
  //if (ship != null) {
  ////grpShips.add(ship);
  ////node.addShip(ship);
  //
  ////shipgroupByFaction.get(ship.getFactionType()).add(ship);
  //this.shipGroup.add(ship);
  //node.addShip(ship);
  //}
  //}
  //}

}

class Tutorial {

  private var ps:PlayState;
  private var checkpoint:Int;
  private var shown:Bool;
  private var triggered:Bool;
  private var time:Float;
  private var rand:FlxRandom;

  private static var NEED_HELP:String = "Looks like you're having some trouble.";
  private static var AFFIRMATION:Array<String> = ["Great!", "Good job!", "Awesome!"];
  private static var TRIGGER_DELAY:Int = 20; // seconds

  private var mouse:FlxSprite;
  private var cursor:FlxSprite;
  private var cursorTween:FlxTween;
  private var textBox:FlxText;
  private var affirmBox:FlxText;

  public function new(state:PlayState) {
    this.ps = state;
    checkpoint = 0;
    shown = false;
    triggered = false;
    rand = new FlxRandom();

    // initialize cursor
    cursor = new FlxSprite(FlxG.width/2, FlxG.height/2, AssetPaths.cursor__png);
    ps.add(cursor);

    // initialize mouse
    mouse = new FlxSprite();
    mouse.loadGraphic(AssetPaths.mouse_a__png, true, 92, 141);
    mouse.animation.add("left_click", [0, 1], 1, true);
    mouse.animation.add("right_click", [0, 2], 1, true);
    mouse.screenCenter();
    ps.add(mouse);

    // initialize top text box
    textBox = new FlxText(390, 50, 500, "");
    textBox.setFormat("Consola", 25, FlxColor.WHITE);
    textBox.autoSize = false;
    textBox.wordWrap = true;
    textBox.alignment = "center";
    ps.add(textBox);

    // initialize bottom text box
    affirmBox = new FlxText(390, 630, 500, "");
    affirmBox.setFormat("Consola", 25, FlxColor.WHITE);
    affirmBox.autoSize = false;
    affirmBox.wordWrap = true;
    affirmBox.alignment = "center";
    ps.add(affirmBox);

    reset();

  }

  private function reset():Void {
    time = 0.0;

    cursor.screenCenter();
    cursor.visible = false;
    cursorTween.cancel;
    if (cursorTween != null && cursorTween.manager.exists) {
      cursorTween.manager.clear();
    }
    cursorTween = null;

    mouse.animation.stop();
    mouse.visible = false;

    textBox.text = NEED_HELP;
    textBox.visible = false;

    shown = false;
    triggered = false;
  }

  private function displayText(text:String, ?fade:Bool = false):Void {
    textBox.text = text;
    textBox.visible = true;

    if (fade) {
      FlxTween.color(textBox, 3, FlxColor.WHITE, FlxColor.TRANSPARENT, { startDelay: 10, type: FlxTween.ONESHOT });
    } else {
      FlxTween.color(textBox, 1, FlxColor.WHITE, FlxColor.WHITE, { type: FlxTween.ONESHOT });
    }
  }

  private function displayMouse(animation:String):Void {
    mouse.visible = true;
    mouse.animation.play(animation);
  }

  private function displayCursor(from:FlxPoint, to:FlxPoint):Void {
    cursor.setPosition(from.x, from.y);
    cursor.visible = true;
    cursorTween = FlxTween.tween(cursor, {x: to.x, y: to.y}, 1.25, {type: FlxTween.LOOPING, loopDelay: 2, ease: FlxEase.quadInOut});
  }

  private function displayAffirmation(?text:String = null):Void {
    var affirm = rand.getObject(AFFIRMATION);
    affirmBox.text = (text == null) ? affirm : affirm + "\n" + text;
    affirmBox.visible = true;
    FlxTween.color(affirmBox, 3, FlxColor.WHITE, FlxColor.TRANSPARENT, { startDelay: 5, type: FlxTween.ONESHOT });
  }

  public function checkTutorial(elapsed:Float):Void {

    switch (Main.LEVEL) {
      case 1:
        tutorial_one(elapsed);
      default:
    }
  }

  private function tutorial_one(elapsed:Float):Void {
    time += elapsed;
    switch (checkpoint) {
      case 0:
        selectUnits();
      case 1:
        moveUnits();
      case 2:
        capturing();
      case 3:
        capturedPlanet();
      case 4:
        combatPrepare();
      case 5:
        combat();
      default:
    }
  }

  private function selectUnits():Void {
    var targetNode = new FlxPoint(100, 275); // node #1

    if (!shown) {
      displayText("Select ship.", true);
      shown = true;
    }

    // Check if checkpoint reached
    if (shipIsSelected()) {
      checkpoint = 1;
      reset();
      displayAffirmation();
      return;
    }

    // Wait and help player
    if (time >= TRIGGER_DELAY && !triggered) {
      triggered = true;

      // show animation
      displayText(NEED_HELP + "\nTry left-clicking a planet to select ship(s).");
      displayMouse("left_click");
      displayCursor(FlxG.mouse.getPosition(), targetNode);
    }
  }

  private function shipIsSelected():Bool {
    for (ship in ps.getShipGroup()) {
      if (ship.isSelected) {
        return true;
      }
    }
    return false;
  }

  private function moveUnits():Void {
    var targetNode = new FlxPoint(325, 350); // node #3

    if (!shown) {
      displayText("Send ship to another node.", true);
      shown = true;
    }

    // Check if checkpoint reached
    if (FlxG.mouse.justPressedRight) {
      if (shipIsSelected() && ps.nodeClicked(FlxG.mouse.getPosition()) != null) {
        checkpoint = 2;
        reset();
        displayAffirmation();
        return;
      }
    }

    // Wait and help player
    if (time >= TRIGGER_DELAY && !triggered) {
      triggered = true;

      // show animation
      displayText(NEED_HELP + "\nTry right-clicking a node to send ship(s).  Make sure they are still selected!");
      displayMouse("right_click");
      displayCursor(FlxG.mouse.getPosition(), targetNode);
    }
  }

  private function capturing():Void {
    var target1 = new FlxPoint(550, 425); // capturable node #5
    var target2 = new FlxPoint(650, 145); // capturable node #7
    var target3 = new FlxPoint(650, 575); // capturable node #8

    if (!shown) {
      displayText("Try capturing a planet now!", true);
      shown = true;
    }

    // Check if checkpoint reached
    if (FlxG.mouse.justPressedRight) {
      //var node:MapNode = ps.nodeClicked(FlxG.mouse.getPosition());
      //if (shipIsSelected() && node.getPosition().equals(target1)) {
      if (shipIsSelected() && clickedOneOfThree(target1, target2, target3)) {
        checkpoint = 3;
        reset();
        displayAffirmation("You're capturing a planet now!");
        return;
      }
    }

    if (capturedOne(target1, target2, target3)) {
      checkpoint = 4;
      reset();
      displayAffirmation("You captured your first planet!");
      return;
    }

    // Wait and help player
    if (time >= TRIGGER_DELAY && !triggered && !capturedOne(target1, target2, target3)) {
      triggered = true;

      // show animation
      displayText(NEED_HELP + "\nTry right-clicking a node to send ship(s) to capture.  Make sure they are still selected!");
      displayMouse("right_click");
      displayCursor(FlxG.mouse.getPosition(), target1);
    }
  }

  private function capturedOne(p1:FlxPoint, p2:FlxPoint, p3:FlxPoint):Bool {
    var f1 = ps.nodeClicked(p1).getFaction();
    var f2 = ps.nodeClicked(p2).getFaction();
    var f3 = ps.nodeClicked(p3).getFaction();
    return f1 == PLAYER || f2 == PLAYER || f3 == PLAYER;
  }

  private function clickedOneOfThree(p1:FlxPoint, p2:FlxPoint, p3:FlxPoint):Bool {
    var node:Node = ps.nodeClicked(FlxG.mouse.getPosition());
    return node.getPosition().equals(p1) || node.getPosition().equals(p2) || node.getPosition().equals(p3);
  }

  private function capturedPlanet():Void {
    var targetNode = new FlxPoint(550, 425); // capturable node #5
    var node:Node = ps.nodeClicked(targetNode);

    if (node.getFaction() == PLAYER) {
      checkpoint = 4;
      reset();
      displayAffirmation("You captured your first planet!");
    }
  }

  private function combatPrepare():Void {
    var target1 = new FlxPoint(550, 425); // capturable node #5
    var target2 = new FlxPoint(650, 145); // capturable node #7
    var target3 = new FlxPoint(650, 575); // capturable node #8

    if (!shown) {
      displayText("Prepare to combat the enemy by capturing the other two planets.", true);
      shown = true;
    }

    // Check if checkpoint reached
    if (capturedThree(target1, target2, target3)) {
      checkpoint = 5;
      reset();
      displayAffirmation("You are now ready for your first skirmish!");
      return;
    }

    // Wait and help player
    if (time >= TRIGGER_DELAY && !triggered) {
      triggered = true;

      // show animation
      displayText(NEED_HELP + "\nTry right-clicking a node to send ship(s) to capture.  Make sure they are still selected!", true);
    }
  }

  private function capturedThree(p1:FlxPoint, p2:FlxPoint, p3:FlxPoint):Bool {
    var f1 = ps.nodeClicked(p1).getFaction();
    var f2 = ps.nodeClicked(p2).getFaction();
    var f3 = ps.nodeClicked(p3).getFaction();
    return f1 == PLAYER && f1 == f2 && f2 == f3;
  }

  private function combat():Void {
    var targetNode = new FlxPoint(1125, 340); // capturable node #12
    var node:Node = ps.nodeClicked(targetNode);

    if (!shown) {
      displayText("You are ready!  No go take out the little red bugger.", true);
      shown = true;
    }

    // Check if checkpoint reached
    if (FlxG.mouse.justPressedRight) {
      var node:Node = ps.nodeClicked(FlxG.mouse.getPosition());
      if (shipIsSelected() && node.getPosition().equals(targetNode)) {
        checkpoint = 6;
        reset();
        displayAffirmation();
        return;
      }
    }

    // Wait and help player
    if (time >= TRIGGER_DELAY && !triggered) {
      triggered = true;

      // show animation
      displayText(NEED_HELP + "\nTry right-clicking a node to send ships to combat.  Make sure they are still selected!");
      displayMouse("right_click");
      displayCursor(FlxG.mouse.getPosition(), targetNode);
    }
  }
}
