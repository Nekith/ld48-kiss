package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Player;

class Ammo extends AEntity
{
    static inline public var WIDTH : Int = 24;
    static inline public var HEIGHT : Int  = 24;
    
    private var _figures : Shape;
    private var _angle : Float;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - Ammo.WIDTH / 2, position.y - Ammo.HEIGHT / 2, Ammo.WIDTH, Ammo.HEIGHT));
        this._figures = new Shape();
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0xFFFFFF);
        g.drawRect(-8, -8, 16, 16);
        g.beginFill(0x04BF9D);
        g.drawRect(-5, -5, 10, 10);
        addChild(this._figures);
        _angle = 0;
    }
    
    public override function update(scene : ALevel) : Void
    {
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
        if (rect.x + rect.width <= 0 || rect.x >= scene.dimension.x || rect.y + rect.height <= 0 || rect.y >= scene.dimension.y) {
            scene.removeEntity(this);
            this.clean();
        }
        else {
            if (true == scene.player.rect.intersects(rect)) {
                if (true == scene.player.pickAmmo(scene)) {
                    scene.removeEntity(this);
                    this.clean();
                }
            }
        }
    }
    
    public override function draw(scene : ALevel) : Void
    {
        _angle = (_angle + 3 % 360);
        this._figures.rotation = _angle;
        super.draw(scene);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}