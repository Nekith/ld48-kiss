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
    public var actors(default, null) : Array<AEntity>;
    private var _pause : Bool;
    private var _pauseText : TextField;
    
    public function new()
    {
        super();
        director = new Director();
        dimension = new Point(1200, 1200);
        player = new Player(new Point(600.0, 600.0));
        addChild(player);
        actors = [];
        director.init(this);
        var tf : TextFormat = new TextFormat();
        tf.size = 24;
        tf.font = "Verdana";
        tf.color = 0x00BFB7;
        tf.align = TextFormatAlign.CENTER;
        this._pause = true;
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
        for (entity in actors) {
            if (false == entity.dying && true == rect.intersects(entity.rect)) {
                results.push(entity);
            }
        }
        return results;
    }
    
    public function checkPlaceIsFree(rect : Rectangle) : Bool
    {
        for (entity in actors) {
            if (false == entity.dying && true == rect.intersects(entity.rect)) {
                return false;
            }
        }
        return true;
    }
    
    public function addEntity(entity : AEntity) : Void
    {
        addChild(entity);
        actors.push(entity);
    }
    
    public function removeEntity(entity : AEntity) : Void
    {
        removeChild(entity);
        actors.remove(entity);
    }
    
    public override function update() : AScene
    {
        if (true == this._pause) {
            for (k in keys) {
                if (true == k) {
                    this._pause = false;
                    break;
                }
            }
        }
        else if (true == focus) {
            player.update(this);
            if (0 == player.health) {
                return new ScoreScreen(director.score);
            }
            for (entity in actors) {
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
        else {
            this._pause = true;
        }
        super.update();
        return this;
    }
    
    public override function draw() : Void
    {
        player.draw(this);
        for (entity in actors) {
            entity.draw(this);
        }
        if (false == focus || true == this._pause) {
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
        for (entity in actors) {
            entity.clean();
        }
        Lib.current.removeChild(this._pauseText);
        super.clean();
    }
}