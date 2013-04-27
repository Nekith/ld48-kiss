package scenes;

import haxe.Timer;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import entities.AEntity;

class AScene extends Sprite
{
    private var _currentTime : Float = 0;
    private var _accumulator : Float = 0;
    public var dimension(default, null) : Point;
    public var mouse(default, null) : Point;
    public var click(default, null) : Bool;
    public var keys(default, null) : Array<Bool>;
    public var entities(default, null) : Array<AEntity>;
    
    public function new()
    {
        super();
		var stage = Lib.current.stage;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        stage.addEventListener(Event.ENTER_FRAME, onEnter);
        _currentTime = Timer.stamp();
        dimension = new Point(512, 320);
        mouse = new Point(0, 0);
        click = false;
        keys = [];
        entities = [];
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
    
    public function onKeyDown(event : KeyboardEvent) : Void
    {
        if (false == keys[event.keyCode]) {
            keys[event.keyCode] = true;
        }
    }
    
    public function onKeyUp(event : KeyboardEvent) : Void
    {
        keys[event.keyCode] = false;
    }
    
    public function onMouseMove(event : MouseEvent) : Void
    {
        mouse.x = event.stageX;
        mouse.y = event.stageY;
    }
    
    public function onMouseDown(event : MouseEvent) : Void
    {
        click = true;
    }
    
    public function onMouseUp(event : MouseEvent) : Void
    {
        click = false;
    }
    
    public function onEnter(event : flash.events.Event) : Void
    {
        var newTime : Float = Timer.stamp();
        var frameTime : Float = newTime - _currentTime;
        _currentTime = newTime;
        _accumulator += frameTime;
        while (1 / 60.0 <= _accumulator) {
            var scene : AScene = update();
            if (scene != this) {
                var stage = Lib.current.stage;
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
                stage.removeEventListener(Event.ENTER_FRAME, onEnter);
                Lib.current.removeChild(this);
                Lib.current.addChild(scene);
                return;
            }
            _accumulator -= 1 / 60.0;
        }
        draw();
    }
    
    public function update() : AScene
    {
        for (entity in entities) {
            entity.update(this);
        }
        return this;
    }
    
    public function draw() : Void
    {
        for (entity in entities) {
            entity.draw(this);
        }
    }
    
    public function clean() : Void
    {
        for (entity in entities) {
            entity.clean();
        }
    }
}