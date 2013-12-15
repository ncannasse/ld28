package ent;

enum Kind {
	Rat;
}

class Mob extends Entity {

	static var ANIMS = [
		Rat => 3,
	];
	
	var kind : Kind;
	var dir : Int;
	var power : Float = 1.;
	
	public function new(kind, x, y) {
		this.kind = kind;
		super(ANIMS[kind], x, y);
	}

	override function init() {
		dir = Std.random(2) * 2 - 1;
		switch( kind ) {
		case Rat:
			ch = 8;
		}
	}
		
	override function update( dt : Float ) {
		super.update(dt);
		switch( kind ) {
		case Rat:
			if( dx == 0 ) dir *= -1;
			dx = dir * 2;
		}
		mc.scaleX = -dir;
		if( colWith(fight.hero) )
			fight.hero.hit(power * dt);
	}
	
}