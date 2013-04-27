package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.AEntity;
import entities.Wall;
import entities.Player;

class BadProjectile extends AEntity
{
    private var _figures : Shape;
    
    public function new(position : Point, angle : Float)
    {
        super(new Rectangle(position.x, position.y, 10, 10));
        _canEscapeLevel = true;
        force.x = Math.cos(angle) * 5;
        force.y = Math.sin(angle) * 5;
        this._figures = new Shape();
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0xFFF461);
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
                        break;
                    }
                    if (true == Std.is(e, Player)) {
                        var p : Player = cast(e, Player);
                        p.takeHit(scene);
                        scene.removeEntity(this);
                        this.clean();
                        break;
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