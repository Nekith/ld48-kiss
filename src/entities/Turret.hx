package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Ammo;
import entities.BadProjectile;

class Turret extends AEntity
{
    static inline public var WIDTH : Int = 40;
    static inline public var HEIGHT : Int  = 40;
    
    private var _figures : Shape;
    private var _angle : Float;
    private var _lastFire : Int;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - Turret.WIDTH / 2, position.y - Turret.HEIGHT / 2, Turret.WIDTH, Turret.HEIGHT));
        this._figures = new Shape();
        addChild(this._figures);
        this._lastFire = 0;
        this._angle = 0;
    }
    
    public function takeHit(scene : ALevel) : Void
    {
        scene.director.score += 1;
        scene.removeEntity(this);
        scene.addEntity(new Ammo(position));
        --scene.director.evilCount;
        clean();
    }
    
    public override function update(scene : ALevel) : Void
    {
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
        this._angle = Math.atan2(scene.player.position.y - position.y, scene.player.position.x - position.x);
        if (120 <= this._lastFire) {
            if (400 >= Math.abs(scene.player.position.y - position.y) && 400 >= Math.abs(scene.player.position.x - position.x)) {
                var projectile : BadProjectile = new BadProjectile(new Point(position.x + 15, position.y - 20), _angle);
                scene.addEntity(projectile);
                this._lastFire = 0;
            }
        }
        else {
            ++this._lastFire;
        }
    }
    
    public override function draw(scene : ALevel) : Void
    {
        super.draw(scene);
        this._figures.rotation = _angle * 180.0 / Math.PI;
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