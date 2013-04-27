package scenes;

import haxe.Resource;
import haxe.xml.Fast;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.Lib;
import scenes.Director;
import entities.AEntity;
import entities.Player;
import entities.Wall;
import entities.Turret;

import entities.Ammo;

class ALevel extends AScene
{
    public var director(default, null) : Director;
    public var player(default, null) : Player;
    public var entities(default, null) : Array<AEntity>;
    
    public function new(byteArray : ByteArray)
    {
        super();
        entities = [];
        director = new Director();
        var xml : Xml = Xml.parse(byteArray.toString());
        var level : Fast = new Fast(xml.elementsNamed("level").next());
        var items : Fast = new Fast(xml.elementsNamed("items").next());
        var start = level.node.start;
        dimension.x = Std.parseFloat(level.att.x);
        dimension.y = Std.parseFloat(level.att.y);
        player = new Player(new Point(Std.parseFloat(start.att.x), Std.parseFloat(start.att.y)));
        addChild(player);
        for (item in items.nodes.item) {
            var imax : Int = 1;
            var jmax : Int = 1;
            if (true == item.has.repeatx) {
                imax = Std.parseInt(item.att.repeatx);
            }
            if (true == item.has.repeaty) {
                jmax = Std.parseInt(item.att.repeaty);
            }
            for (i in 0...imax) {
                for (j in 0...jmax) {
                    if ("wall" == item.att.type) {
                        var wall : Wall = new Wall(new Point(Std.parseFloat(item.att.x) + 40 * i, Std.parseFloat(item.att.y) + 40 * j));
                        addChild(wall);
                        entities.push(wall);
                    }
                    else if ("turret" == item.att.type) {
                        var turret : Turret = new Turret(new Point(Std.parseFloat(item.att.x) + 40 * i, Std.parseFloat(item.att.y) + 40 * j));
                        addChild(turret);
                        entities.push(turret);
                    }
                }
            }
        }
        var ammo : Ammo = new Ammo(new Point(400, 400));
        addChild(ammo);
        entities.push(ammo);
    }
    
    public function findEntities(rect : Rectangle) : Array<AEntity>
    {
        var results : Array<AEntity> = new Array<AEntity>();
        for (entity in entities) {
            if (true == rect.intersects(entity.rect)) {
                results.push(entity);
            }
        }
        return results;
    }
    
    public function checkPlaceIsFree(rect : Rectangle) : Bool
    {
        for (entity in entities) {
            if (true == rect.intersects(entity.rect)) {
                return false;
            }
        }
        return true;
    }
    
    public function addEntity(entity : AEntity) : Void
    {
        addChild(entity);
        entities.push(entity);
    }
    
    public function removeEntity(entity : AEntity) : Void
    {
        removeChild(entity);
        entities.remove(entity);
    }
    
    public override function update() : AScene
    {
        player.update(this);
        for (entity in entities) {
            entity.update(this);
        }
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
        director.update(this);
        super.update();
        return this;
    }
    
    public override function draw() : Void
    {
        player.draw(this);
        for (entity in entities) {
            entity.draw(this);
        }
        super.draw();
    }
    
    public override function clean() : Void
    {
        removeChild(player);
        player.clean();
        for (entity in entities) {
            entity.clean();
        }
        super.clean();
    }
}