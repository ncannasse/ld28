package ent;
import hxd.Key in K;

class Hero extends Entity {

	var reload = 0.;
	var killed = false;
	
	override function kill() {
		super.kill();
		if( !killed ) {
			killed = true;
			new Entity(8, x, y).mc.loop = false;
			haxe.Timer.delay(fight.end.bind(false), 2000);
		}
	}
	
	override function update(dt:Float) {
		cw = 8;
		ch = 15;
		var mx = 0;
		if( K.isDown(K.LEFT) || K.isDown("A".code) || K.isDown("Q".code) ) mx = -1;
		if( K.isDown(K.RIGHT)|| K.isDown("D".code) ) mx = 1;
		if( mx != 0 ) {
			mc.scaleX = mx;
			dx = mx;
		}
		if( dy == 0 && (K.isDown(K.UP) || K.isDown("Z".code) || K.isDown("W".code)) ) {
			dy = -3 * 2;
		}
		if( K.isDown(K.SPACE) && reload < 0 ) {
			reload = 60;
			new Heart(1, x + mc.scaleX * 0.3, y - 0.2).dx = mc.scaleX * 3;
		}
		mc.speed = mx == 0 ? 0 : 12;
		reload -= dt;
		super.update(dt);
	}
	
}