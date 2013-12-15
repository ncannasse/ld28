package ent;

enum Kind {
	Rat;
	Eye;
	Ogre;
	Mage;
	Shot;
}

class Mob extends Entity {

	static var ANIMS = [
		Rat => 3,
		Eye => 5,
		Ogre => 6,
		Mage => 9,
		Shot => 10,
	];
	
	var kind : Kind;
	var dir : Int;
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
			life = 30;
			power = 10;
			bounce = 5;
			ch = 8;
		case Ogre:
			life = 100;
			power = 20;
			ch = 13;
		case Mage:
			ch = 15;
		case Shot:
			cw = ch = 4;
			gravity = 0;
			power = 0;
			dx = 0.001;
			angle = Math.atan2(fight.hero.y - y, fight.hero.x - x);
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
				dx = ((Math.random() * 2) - 1) * 3;
				dir = dx < 0 ? -1 : 1;
			}
		case Ogre:
			if( target == null || dx == 0 || Math.random() < 0.01 * dt )
				target = { x : fight.hero.x, y : fight.hero.y };
			if( dy == 0 && Math.random() < 0.1 * dt )
				dy = -5;
			dx = target.x < x ? -0.5 : 0.5;
		case Mage:
			if( Math.random() < 0.1 * dt )
				dir *= -1;
			if( Math.random() < 0.01 * dt && reload < 0 ) {
				reload = 10;
				new Mob(Shot, x, y - 0.4);
			}
			reload -= dt;
		case Shot:
			if( dx == 0 && dy == 0 && speed > 0 ) onCollide(Lava);
			speed += 0.1 * dt;
			if( speed > 1 ) speed = 1;
			dx = Math.cos(angle) * speed * 3;
			dy = Math.sin(angle) * speed * 3;
		}
		mc.scaleX = -dir;
		if( colWith(fight.hero) ) {
			fight.hero.hit(power * dt);
			if( kind == Shot ) onCollide(Lava);
		}
	}
	
}