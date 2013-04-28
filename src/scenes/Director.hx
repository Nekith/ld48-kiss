package scenes;

import flash.geom.Point;
import flash.geom.Rectangle;
import scenes.ALevel;
import entities.Turret;
import entities.Dog;
import entities.Wall;
import entities.Ammo;
import entities.Health;

class Director
{
    public var score(default, default) : Int;
    public var level(default, null) : Int;
    public var evilCount(default, default) : Int;
    private var _evil : Int;
    private var _good : Int;
    private var _neutral : Int;
    
    public function new()
    {
        score = 0;
        level = 0;
        evilCount = 0;
        this._evil = 0;
        this._good = 0;
        this._neutral = 0;
    }
    
    public function init(scene : ALevel)
    {
        var i : Int = 0;
        while (i < 30) {
            var p : Point = new Point(40 + Std.random(Std.int(scene.dimension.x) - 80), 40 + Std.random(Std.int(scene.dimension.y) - 80));
            if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Wall.WIDTH / 2, p.y - Wall.HEIGHT / 2, Wall.WIDTH, Wall.HEIGHT))) {
                var w : Wall = new Wall(p);
                scene.addEntity(w);
                ++i;
            }
        }
    }
    
    public function update(scene : ALevel)
    {
        level = 1 + Math.floor(score / 20);
        if (25 > evilCount) {
            this._evil += level;
        }
        ++this._good;
        ++this._neutral;
        // evil
        while (150 <= this._evil) {
            var p : Point = getRandomFreePoint(scene);
            var rand : Int = Std.random(4);
            if (2 >= rand) {
                if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Turret.WIDTH / 2, p.y - Turret.HEIGHT / 2, Turret.WIDTH, Turret.HEIGHT))) {
                    var t : Turret = new Turret(p);
                    scene.addEntity(t);
                    this._evil -= 150;
                    ++evilCount;
                }
            }
            else {
                if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Dog.WIDTH / 2, p.y - Dog.HEIGHT / 2, Dog.WIDTH, Dog.HEIGHT))) {
                    var d : Dog = new Dog(p);
                    scene.addEntity(d);
                    this._evil -= 150;
                    ++evilCount;
                }
            }
        }
        // good
        if (300 <= this._good) {
            var p : Point = getRandomFreePoint(scene);
            if (0 == Std.random(4)) {
                if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Health.WIDTH / 2, p.y - Health.HEIGHT / 2, Health.WIDTH, Health.HEIGHT))) {
                    var h : Health = new Health(p);
                    scene.addEntity(h);
                    this._good -= 300;
                }
            }
            else {
                if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Ammo.WIDTH / 2, p.y - Ammo.HEIGHT / 2, Ammo.WIDTH, Ammo.HEIGHT))) {
                    var a : Ammo = new Ammo(p);
                    scene.addEntity(a);
                    this._good -= 300;
                }
            }
        }
        // neutral
        if (600 <= this._neutral) {
            var p : Point = getRandomFreePoint(scene);
            if (true == scene.checkPlaceIsFree(new Rectangle(p.x - Wall.WIDTH / 2, p.y - Wall.HEIGHT / 2, Wall.WIDTH, Wall.HEIGHT))) {
                var w : Wall = new Wall(p);
                scene.addEntity(w);
                this._neutral -= 600;
            }
        }
    }
    
    public function loot(scene : ALevel, position : Point) : Void
    {
        var r : Int = Std.random(6);
        if (0 == r) {
            scene.addEntity(new Health(position));
        }
        else {
            scene.addEntity(new Ammo(position));
        }
    }
    
    public function getRandomFreePoint(scene : ALevel) : Point
    {
        var p : Point = new Point();
        // x
        if (scene.player.position.x - 400 <= 0 || 0 == Std.random(2)) {
            p.x = scene.player.position.x + 400 + Std.random(Std.int(scene.dimension.x - scene.player.position.x - 400));
        }
        else {
            p.x = Std.random(Std.int(scene.player.position.x - 400));
        }
        if (p.x <= 0) {
            p.x = 40;
        }
        else if (p.x >= scene.dimension.x) {
            p.x = scene.dimension.x - 40;
        }
        // y
        if (scene.player.position.y - 300 <= 0 || 0 == Std.random(2)) {
            p.y = scene.player.position.y + 300 + Std.random(Std.int(scene.dimension.y - scene.player.position.y - 300));
        }
        else {
            p.y = Std.random(Std.int(scene.player.position.y - 300));
        }
        if (p.y <= 0) {
            p.y = 40;
        }
        else if (p.y >= scene.dimension.y) {
            p.y = scene.dimension.y - 40;
        }
        return p;
    }
}