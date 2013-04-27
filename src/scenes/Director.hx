package scenes;

import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.Turret;
import entities.Ammo;

class Director
{
    public var level(default, null) : Int;
    private var _time : Int;
    private var _evil : Int;
    private var _lastPopAmmo : Int;
    
    public function new()
    {
        level = 0;
        this._time = 0;
        this._evil = 0;
        this._lastPopAmmo = 0;
    }
    
    public function update(scene : ALevel)
    {
        if (0 == _time % 2400) {
            ++level;
        }
        this._evil += level;
        // mob
        while (500 <= this._evil) {
            var p : Point = getRandomFreePoint(scene);
            if (true == scene.checkPlaceIsFree(new Rectangle(p.x, p.y, Turret.WIDTH, Turret.HEIGHT))) {
                var t : Turret = new Turret(p);
                scene.addEntity(t);
                this._evil -= 100;
            }
        }
        // ammo
        if (300 <= this._lastPopAmmo) {
            var imax : Int = Std.random(3) + 1;
            var i : Int = 0;
            while (i < imax) {
                var p : Point = getRandomFreePoint(scene);
                if (true == scene.checkPlaceIsFree(new Rectangle(p.x, p.y, Ammo.WIDTH, Ammo.HEIGHT))) {
                    var a : Ammo = new Ammo(p);
                    scene.addEntity(a);
                    ++i;
                }
            }
            this._lastPopAmmo = 0;
        }
        else {
            ++this._lastPopAmmo;
        }
        ++this._time;
    }
    
    public function getRandomFreePoint(scene : ALevel) : Point
    {
        var p : Point = new Point();
        if (scene.player.position.x - 400 <= 0 || 0 == Std.random(2)) {
            p.x = scene.player.position.x + 400 + Std.random(Std.int(scene.dimension.x - scene.player.position.x - 400));
        }
        else {
            p.x = Std.random(Std.int(scene.player.position.x - 400));
        }
        if (scene.player.position.y - 300 <= 0 || 0 == Std.random(2)) {
            p.y = scene.player.position.y + 300 + Std.random(Std.int(scene.dimension.y - scene.player.position.y - 300));
        }
        else {
            p.y = Std.random(Std.int(scene.player.position.y - 300));
        }
        return p;
    }
}