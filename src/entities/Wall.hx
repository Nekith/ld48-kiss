package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.AScene;
import entities.AEntity;

class Wall extends AEntity
{
    public var health(default, null) : Int;
    private var _figures : Shape;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x, position.y, 40, 40));
        this._figures = new Shape();
        addChild(this._figures);
        health = 3;
    }
    
    public override function draw(scene : AScene) : Void
    {
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0x808080);
        g.drawRect(0, 0, 40, 40);
    }
    
    public override function clean() : Void
    {
        super.clean();
        removeChild(this._figures);
    }
}