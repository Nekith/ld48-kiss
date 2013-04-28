package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Log;
import scenes.ALevel;
import entities.AEntity;
import entities.Ammo;
import entities.Health;
import entities.GoodProjectile;
import entities.BadProjectile;

class Mammoth extends AEntity
{
    static inline public var WIDTH : Int = 30;
    static inline public var HEIGHT : Int = 50;
    
    private var _figures : Shape;
    private var _angle : Float;
    private var _count : Int;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - Mammoth.WIDTH / 2, position.y - Mammoth.HEIGHT / 2, Mammoth.WIDTH, Mammoth.HEIGHT));
        this._figures = new Shape();
        addChild(this._figures);
        this._count = 0;
        this._angle = 0;
    }
    
    public function takeHit(scene : ALevel) : Void
    {
        SoundBank.instance.hit.play();
        scene.director.score += 1;
        scene.director.loot(scene, position);
        --scene.director.evilCount;
        dying = true;
    }
    
    public override function update(scene : ALevel) : Void
    {
        // movement
        if (0 == this._count) {
            force.x = (0 == Std.random(2) ? -3 : 3) * Math.random();
            force.y = (0 == Std.random(2) ? -3 : 3) * Math.random();
        }
        else if (120 > this._count) {
            position.x += force.x;
            position.y += force.y;
        }
        super.update(scene);
        if (false == dying) {
            this._angle = Math.atan2(scene.player.position.y - position.y, scene.player.position.x - position.x);
            // collision
            var ent : Array<AEntity> = scene.findEntities(rect);
            for (e in ent) {
                if (e == this || true == Std.is(e, GoodProjectile) || true == Std.is(e, BadProjectile) || true == Std.is(e, Ammo) || true == Std.is(e, Health)) {
                    continue;
                }
                if (Math.abs(e.position.x - position.x) < Math.abs(e.position.y - position.y)) {
                    if (e.rect.y + e.rect.height >= rect.y && e.rect.y < rect.y) {
                        position.y += e.rect.y + e.rect.height - rect.y;
                    }
                    else if (e.rect.y <= rect.y + rect.height && e.rect.y > rect.y) {
                        position.y -= rect.y + rect.height - e.rect.y;
                    }
                }
                else {
                    if (e.rect.x + e.rect.width >= rect.x && e.rect.x < rect.x) {
                        position.x += e.rect.x + e.rect.width - rect.x;
                    }
                    else if (e.rect.x <= rect.x + rect.width && e.rect.x > rect.x) {
                        position.x -= rect.x + rect.width - e.rect.x;
                    }
                }
            }
            super.update(scene);
            // fire
            if (150 <= this._count) {
                if (400 >= Math.abs(scene.player.position.y - position.y) && 400 >= Math.abs(scene.player.position.x - position.x)) {
                    var projectile : BadProjectile = new BadProjectile(new Point(position.x, position.y), this._angle);
                    scene.addEntity(projectile);
                    SoundBank.instance.enemy.play();
                }
                this._count = 0;
            }
            else {
                ++this._count;
            }
        }
    }
    
    public override function draw(scene : ALevel) : Void
    {
        super.draw(scene);
        this._figures.rotation = _angle * 180.0 / Math.PI;
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0xF53D54);
        g.drawRect(-15, -20, 30, 40);
        g.beginFill(0xF53D54);
        g.drawRect(-5, -25, 10, 5);
        g.beginFill(0xF53D54);
        g.drawRect(-5, 20, 10, 5);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}