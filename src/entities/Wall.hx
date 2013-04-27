package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;

class Wall extends AEntity
{
    public var health(default, null) : Int;
    private var _figures : Shape;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - 20, position.y - 20, 40, 40));
        this._figures = new Shape();
        addChild(this._figures);
        health = 3;
    }
    
    public function takeHit(scene : ALevel) : Void
    {
        --health;
        if (0 >= health) {
            scene.director.score += 1;
            scene.removeEntity(this);
            clean();
        }
    }
    public override function draw(scene : ALevel) : Void
    {
        var g : Graphics = this._figures.graphics;
        g.clear();
        if (3 == health) {
            g.beginFill(0x909090);
        }
        else if (2 == health) {
            g.beginFill(0x707070);
        }
        else if (1 == health) {
            g.beginFill(0x505050);
        }
        g.drawRect(-20, -20, 40, 40);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}