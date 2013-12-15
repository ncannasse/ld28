package ent;

class Fx extends Entity {

	override function collide(x, y) {
		return false;
	}
	
	override function update(dt:Float) {
		mc.loop = false;
		mc.speed = 8;
		gravity = 0;
		super.update(dt);
		if( mc.currentFrame + 0.01 >= mc.frames.length ) remove();
	}
	
}