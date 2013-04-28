package ;

import flash.media.Sound;

@:sound("library/hurt.wav") class HurtSound extends Sound { }
@:sound("library/pick.wav") class PickSound extends Sound { }
@:sound("library/shoot.wav") class ShootSound extends Sound { }
@:sound("library/wall.wav") class WallSound extends Sound { }
@:sound("library/enemy.wav") class EnemySound extends Sound { }
@:sound("library/hit.wav") class HitSound extends Sound { }
@:sound("library/health.wav") class HealthSound extends Sound { }

class SoundBank
{
    static public inline var instance : SoundBank = new SoundBank();
    
    public var hurt(default, null) : HurtSound;
    public var pick(default, null) : PickSound;
    public var shoot(default, null) : ShootSound;
    public var wall(default, null) : WallSound;
    public var enemy(default, null) : EnemySound;
    public var hit(default, null) : HitSound;
    public var health(default, null) : HealthSound;
    
    public function new()
    {
        hurt = new HurtSound();
        pick = new PickSound();
        shoot = new ShootSound();
        wall = new WallSound();
        enemy = new EnemySound();
        hit = new HitSound();
        health = new HealthSound();
    }
}