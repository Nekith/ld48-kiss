package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.Lib;
import scenes.FirstLevel;

class Main extends Sprite
{
    static function main()
    {
        var stage = Lib.current.stage;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        // entry point
        Lib.current.addChild(new FirstLevel());
        Mouse.hide();
        Lib.current.addChild(new Main());
    }
    
    public var cursor(default, null) : Shape;
    
    public function new()
    {
        super();
        cursor = new Shape();
        var g : Graphics = cursor.graphics;
        g.clear();
        g.beginFill(0x04BF9D);
        g.drawRect(-1, -12, 3, 7);
        g.beginFill(0x04BF9D);
        g.drawRect(-1, 5, 3, 7);
        g.beginFill(0x04BF9D);
        g.drawRect(-12, -1, 7, 3);
        g.beginFill(0x04BF9D);
        g.drawRect(5, -1, 7, 3);
        addChild(cursor);
		var stage = Lib.current.stage;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }
    
    public function onMouseMove(event : MouseEvent) : Void
    {
        cursor.x = event.stageX;
        cursor.y = event.stageY;
    }
}