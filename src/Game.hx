class Game extends hxd.App {
	
	var world : World;
	
	override function init() {
		s2d.setFixedSize(Const.W, Const.H);
		world = new World(Res.map, Res.tiles);
		s2d.add(world.root,0);
	}
	
	override function update(dt:Float) {
	}
	
	static var inst : Game;
	static function main() {
		Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create( { compressSounds : true } ));
		inst = new Game();
	}
	
}