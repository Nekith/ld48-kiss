package scenes;

import flash.display.Shape;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;
import scenes.FirstLevel;

class ScoreScreen extends AScene
{
    private var _score : Int;
    private var _text : TextField;
    
    public function new(score : Int)
    {
        super();
        this._score = score;
        var tf : TextFormat = new TextFormat();
        tf.size = 24;
        tf.font = "Verdana";
        tf.color = 0x00BFB7;
        tf.align = TextFormatAlign.CENTER;
        this._text = new TextField();
        this._text.defaultTextFormat = tf;
        this._text.text = Std.string(score);
        this._text.selectable = false;
        this._text.textColor = 0x00BFB7;
        this._text.x = 300;
        this._text.width = 200;
        this._text.y = 275;
        this._text.height = 100;
        addChild(this._text);
    }
    
    public override function update() : AScene
    {
        for (k in keys) {
            if (true == k) {
                clean();
                return new FirstLevel();
            }
        }
        return this;
    }
}