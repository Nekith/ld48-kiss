package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.ui.Keyboard;
import scenes.ALevel;
import entities.AEntity;
import entities.Wall;
import entities.GoodProjectile;
import entities.BadProjectile;
import SoundBank;

class Player extends AEntity
{
    public var health(default, null) : Int;
    public var ammo(default, null) : Int;
    public var angle(default, null) : Float;
    private var _figures : Shape;
    private var _wasFiring : Bool;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - 16, position.y - 16, 32, 32));
        health = 6;
        ammo = 15;
        angle = 0;
        this._wasFiring = false;
        this._figures = new Shape();
        addChild(this._figures);
    }
    
    /**********************************************************************************************
     *                    UPDATE
     **********************************************************************************************/
    
    public override function update(scene : ALevel) : Void
    {
        _movement(scene);
        super.update(scene);
        _collision(scene);
        super.update(scene);
        this.angle = Math.atan2(scene.mouse.y - scene.y - position.y, scene.mouse.x - scene.x - position.x);
        _fire(scene);
        rect.width = (5 + ammo) * 2;
        rect.height = (5 + ammo) * 2;
        super.update(scene);
    }
    
    private function _movement(scene : ALevel) : Void
    {
        var speed : Int = 7 - Std.int(ammo / 5);
        if (true == scene.keys[Keyboard.D] || true == scene.keys[Keyboard.RIGHT]) {
            force.x = speed;
        }
        else if (true == scene.keys[Keyboard.Q] || true == scene.keys[Keyboard.A] || true == scene.keys[Keyboard.LEFT]) {
            force.x = -speed;
        }
        else {
            force.x = 0;
        }
        if (true == scene.keys[Keyboard.Z] || true == scene.keys[Keyboard.W] || true == scene.keys[Keyboard.UP]) {
            force.y = -speed;
        }
        else if (true == scene.keys[Keyboard.S] || true == scene.keys[Keyboard.DOWN]) {
            force.y = speed;
        }
        else {
            force.y = 0;
        }
        position.x += force.x;
        position.y += force.y;
    }
    
    private function _collision(scene : ALevel) : Void
    {
        var entities : Array<AEntity> = scene.findEntities(rect);
        for (e in entities) {
            if (true == Std.is(e, GoodProjectile) || true == Std.is(e, BadProjectile) || true == Std.is(e, Ammo)) {
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
    }
    
    private function _fire(scene : ALevel) : Void
    {
        if (true == scene.click) {
            if (0 < ammo && false == this._wasFiring) {
                --ammo;
                this._wasFiring = true;
                var projectile : GoodProjectile = new GoodProjectile(new Point(position.x - 4, position.y), angle);
                scene.addEntity(projectile);
                SoundBank.instance.shoot.play();
            }
        }
        else {
            this._wasFiring = false;
        }
    }
    
    public function takeHit(scene : ALevel) : Void
    {
        --health;
        SoundBank.instance.hurt.play();
    }
    
    public function pickAmmo(scene : ALevel) : Bool
    {
        if (30 <= ammo) {
            return false;
        }
        ++ammo;
        return true;
    }
    
    /**********************************************************************************************
     *                    DRAW
     **********************************************************************************************/
    
    public override function draw(scene : ALevel) : Void
    {
        super.draw(scene);
        this._figures.rotation = (this.angle + Math.PI / 2) * 180.0 / Math.PI;
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0x00BFB7);
        g.drawCircle(0, 0, 5 + ammo);
        g.beginFill(0x00BFB7);
        g.drawRect((3 > ammo ? -2 : - ammo / 5), -15 - ammo, 4 + ammo / 5, 15);
        // draw health
        for (i in 0...health - 1) {
            g.beginFill(0x00BFB7);
            g.drawCircle(Math.cos(Math.PI / 6 * i) * (10 + ammo), Math.sin(Math.PI / 6 * i) * (10 + ammo), 4);
        }
    }
    
    /**********************************************************************************************
     *                    CLEAN
     **********************************************************************************************/
    
    public override function clean() : Void
    {
        super.clean();
    }
}