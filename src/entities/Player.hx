package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.ui.Keyboard;
import haxe.Log;
import scenes.AScene;
import entities.AEntity;

class Player extends AEntity
{
    public var health(default, null) : Int;
    public var ammo(default, null) : Int;
    private var _figures : Shape;
    private var _wasFiring : Bool;
    
    public function new(position : Point)
    {
        var rect : Rectangle = new Rectangle(position.x - 16, position.y - 16, 32, 32);
        super(rect);
        health = 7;
        ammo = 15;
        this._figures = new Shape();
        this._wasFiring = false;
        addChild(this._figures);
    }
    
    /**********************************************************************************************
     *                    UPDATE
     **********************************************************************************************/
    
    public override function update(scene : AScene) : Void
    {
        // movement
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
        // fire
        if (true == scene.keys[Keyboard.SPACE]) {
            if (0 < ammo && false == this._wasFiring) {
                ammo--;
                this._wasFiring = true;
            }
        }
        else {
            this._wasFiring = false;
        }
        if (30 > ammo && true == scene.keys[Keyboard.P]) {
            ammo++;
        }
        // size
        rect.width = (5 + ammo) * 2;
        rect.height = (5 + ammo) * 2;
        // entity update
        super.update(scene);
    }
    
    /**********************************************************************************************
     *                    DRAW
     **********************************************************************************************/
    
    public override function draw() : Void
    {
        super.draw();
        this._figures.x = position.x - rect.x;
        this._figures.y = position.y - rect.y;
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0xFF0000);
        g.drawCircle(0, 0, 5 + ammo);
    }
    
    /**********************************************************************************************
     *                    CLEAN
     **********************************************************************************************/
    
    public override function clean() : Void
    {
        super.clean();
    }
}