package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Ammo;

class Turret extends AEntity
{
    static inline public var WIDTH : Int = 40;
    static inline public var HEIGHT : Int  = 40;
    
    private var _figures : Shape;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - 20, position.y - 20, Turret.WIDTH, Turret.HEIGHT));
        this._figures = new Shape();
        addChild(this._figures);
    }
    
    public function takeHit(scene : ALevel) : Void
    {
        scene.removeEntity(this);
        scene.addEntity(new Ammo(position));
        clean();
    }
    
    public override function draw(scene : ALevel) : Void
    {
        super.draw(scene);
        this._figures.rotation = Math.atan2(scene.player.position.y - position.y, scene.player.position.x - position.x) * 180.0 / Math.PI;
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0xF53D54);
        g.drawRect(-20, -20, 40, 40);
        g.beginFill(0xF53D54);
        g.drawRect(20, -15, 15, 15);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}