package scenes;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.Lib;
import scenes.Director;
import scenes.ScoreScreen;
import entities.AEntity;
import entities.Player;

class ALevel extends AScene
{
    public var director(default, null) : Director;
    public var player(default, null) : Player;
    public var entities(default, null) : Array<AEntity>;
    
    public function new()
    {
        super();
        director = new Director();
        dimension = new Point(1200, 1200);
        player = new Player(new Point(600.0, 600.0));
        addChild(player);
        entities = [];
        director.init(this);
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
        if (0 == player.health) {
            return new ScoreScreen(director.score);
        }
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