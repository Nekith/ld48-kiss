package scenes;

import flash.ui.Keyboard;
import flash.Lib;
import flash.utils.ByteArray;
import scenes.ALevel;

@:file("library/levels/first.xml") class FirstLevelByteArray extends ByteArray { }

class FirstLevel extends ALevel
{
    public function new()
    {
        super(new FirstLevelByteArray());
    }
}