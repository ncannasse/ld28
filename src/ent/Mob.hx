package ent;

enum Kind {
	Rat;
	Eye;
	Ogre;
	Mage;
	Boss;
	Shot;
}

class Mob extends Entity {

	static var ANIMS = [
		Rat => 3,
		Eye => 5,
		Ogre => 6,
		Mage => 9,
		Shot => 10,
		Boss => 11,
	];

	var active : Bool;
	var kind : Kind;
	var dir : Int = 0;
	var power : Float = 1.;
	var speed : Float = 0.;
	var target : { x : Float, y : Float };
	var angle : Float;
	var reload = 0.;

	public function new(kind, x, y) {
		this.kind = kind;
		super(ANIMS[kind], x, y);
	}

	override function init() {
		dir = Std.random(2) * 2 - 1;
		switch( kind ) {
		case Rat:
			power = 3;
			ch = 8;
			dy = gravity;
		case Eye:
			gravity = 0.1;
			life = 15;
			power = 5;
			bounce = 4;
			ch = 8;
		case Ogre:
			life = 100;
			power = 10;
			ch = 13;
		case Mage:
			ch = 15;
			life = 50;
		case Shot:
			reload = 600;
			cw = ch = 4;
			gravity = 0;
			power = 70;
			dx = 0.001;
			angle = Math.atan2(fight.hero.y - y, fight.hero.x - x);
		case Boss:
			life = 600;
			power = 30;
			gravity = 0.3;
		}
	}

	override function onCollide(col) {
		return super.onCollide(col);
	}

	override function update( dt : Float ) {
		super.update(dt);
		switch( kind ) {
		case Rat:
			if( dx == 0 && dy == 0 ) dir *= -1;
			if( dy == 0 ) dx = dir * 2;
		case Eye:
			if( Math.abs(dx) < 0.5 ) {
				dx = ((Math.random() * 2) - 1) * 2.5;
				dir = dx < 0 ? -1 : 1;
			}
		case Ogre:
			if( target == null || dx == 0 || Math.random() < 0.01 * dt )
				target = { x : fight.hero.x, y : fight.hero.y };
			if( dy == 0 && Math.random() < 0.1 * dt ) {
				Res.sfx.jump.play();
				dy = -5;
			}
			dx = target.x < x ? -0.5 : 0.5;
		case Mage:
			if( Math.random() < 0.1 * dt )
				dir *= -1;
			if( Math.random() < 0.01 * dt && reload < 0 ) {
				reload = 10;
				new Mob(Shot, x, y - 0.4);
				Res.sfx.fire.play();
			}
			reload -= dt;
		case Shot:
			reload -= dt;
			if( reload < 0 || (dx == 0 && dy == 0 && speed > 0) ) onCollide(Lava);
			speed += 0.1 * dt;
			if( speed > 1 ) speed = 1;
			dx = Math.cos(angle) * speed * 3;
			dy = Math.sin(angle) * speed * 3;
		case Boss:
			if( !active ) {
				reload -= dt;
				if( reload < 0 ) {
					reload += (0.5 + Math.random()) * 60;
					new Mob(Rat, x, y);
					Res.sfx.fire.play();
				}
				var d = hxd.Math.distance(x - fight.hero.x, y - fight.hero.y);
				if( d < 5 ) {
					Res.sfx.boss.play();
					active = true;
				}
			} else {
				if( target == null || dx == 0 || Math.random() < 0.01 * dt )
					target = { x : fight.hero.x, y : fight.hero.y };
				if( dy == 0 && Math.random() < 0.1 * dt ) {
					Res.sfx.jump.play();
					dy = -5;
				}
				dx = target.x < x ? -0.5 : 0.5;
			}
		}
		mc.scaleX = -dir;
		if( colWith(fight.hero) ) {
			fight.hero.hit(power * dt);
			if( kind == Shot ) onCollide(Lava);
		}
	}

}