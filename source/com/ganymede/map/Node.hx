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

package com.ganymede.map;

import Std;
import com.ganymede.faction.Faction;
import com.ganymede.faction.Faction.FactionType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import com.ganymede.gameUnits.Ship;
import com.ganymede.gameUnits.capturable.Capturable;
import com.ganymede.gameUnits.capturable.Planet;
//import com.ganymede.map.Node.NodeRing;

//using flixel.util.FlxSpriteUtil;

/**
 * NodeGroup is a group of MapNodes
 */
typedef NodeGroup = FlxTypedGroup<Node>;

//typedef EdgeMap = Map<map.MapNode, EdgeGroup>;

typedef NeighborMap = Map<Node, Float>;

private class Consts {
  public static inline var NODE_RADIUS:Int = 30;
}

class NodeRing extends FlxSprite {

  private var radius:Int;

  function new (x:Float, y:Float, ?radius:Int = Consts.NODE_RADIUS, ?visible:Bool = true, ?fill:FlxColor = FlxColor.TRANSPARENT, ?lineStyle:LineStyle, ?drawStyle:DrawStyle) {
    super(x, y);

    this.radius = radius;
    var diameter:Int = 2 * this.radius + 1;

    //this.width = diameter;
    //this.height = diameter;

    this.makeGraphic(diameter, diameter, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(this, -1, -1, this.radius, fill, lineStyle, drawStyle);
    this.setPosition(x - radius, y - radius);
    this.visible = visible;
    // FlxG.state.add(this);
  }
}

/**
 * MapNode
 *
 * Exists as the go-between game objects the game map.  This class tracks
 * and maintains a localized (node only) field for any capturable objects
 * residing the node, and a list of ships currently present, divided by
 * faction for easy querying.
 *
 * @author Rory Soiffer
 * @author Drew Reese
 */
class Node extends FlxObject {
  public static var NODE_RADIUS:Int = 30;

  public var gameMap:GameMap;
  public var neighbors:NeighborMap;

  //private var edgesOut:EdgeMap; // ???

  // Fields
  private var radius:Int;
  private var ring_node:NodeRing;
  private var ring_selected:NodeRing;
  private var ring_highlight:NodeRing;

  private var isSelected:Bool = false;

  // Game objects at this node
  private var capturable:Capturable;
  private var factionShips:Map<FactionType, ShipGroup>;

  /*
   * TODO: reduce internal exposure, not everything needs to be public
   */

  public function new(gameMap:GameMap, x:Float, y:Float, ?radius:Int = Consts.NODE_RADIUS) {

    this.radius = radius;
    var diameter:Int = 2 * this.radius + 1;
    super(x, y, diameter, diameter);

    this.ring_node = new NodeRing(x, y, cast(radius / 2), true, FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.6));
    
    this.ring_selected = new NodeRing(x, y, radius, false, FlxColor.fromRGBFloat(0.9, 0.3, 0.4, 0.5), {color: FlxColor.YELLOW});
 
    var fillColor:FlxColor = FlxColor.fromRGBFloat(0.5, 0.5, 0.5, 0.3);
    this.ring_highlight = new NodeRing(x, y, radius * 2, false, fillColor); // , {color: FlxColor.WHITE}

    gameMap.mapLayers.graph.add(this.ring_node);
    gameMap.mapLayers.graph.add(this.ring_selected);
    gameMap.mapLayers.graph.add(this.ring_highlight);
    //FlxG.state.add(this.ring_node);
    //FlxG.state.add(this.ring_selected);
    //FlxG.state.add(this.ring_highlight);
    
    this.gameMap = gameMap;

    this.neighbors = new NeighborMap();

    this.capturable = null;

    // create empty faction ship groups
    factionShips = new Map<FactionType, ShipGroup>();
    for (faction in Faction.getEnums()) {
      factionShips.set(faction, new ShipGroup());
    }
  }

  override public function update(elapsed:Float):Void {

    var mouse:FlxMouse = FlxG.mouse;
    var p = mouse.getPosition();
    
    //ring_highlight.visible = ring_highlight.getHitbox().containsPoint(FlxG.mouse.getPosition());
    ring_highlight.visible = mouseOver(ring_highlight, p);

    if (mouse.justPressed) {
      //ring_selected.visible = ring_selected.getHitbox().containsPoint(mouse.getPosition());
      ring_selected.visible = mouseOver(ring_selected, p);
    }

    //trace("mouse: x=" + p.x + " y=" + p.y);
    //if (ring_node.getHitbox().containsPoint(FlxG.mouse.getPosition())) {
    ////ring_highlight.visible = true;
    ////selectRing.revive();
    //FlxG.state.r
    //} else {
    //ring_highlight.visible = false;
    ////selectRing.kill();
    //}

    super.update(elapsed);
    /*if (this.isPlanet()) {
    	var p:Planet = cast(capturable, Planet); // turn to planet
    	var ship:Ship = p.produceShip(); // get ship
    	if (ship != null) {
    		this.addShip(ship); // add ship to this
    	}
    }*/
  }

  /*
   * Node functions
   */

  public function equals(other:Dynamic):Bool {
    if (this == other) {
      return true;
    }

    if (Std.is(other, Node)) {
      other = cast(other, Node);
      return (this.getPosition().equals(other.getPosition()) && this.radius == other.radius);
    }

    return false;
  }

  public function connect(node:Node):Bool {
    // already connected?
    if (this.isConnected(node)) {
      return false;
    }

    // not a neighbor yet, connect nodes on both ends
    var distance = this.getPosition().distanceTo(node.getPosition());
    this.neighbors.set(node, distance);
    node.neighbors.set(this, distance);
    
    new Edge(this, node);
    
    return this.isConnected(node);
  }

  public function isConnected(node:Node):Bool {
    return this.neighbors.exists(node) && node.neighbors.exists(this);
  }

  public function clearNode():Void {
    this.neighbors = new NeighborMap();
  }

  public static function mouseOver(obj: FlxObject, p:FlxPoint):Bool {
    return obj.getHitbox().containsPoint(p);
  }

  public function contains(v: FlxVector): Bool {
    //return pos.dist(v) < NODE_SIZE + 15;
    return this.getPosition().distanceTo(v) < Consts.NODE_RADIUS + 15;
  }

  public function distanceTo(n: Node): Float {
    //return pos.dist(n.pos);
    //return this.getPosition().distanceTo(n.getPosition());
    var distance:Float = this.neighbors.get(n);
    return distance;
  }

  public function drawTo(sprite: FlxSprite): Void {
    FlxSpriteUtil.drawCircle(sprite, this.x, this.y, Consts.NODE_RADIUS, FlxColor.TRANSPARENT, {color: FlxColor.WHITE});

    for (n in neighbors.keys()) {
      var e = new Edge(this, n);
      FlxSpriteUtil.drawLine(sprite, e.interpDist(Consts.NODE_RADIUS).x, e.interpDist(Consts.NODE_RADIUS).y, e.interpDist(e.length() - Consts.NODE_RADIUS).x,
      e.interpDist(e.length() - Consts.NODE_RADIUS).y, {color: FlxColor.WHITE});
    }
  }

  public function pathTo(n: Node): Array<Edge> {
    // Dijkstra's algorithm
    var dists: Map<Node, Float> = [this => 0];
    var parents: Map<Node, Node> = [this => this];
    //var toCheck: Array<MapNode> = gameMap.nodes.copy();
    //var toCheck: Array<MapNode> = gameMap.nodes.members.copy();
    var toCheck: Array<Node> = gameMap.getNodeList();

    while (toCheck.length > 0) {
      var minEl: Node = toCheck[0];

      for (e in toCheck) {
        if (!dists.exists(minEl) || (dists.exists(e) && dists.get(e) < dists.get(minEl))) {
          minEl = e;
        }
      }
      if (minEl == n) {
        break;
      }
      toCheck.remove(minEl);
      for (e in minEl.neighbors.keys()) {
        var newDist: Float = dists.get(minEl) + minEl.distanceTo(e);
        if (!dists.exists(e) || newDist < dists.get(e)) {
          dists.set(e, newDist);
          parents.set(e, minEl);
        }
      }
    }

    // TODO: convert this to real path object
    var path: Array<Edge> = new Array();
    var e: Node = n;
    while (e != this) {
      path.unshift(new Edge(parents.get(e), e));
      e = parents.get(e);
    }
    return path;
  }

  public function getPos():FlxVector {
    //return new FlxVector(pos.x, pos.y);
    return new FlxVector(x, y);
  }

  /**
   * Sets the capturable object at this node.
   * @param capturable    capturable object to set at this node
   */
  public function setCapturable(capturable:Capturable):Bool {
    if (capturable != null) {
      this.capturable = capturable;
      return true;
    }
    return false;
  }

  /**
   * Adds specified ship to this node.
   * @param ship  ship to add to this node
   */
  public function addShip(ship:Ship):Void {
    var group:ShipGroup = this.factionShips.get(ship.getFactionType());
    group.add(ship);
    this.gameMap.incrementShipCount(ship.getFactionType());
  }

  /**
   * Removes ship from this node's list
   * @param ship  shit to remove from this node
   */
  public function removeShip(ship:Ship):Void {
    var group:ShipGroup = this.factionShips.get(ship.getFactionType());
    group.remove(ship, true);
    this.gameMap.decrementShipCount(ship.getFactionType());
  }

  /**
   * Moves the specified ship from this node to the specified node.
   *
   * NOTE: This implementation calls addShip on the specified node then
   * calls removeShip on this node.  This currently is not a single atomic
   * action so edge cases for race conditions exist, but are unlikely
   * to cause issues since counts are incremented before being decremented
   * back to the actual count.
   *
   * @param ship  ship to move to specified node
   * @param toNode    new node for ship
   */
  public function moveShip(ship:Ship, node:Node):Void {
    node.addShip(ship);   // increments count
    this.removeShip(ship);  // decrements count
  }

  /**
   * Retuns a ShipGroup for the specified faction currently at this node.
   * @param	faction	faction to return ShipGroup of
   * @return	ShipGroup for specified faction currently at this node
   */
  public function getShipGroup(faction:FactionType):ShipGroup {
    return this.factionShips.get(faction);
  }

  public function getShipGroups():Iterator<ShipGroup> {
    return this.factionShips.iterator();
  }

  // Capturable helpers

  /**
   * Returns true if capturable object exists on this node, false otherwise.
   * @return true iff a capturable object exists at this node, false otherwise
   */
  public function isCapturable():Bool {
    return this.capturable != null;
  }

  public function getCaptureable(): Capturable {
    return capturable;
  }

  /*
   * return true if captureable is a planet, false otherwise
   */
  public function isPlanet():Bool {
    //var v = Std.instance(capturable, Planet);
    //return !(Std.instance(capturable, Planet) == null);
    return Std.is(capturable, Planet);
  }

  public function getPlanet():Planet {
    //return isPlanet() ? capturable : null;
    return null;
  }

  public function getFaction():FactionType {
    return (this.capturable == null) ? null : this.capturable.getFaction().getFactionType();
  }
}
