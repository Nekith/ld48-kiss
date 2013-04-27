package entities;

import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import entities.AEntity;

class Wall extends AEntity
{
    private var _figures : Shape;
    
    public function new(position : Point)
    {
        super(new Rectangle(position.x, position.y, 32, 32));
        this._figures = new Shape();
        var g : Graphics = this._figures.graphics;
        g.clear();
        g.beginFill(0x808080);
        g.drawRect(0, 0, 32, 32);
        addChild(this._figures);
    }
    
    public override function draw() : Void
    {
    }
}