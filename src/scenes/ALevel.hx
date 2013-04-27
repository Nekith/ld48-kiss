package scenes;

import haxe.Resource;
import haxe.xml.Fast;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.Lib;
import entities.AEntity;
import entities.Player;
import entities.Wall;

class ALevel extends AScene
{
    public var player(default, null) : Player;
    
    public function new(byteArray : ByteArray)
    {
        super();
        var xml : Xml = Xml.parse(byteArray.toString());
        var level : Fast = new Fast(xml.elementsNamed("level").next());
        var items : Fast = new Fast(xml.elementsNamed("items").next());
        var start = level.node.start;
        dimension.x = Std.parseFloat(level.att.x);
        dimension.y = Std.parseFloat(level.att.y);
        player = new Player(new Point(Std.parseFloat(start.att.x), Std.parseFloat(start.att.y)));
        addChild(player);
        for (item in items.nodes.item) {
            if ("wall" == item.att.type) {
                var wall : Wall = new Wall(new Point(Std.parseFloat(item.att.x), Std.parseFloat(item.att.y)));
                addChild(wall);
                entities.push(wall);
            }
        }
    }
    
    public override function update() : AScene
    {
        player.update(this);
        super.update();
        x = 400 - player.rect.x + player.rect.width / 2;
        if (x > 0) {
            x = 0;
        }
        else if (x - 800 < -dimension.x) {
            x = -dimension.x + 800;
        }
        y = 300 - player.rect.y + player.rect.height / 2;
        if (y > 0) {
            y = 0;
        }
        else if (y - 600 < -dimension.y) {
            y = -dimension.y + 600;
        }
        return this;
    }
    
    public override function draw() : Void
    {
        player.draw();
        super.draw();
    }
    
    public override function clean() : Void
    {
        removeChild(player);
        player.clean();
        super.clean();
    }
}