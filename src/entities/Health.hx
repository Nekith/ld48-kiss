package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Player;
import SoundBank;

class Health extends AEntity
{
    static inline public var WIDTH : Int = 24;
    static inline public var HEIGHT : Int = 24;
    
    private var _figures : Shape;
    private var _count : Int;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x - Health.WIDTH / 2, position.y - Health.HEIGHT / 2, Health.WIDTH, Health.HEIGHT));
        this._figures = new Shape();
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0xFFFFFF);
        g.drawCircle(0, 0, 8);
        g.beginFill(0x00BFB7);
        g.drawCircle(0, 0, 5);
        addChild(this._figures);
        this._count = 0;
    }
    
    public override function update(scene : ALevel) : Void
    {
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
        if (false == dying) {
            ++this._count;
            if (420 == this._count) {
                scene.addEntity(new Ammo(position));
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
                    if (true == scene.player.pickHealth(scene)) {
                        SoundBank.instance.health.play();
                        this.dying = true;
                    }
                }
            }
        }
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}