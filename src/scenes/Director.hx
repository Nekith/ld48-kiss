package scenes;

import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.Turret;
import entities.Dog;
import entities.Ammo;

class Director
{
    public var score(default, default) : Int;
    public var level(default, null) : Int;
    private var _evil : Int;
    private var _lastPopAmmo : Int;
    
    public function new()
    {
        score = 0;
        level = 0;
        this._evil = 0;
        this._lastPopAmmo = 0;
    }
    
    public function update(scene : ALevel)
    {
        level = 1 + Math.floor(score / 10);
        if (50 > scene.entities.length) {
            this._evil += level;
            // mob
            while (500 <= this._evil) {
                var p : Point = getRandomFreePoint(scene);
                if (0 == Std.random(2)) {
                    if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Turret.WIDTH / 2, p.y - Turret.HEIGHT / 2, Turret.WIDTH, Turret.HEIGHT))) {
                        var t : Turret = new Turret(p);
                        scene.addEntity(t);
                        this._evil -= 100;
                    }
                }
                else {
                    if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Dog.WIDTH / 2, p.y - Dog.HEIGHT / 2, Dog.WIDTH, Dog.HEIGHT))) {
                        var d : Dog = new Dog(p);
                        scene.addEntity(d);
                        this._evil -= 100;
                    }
                }
            }
            // ammo
            if (300 <= this._lastPopAmmo) {
                var imax : Int = Std.random(3) + 1;
                var i : Int = 0;
                while (i < imax) {
                    var p : Point = getRandomFreePoint(scene);
                    if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Ammo.WIDTH / 2, p.y - Ammo.HEIGHT / 2, Ammo.WIDTH, Ammo.HEIGHT))) {
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
        }
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