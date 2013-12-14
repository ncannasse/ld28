class Game extends hxd.App {
	
	override function init() {
		s2d.setFixedSize(Const.W, Const.H);
	}
	
	override function update(dt:Float) {
	}
	
	static var inst : Game;
	static function main() {
		inst = new Game();
	}
	
}