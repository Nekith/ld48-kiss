package scenes;

import flash.display.Graphics;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
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
    private var _pauseText : TextField;
    
    public function new()
    {
        super();
        director = new Director();
        dimension = new Point(1200, 1200);
        player = new Player(new Point(600.0, 600.0));
        addChild(player);
        entities = [];
        director.init(this);
        var tf : TextFormat = new TextFormat();
        tf.size = 24;
        tf.font = "Verdana";
        tf.color = 0x00BFB7;
        tf.align = TextFormatAlign.CENTER;
        this._pauseText = new TextField();
        this._pauseText.defaultTextFormat = tf;
        this._pauseText.text = "ready ?";
        this._pauseText.selectable = false;
        this._pauseText.textColor = 0x00BFB7;
        this._pauseText.x = 300;
        this._pauseText.width = 200;
        this._pauseText.y = 275;
        this._pauseText.height = 100;
        Lib.current.addChild(this._pauseText);
    }
    
    public function findEntities(rect : Rectangle) : Array<AEntity>
    {
        var results : Array<AEntity> = new Array<AEntity>();
        for (entity in entities) {
            if (false == entity.dying && true == rect.intersects(entity.rect)) {
                results.push(entity);
            }
        }
        return results;
    }
    
    public function checkPlaceIsFree(rect : Rectangle) : Bool
    {
        for (entity in entities) {
            if (false == entity.dying && true == rect.intersects(entity.rect)) {
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
        if (true == focus) {
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
        }
        super.update();
        return this;
    }
    
    public override function draw() : Void
    {
        player.draw(this);
        for (entity in entities) {
            entity.draw(this);
        }
        if (false == focus) {
            this._pauseText.visible = true;
        }
        else {
            this._pauseText.visible = false;
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
        Lib.current.removeChild(this._pauseText);
        super.clean();
    }
}