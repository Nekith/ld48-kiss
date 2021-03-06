package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Player;
import entities.Wall;
import entities.Turret;
import entities.Mammoth;
import entities.Dog;

class GoodProjectile extends AEntity
{
    private var _figures : Shape;
    
    public function new(position : Point, angle : Float)
    {
        super(new Rectangle(position.x - 5, position.y - 5, 10, 10));
        _canEscapeLevel = true;
        force.x = Math.cos(angle) * 17;
        force.y = Math.sin(angle) * 17;
        this._figures = new Shape();
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0x04BF9D);
        g.drawRect(0, 0, 10, 10);
        addChild(this._figures);
    }
    
    public override function update(scene : ALevel) : Void
    {
        if (rect.x + rect.width <= 0 || rect.x >= scene.dimension.x || rect.y + rect.height <= 0 || rect.y >= scene.dimension.y) {
            scene.removeEntity(this);
            this.clean();
        }
        else {
            for (i in 1...6) {
                var entities : Array<AEntity> = scene.findEntities(new Rectangle(rect.x + force.x / 6 * i, rect.y + force.y / 6 * i, rect.width, rect.height));
                for (e in entities) {
                    if (true == Std.is(e, Wall)) {
                        var w : Wall = cast(e, Wall);
                        w.takeHit(scene);
                        scene.removeEntity(this);
                        this.clean();
                        return;
                    }
                    if (true == Std.is(e, Turret)) {
                        var t : Turret = cast(e, Turret);
                        t.takeHit(scene);
                        scene.removeEntity(this);
                        this.clean();
                        return;
                    }
                    if (true == Std.is(e, Mammoth)) {
                        var m : Mammoth = cast(e, Mammoth);
                        m.takeHit(scene);
                        scene.removeEntity(this);
                        this.clean();
                        return;
                    }
                    if (true == Std.is(e, Dog)) {
                        var d : Dog = cast(e, Dog);
                        d.takeHit(scene);
                        scene.removeEntity(this);
                        this.clean();
                        return;
                    }
                }
            }
        }
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}