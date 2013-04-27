package entities;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.Lib;
import haxe.Log;
import scenes.AScene;

class AEntity extends Sprite
{
    public var position(default, null) : Point;
    public var rect(default, null) : Rectangle;
    public var force(default, null) : Point;
    
    public function new(rect : Rectangle)
    {
        super();
        this.rect = rect;
        this.position = new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
        x = rect.x;
        y = rect.y;
        force = new Point(0, 0);
    }
    
    public function update(scene : AScene) : Void
    {
        position.x += force.x;
        position.y += force.y;
        rect.x = position.x - rect.width / 2;
        rect.y = position.y - rect.height / 2;
        if (rect.x + rect.width >= scene.dimension.x) {
            rect.x = scene.dimension.x - rect.width;
        }
        else if (rect.x < 0) {
            rect.x = 0;
        }
        if (rect.y + rect.height >= scene.dimension.y) {
            rect.y = scene.dimension.y - rect.height;
        }
        else if (rect.y < 0) {
            rect.y = 0;
        }
        position.x = rect.x + rect.width / 2;
        position.y = rect.y + rect.height / 2;
    }
    
    public function draw() : Void
    {
        x = rect.x;
        y = rect.y;
        Log.trace(position.x + " " + position.y + " / " + x + " " + y);
    }
    
    public function clean() : Void
    {
    }
}