package ent;

class Exit extends Entity {
	
	override function init() {
		cw = 0;
		ch = 8;
		mc.speed = 0;
		mc.loop = false;
	}
	
	public function open() {
		mc.speed = 5;
	}
	
	override function update(dt:Float) {
		super.update(dt);
		if( mc.speed > 0 && colWith(fight.hero) )
			fight.end(true);
	}
	
}