/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2018 Andrew Reese
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

package com.ganymede.util;

import flixel.FlxG;
import flixel.input.mouse.FlxMouse;

using Lambda;

enum MouseButton {
  LEFT;
  MIDDLE;
  RIGHT;
}

enum MouseEvent {
  DOWN;
  PRESSED;
  UP;
}

/**
 * MouseHandler.
 * Stores callback functions that are dispatched.
 * @author Drew Reese
 */
class MouseHandler {

  public var handlers:Map<MouseButton, Map<MouseEvent, Array<Void -> Void>>>;
  
  public function new() {
    //this.handlers = new Map();
    //
    //for (button in Type.allEnums(MouseButton)) {
      //this.handlers[button] = new Map();
      //for (event in Type.allEnums(MouseEvent)) {
        //this.handlers[button][event] = new Array();
      //}
    //}
    
    this.handlers = [
      for (b in Type.allEnums(MouseButton)) b => [
        for (e in Type.allEnums(MouseEvent)) e => new Array()
      ]
    ];
  }
  
  public function addListener(button:MouseButton, event:MouseEvent, callBack:Void -> Void):Void {
    this.handlers[button][event].push(callBack);
  }
  
  public function removeListener(button:MouseButton, event:MouseEvent, callBack:Void -> Void):Void {
    var callbacks:Array<Void -> Void> = this.handlers[button][event];
    this.handlers[button][event] = callbacks.filter(function(c) {return c != callBack; } );
  }
  
  public function handleEvents():Void {
    var mouse:FlxMouse = FlxG.mouse;
    
    // Mouse down
    if (mouse.justPressed) {
      this.dispatch(MouseButton.LEFT, MouseEvent.DOWN);
    }
    if (mouse.justPressedMiddle) {
      this.dispatch(MouseButton.MIDDLE, MouseEvent.DOWN);
    }
    if (mouse.justPressedRight) {
      this.dispatch(MouseButton.RIGHT, MouseEvent.DOWN);
    }
    
    // Mouse up
    if (mouse.justReleased) {
      this.dispatch(MouseButton.LEFT, MouseEvent.UP);
    }
    if (mouse.justReleasedMiddle) {
      this.dispatch(MouseButton.MIDDLE, MouseEvent.UP);
    }
    if (mouse.justReleasedRight) {
      this.dispatch(MouseButton.RIGHT, MouseEvent.UP);
    }
    
    // Mouse is currently pressed
    if (mouse.pressed) {
      this.dispatch(MouseButton.LEFT, MouseEvent.PRESSED);
    }
    if (mouse.pressedMiddle) {
      this.dispatch(MouseButton.MIDDLE, MouseEvent.PRESSED);
    }
    if (mouse.pressedRight) {
      this.dispatch(MouseButton.RIGHT, MouseEvent.PRESSED);
    }
  }
  
  private function dispatch(button:MouseButton, event:MouseEvent):Void {
    var callbacks:Array<Void -> Void> = this.handlers[button][event];
    for (callback in callbacks) callback();
  }
  
}