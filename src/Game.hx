class Game extends hxd.App {
	
	override function init() {
		engine.backgroundColor = 0xFFFF0000;
	}
	
	override function update(dt:Float) {
	}
	
	static var inst : Game;
	static function main() {
		inst = new Game();
	}
	
}