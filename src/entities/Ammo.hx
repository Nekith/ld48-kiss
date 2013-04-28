package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Player;
import SoundBank;

class Ammo extends AEntity
{
    static inline public var WIDTH : Int = 24;
    static inline public var HEIGHT : Int  = 24;
    
    private var _figures : Shape;
    private var _angle : Float;
    private var _count : Int;
    
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
        this._angle = 0;
        this._count = 0;
    }
    
    public override function update(scene : ALevel) : Void
    {
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
        this._angle = (this._angle + 3 % 360);
        if (false == dying) {
            ++this._count;
            if (1200 == this._count) {
                scene.removeEntity(this);
                this.clean();
                return;
            }
            if (rect.x + rect.width <= 0 || rect.x >= scene.dimension.x || rect.y + rect.height <= 0 || rect.y >= scene.dimension.y) {
                scene.removeEntity(this);
                this.clean();
            }
            else {
                if (true == scene.player.rect.intersects(rect)) {
                    if (true == scene.player.pickAmmo(scene)) {
                        SoundBank.instance.pick.play();
                        this.dying = true;
                    }
                }
            }
        }
    }
    
    public override function draw(scene : ALevel) : Void
    {
        this._figures.rotation = this._angle;
        super.draw(scene);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}