class Game extends hxd.App {
	
	public var scene : h2d.Scene;
	public var font : h2d.Font;
	public var world : World;
	
	override function init() {
		scene = s2d;
		s2d.setFixedSize(Const.W, Const.H);
		world = new World(Res.map, Res.tiles);
		s2d.add(world.root, 0);
		font = Res.Minecraftia.build(8, { antiAliasing : false } );
		
		dialog(Text.WELCOME, function() {
			trace("OK");
		});
	}
	
	function dialog( t : Array<String>, ?onDone ) {
		if( t.length == 0 ) {
			if( onDone != null )
				onDone();
			return;
		}
		var d = new Dialog(Const.W, 50, t[0]);
		d.y = Const.H - d.height;
		d.onClick = function() {
			d.remove();
			var t2 = t.copy();
			t2.shift();
			dialog(t2, onDone);
		};
	}
	
	override function update(dt:Float) {
	}
	
	public static var inst : Game;
	static function main() {
		Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create( { compressSounds : true } ));
		inst = new Game();
	}
	
}