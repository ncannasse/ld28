package ent;

enum Kind {
	Rat;
	Eye;
	Ogre;
}

class Mob extends Entity {

	static var ANIMS = [
		Rat => 3,
		Eye => 5,
		Ogre => 6,
	];
	
	var kind : Kind;
	var dir : Int;
	var power : Float = 1.;
	var target : { x : Float, y : Float };
	
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
		case Eye:
			gravity = 0.1;
			life = 30;
			power = 10;
			ch = 8;
		case Ogre:
			life = 100;
			power = 20;
			ch = 13;
		}
	}
		
	override function update( dt : Float ) {
		super.update(dt);
		switch( kind ) {
		case Rat:
			if( dx == 0 ) dir *= -1;
			dx = dir * 2;
		case Eye:
			if( dy == 0 ) {
				gravity *= -1;
				dy = -gravity;
			}
			if( Math.abs(dx) < 0.5 ) {
				dx = ((Math.random() * 2) - 1) * 3;
			}
		case Ogre:
			if( target == null || dx == 0 || Math.random() < 0.01 * dt )
				target = { x : fight.hero.x, y : fight.hero.y };
			if( dy == 0 && Math.random() < 0.1 * dt )
				dy = -5;
			dx = target.x < x ? -0.5 : 0.5;
		}
		mc.scaleX = -dir;
		if( colWith(fight.hero) )
			fight.hero.hit(power * dt);
	}
	
}