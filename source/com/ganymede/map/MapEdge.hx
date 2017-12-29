package com.ganymede.map;

import flixel.FlxObject;

/**
 * ...
 * @author Drew Reese
 */
class MapEdge extends FlxObject {

  public var node1id(default, null):Int;
  public var node2id(default, null):Int;
  
  private var highlighted:Bool;
  
  //public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) {
  public function new(node1id:Int, node2id:Int, thickness:Int) {
    //super(X, Y, Width, Height);
		super();
  }
  
  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
  
  public function toggleON():Void {
    this.visible = true;
  }
  
  public function toggleOFF():Void {
    this.visible = false;
  }
}

class EdgeLine extends FlxSprite {

  public function new (p1:FlxPoint, p2:FlxPoint) {
    super();
    
    trace('FlxG.width/height: $FlxG.width, $FlxG.height');

    this.makeGraphic(FlxG.stage.stageWidth, FlxG.stage.stageHeight, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawLine(this, p1.x, p1.y, p2.x, p2.y, {color: FlxColor.MAGENTA});

    trace('Edge $p1 -> $p2');
    
    this.visible = true;
    FlxG.state.add(this);
  }
}
