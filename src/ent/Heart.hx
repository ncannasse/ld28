package ent;

class Heart extends Entity {

	public var active = true;
	
	override function update(dt:Float) {
		cw = 5; ch = 5;
		gravity = 0.05;
		super.update(dt);
		if( active ) {
			for( e in fight.entities ) {
				var m = Std.instance(e, Mob);
				if( m == null ) continue;
				if( colWith(m)  ) {
					m.hit(fight.game.stats.att);
					dx = 0;
				}
			}
			if( Math.abs(dx) < 0.3 ) {
				active = false;
				playAnim(2);
				mc.loop = false;
			}
		} else {
			if( mc.currentFrame+.001 >= mc.frames.length )
				remove();
		}
	}
	
}