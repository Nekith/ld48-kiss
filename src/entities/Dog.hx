package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Ammo;
import entities.Health;
import SoundBank;

class Dog extends AEntity
{
    static inline public var WIDTH : Int = 50;
    static inline public var HEIGHT : Int  = 20;
    
    public var health(default, null) : Int;
    private var _figures : Shape;
    private var _angle : Float;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - Dog.WIDTH / 2, position.y - Dog.HEIGHT / 2, Dog.WIDTH, Dog.HEIGHT));
        this._figures = new Shape();
        addChild(this._figures);
        health = 2;
    }
    
    public function takeHit(scene : ALevel) : Void
    {
        --health;
        SoundBank.instance.hit.play();
        if (0 >= health) {
            scene.director.score += 1;
            if (0 == Std.random(4)) {
                scene.addEntity(new Health(position));
            }
            else {
                scene.addEntity(new Ammo(position));
            }
            --scene.director.evilCount;
            dying = true;
        }
    }
    
    public override function update(scene : ALevel) : Void
    {
        // movement
        this._angle = Math.atan2(scene.player.position.y - position.y, scene.player.position.x - position.x);
        force.x = Math.cos(_angle) * (2 == health ? 3 : 4);
        force.y = Math.sin(_angle) * (2 == health ? 3 : 4);
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
        if (20 > this._dyingAnimation) {
            // collision
            var entities : Array<AEntity> = scene.findEntities(rect);
            for (e in entities) {
                if (true == Std.is(e, GoodProjectile) || true == Std.is(e, BadProjectile) || true == Std.is(e, Ammo) || true == Std.is(e, Health)) {
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
        }
    }
    
    public override function draw(scene : ALevel) : Void
    {
        super.draw(scene);
        this._figures.rotation = _angle * 180.0 / Math.PI;
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill((2 == health ? 0xF53D54 : 0xF55C38));
        g.drawRect(-25, -10, 50, 20);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}