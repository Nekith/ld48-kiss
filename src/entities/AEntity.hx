package entities;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.Lib;
import scenes.ALevel;

class AEntity extends Sprite
{
    public var position(default, null) : Point;
    public var rect(default, null) : Rectangle;
    public var force(default, null) : Point;
    public var dying(default, null) : Bool;
    private var _canEscapeLevel : Bool;
    private var _dyingAnimation : Int;
    
    public function new(rect : Rectangle)
    {
        super();
        this.rect = rect;
        this.position = new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
        x = position.x;
        y = position.y;
        force = new Point(0, 0);
        dying = false;
        _canEscapeLevel = false;
    }
    
    public function update(scene : ALevel) : Void
    {
        rect.x = position.x - rect.width / 2;
        rect.y = position.y - rect.height / 2;
        if (false == _canEscapeLevel) {
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
        if (20 <= this._dyingAnimation) {
            scene.removeEntity(this);
            clean();
        }
    }
    
    public function draw(scene : ALevel) : Void
    {
        x = position.x;
        y = position.y;
        if (true == dying) {
            this.scaleX = 1.0 - this._dyingAnimation * 0.05;
            this.scaleY = 1.0 - this._dyingAnimation * 0.05;
            ++this._dyingAnimation;
        }
    }
    
    public function clean() : Void
    {
    }
}