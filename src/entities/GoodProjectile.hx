package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.AScene;
import entities.AEntity;
import entities.Wall;
import entities.Player;

class GoodProjectile extends AEntity
{
    private var _figures : Shape;
    
    public function new(position : Point, angle : Float)
    {
        super(new Rectangle(position.x, position.y, 10, 10));
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
    
    public override function update(scene : AScene) : Void
    {
        position.x += force.x;
        position.y += force.y;
        super.update(scene);
        if (rect.x + rect.width <= 0 || rect.x >= scene.dimension.x || rect.y + rect.height <= 0 || rect.y >= scene.dimension.y) {
            scene.removeEntity(this);
            this.clean();
        }
        else {
            var entities : Array<AEntity> = scene.findEntities(rect);
            for (e in entities) {
                if (true == Std.is(e, Wall)) {
                    var w : Wall = cast(e, Wall);
                    w.takeHit(scene);
                    scene.removeEntity(this);
                    this.clean();
                    break;
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