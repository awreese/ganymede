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

package;

import Main;
import faction.Faction;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import gameUnits.Ship;
import gameUnits.Ship.ShipGroup;
import gameUnits.capturable.Planet;
import map.GameMap;
import map.MapNode;
import npc.Enemy;
import tutorial.FinishGameState;

class PlayState extends FlxState {
	private var grpMap: FlxTypedGroup<GameMap>;
	private var gameMap: GameMap;
	
    //public var grpShips: ShipGroup;
    // TODO: turn above into below
	//private var shipgroupByFaction:Map<FactionType, ShipGroup>;
    private var shipGroup:ShipGroup;
    
    private var grpPlanets: FlxTypedGroup<gameUnits.capturable.Planet>;
	private var rand:FlxRandom;
	private var numPlayerFaction:Int;
	private var enemies: Array<Enemy>;

	override public function create():Void {
		rand = new FlxRandom();
		enemies = new Array<Enemy>();

		// Initialize the map
		grpMap = new FlxTypedGroup<GameMap>();        ///
		add(grpMap);                                    //____ WTF is this?
		gameMap = new GameMap(this, Main.LEVEL);        //     no other game map is ever added to the group
		grpMap.add(gameMap);                          ///
		//add(gameMap);

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
		
		super.create();
	}

	/*
	 * This is the main game engine.
	 */
	override public function update(elapsed:Float):Void {

		/*
		 * Check and update any game state
		 */
        
        
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
            
            Main.LOGGER.logLevelAction(1, 
                {
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
                Main.LOGGER.logLevelAction(2, 
                    {
                        x: n.x, 
                        y: n.y
                    });
                
			}
		}

		// Ordering ships to move
		if (FlxG.mouse.justPressedRight) {
            
            Main.LOGGER.logLevelAction(1, 
                {
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
  				Main.LOGGER.logLevelAction(3, 
                    {
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
