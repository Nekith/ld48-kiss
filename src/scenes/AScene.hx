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

class AScene extends Sprite
{
    private var _currentTime : Float = 0;
    private var _accumulator : Float = 0;
    public var dimension(default, null) : Point;
    public var mouse(default, null) : Point;
    public var click(default, null) : Bool;
    public var keys(default, null) : Array<Bool>;
    
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
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
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
        return this;
    }
    
    public function draw() : Void
    {
    }
    
    public function clean() : Void
    {
    }
}